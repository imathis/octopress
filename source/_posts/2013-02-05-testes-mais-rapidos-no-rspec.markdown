---
published: false
author: Rafael Lima
layout: post
title: "(Em Rascunho) Testes mais rápidos no RSpec"
date: 2013-02-06 09:00
comments: true
categories: 
  - rails
  - rspec
  - tests
  - ruby
---

# Não publique ainda!!!

Conforme um projeto vai crescendo, a quantidade de casos de teste aumenta e a tendência é que a suíte completa comece a demorar mais para rodar, principalmente se você está fazendo testes de aceitação. Isso pode virar um problema muito grave em projetos legados, mas existem soluções rápidas (a.k.a marretas) que resolvem esse problema.
<!-- more -->

Se você está começando um projeto novo, eu sugiro seguir as [recomendação do Nando Vieira](http://simplesideias.com.br/fazendo-os-seus-testes-executarem-mais-rapido), que incluem decisões de como escrever o código de forma limpa, e que não vão criar gargalos para os testes.

No meu caso, eu estava trabalhando num projeto Rails que possui um pouco menos de 8.000 linhas de código e um pouco mais de 30.000 linhas de teste, um Code to Test Ratio é de 1:3.9 e mais de 5.000 testes.
Tanto o código quanto os testes precisavam de melhorias e a suíte estava demorando cerca de **13 minutos para rodar**. Tempo que qualquer um sabe que é ridiculamente alto e inviável para se trabalhar.

```
rake

Finished in 13 minutes 27.67 seconds
5162 examples, 0 failures, 16 pending
```

Eu precisava refatorar os testes, mas também o código e isso exigia um tempo de trabalho considerável.
Eu praticamente tinha um problema de "referência circular", ou [efeito Tostines](http://www.youtube.com/watch?v=tJ-BKu-WUEk). Eu precisava refatorar para ter os testes mais rápidos, mas também precisava dos testes mais rápidos para poder trabalhar e conseguir refatorar.

Enfim, uma situação desconfortável e que iria demandar paciência e um bocado de trabalho, principalmente no início.
Não havia mágica para resolver de uma vez, então eu comecei a buscar soluções que amenizassem a dor do momento.

O resultado foi que **reduzi o tempo de execução dos testes de 13 para menos de 5 minutos**, sem refatorar o código e mexendo muito pouco nos testes. Eu sei que 5 minutos continua muito e pode melhorar, mas para a realidade do momento, já estava ótimo!

Seguem as dicas, as duas primeiras eu retirei do [post do José Valim](http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/)

### Dica 1: Shared Connections

Esse projeto possui testes de aceitação usando [capybara](https://github.com/jnicklas/capybara) e [capybara-webkit](https://github.com/thoughtbot/capybara-webkit) e eu usava a gem [database_cleaner](https://github.com/bmabey/database_cleaner) para limpar o banco de dados entre um teste e outro, como sugerido pelo próprio capybara.

O problema é que o database cleaner torna a suíte muito lenta, por que a todo momento ele está acessando o banco de dados para limpar a base toda.

Removi o database cleaner e voltei a configuração `use_transactional_fixtures` pra `true`

```ruby
# spec/spec_helper.rb
RSpec.configure do |config|
  [...]

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
end
```

Inclui o código abaixo:

```ruby
# spec/support/shared_connection.rb
class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil
 
  def self.connection
    @@shared_connection || retrieve_connection
  end
end
 
# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
```

Esse código faz com que o ActiveRecord compartilhe a mesma conexão com o banco de dados em todas as threads. Na prática os testes do Capybara acabam rodando dentro de uma transação, então qualquer modificação no banco de dados, não é comitada e é descartada a cada teste.


### Dica 2: Increase Log Level

```ruby
# spec/support/suppress_log.rb

# Rails by default logs everything that is happening in your test environment to “log/test.log”.
# By increasing the logger level, you will be able to reduce the IO during your tests.
# The only downside of this approach is that, if a test is failing, you won’t have anything logged.
# In such cases, just comment the configuration option above and run your tests again.
Rails.logger.level = 4 unless ENV['WITH_LOG']
```

### Dica 3: Deferred Garbage Collection

Misturando [isso](http://37signals.com/svn/posts/2742-the-road-to-faster-tests) com [isso](https://makandracards.com/makandra/950-speed-up-rspec-by-deferring-garbage-collection) eu cheguei no código abaixo. 

Quando os testes rodam, muitas variáveis são criadas na memória que consomem muita memória e fazem com que o Garbage Collector seja chamado diversas vezes. O código abaixo faz duas coisas, primeiro zera as variáveis de instância e segundo controla "na mão" o Garbage Collector para que ele rode menos vezes. Se usar esse recurso em cuidado pode ser que você deprecie sua máquina muito rapidamente. Basta incluir o arquivo que seus testes ficarão bem mais rápidos!

```ruby
# spec/support/deferred_garbage_collection.rb

class DeferredGarbageCollection
  RESERVED_IVARS = %w(@loaded_fixtures)
  DEFERRED_GC_THRESHOLD = (ENV['DEFER_GC'] || 10.0).to_f
  @@last_gc_run = Time.now
  def self.start
    GC.disable if DEFERRED_GC_THRESHOLD > 0
  end
  def self.reconsider
    if DEFERRED_GC_THRESHOLD > 0 && Time.now - @@last_gc_run >= DEFERRED_GC_THRESHOLD
      GC.enable
      GC.start
      GC.disable
      @@last_gc_run = Time.now
    end
  end
end

RSpec.configure do |config|
  config.before(:all) do
    DeferredGarbageCollection.start
  end
  config.after(:each) do
   (instance_variables - DeferredGarbageCollection::RESERVED_IVARS).each do |ivar|
     instance_variable_set(ivar, nil)
   end
  end
  config.after(:all) do
    DeferredGarbageCollection.reconsider
  end
end
```

### Resultado: Ganho de 45% de tempo

Com as implementações acima já consegui ganhar 6 minutos!

```
rake
Finished in 7 minutes 27.48 seconds
5161 examples, 0 failures, 16 pending
```

(sim, eu removi um teste nesse meio tempo)

### Dica 4: Parallel Tests

Um outro artifício que, não faz com que os testes rodem mais rápidos efetivamente, mas faz com você perca menos tempo ao rodar a suíte, é paralelizar os testes. A gem responsável por isso é a [parallel_tests](https://github.com/grosser/parallel_tests)

Para instalar basta colocar a linha abaixo no Gemfile:

```ruby
# add to Gemfile
gem "parallel_tests", :group => :development
```

Eu deixei minha opção default do rake para rodar com o parallel tests, incluindo a seguinte rake task:

```ruby
# lib/tasks/default.rake

task(:default).clear
task :default  => "parallel:spec"
```

Para quem usa Guard, eu fiz um [commit no guard-rspec](https://github.com/rafaelp/guard-rspec/commit/7bfdd649e85d3700716be2fd43277c10aa6cb8df) para ele suportar o parallel tests.

Rodando os testes em paralelo, você aproveita o máximo que sua CPU pode dar, mas também consome muita bateria. Não recomendado se você estiver trabalhando durante um vôo, por exemplo :)

### Resultado: Testes rodando em menos de 5 minutos

```
rake

Results:
1545 examples, 0 failures, 10 pending
1188 examples, 0 failures, 3 pending
1292 examples, 0 failures, 2 pending
1138 examples, 0 failures, 1 pending

Took 272.119908 seconds
```

Os testes rodando em paralelo demoraram 4 minutos e 53 segundos e isso é um ganho incrível comparado com os 13 minutos iniciais. Críticos de plantão, eu sei que ainda é bastante e que dá pra melhorar ;-)

### Bônus: Guard + Zeus

Quando eu estou programando, não fico rodando os testes todos, até por que 5 minutos ainda é inviável para fazer TDD. Para resolver ese problema comecei a usar o [guard-rspec](https://github.com/guard/guard-rspec) com [zeus](https://github.com/burke/zeus) e [tags do rspec](https://www.relishapp.com/rspec/rspec-core/v/2-4/docs/command-line/tag-option).

O guard é responsável por monitorar as mudanças nos arquivos e rodar testes específicos que são relativos ao arquivo alterado. O guard-rspec é uma gem que se encarrega de chamar o rspec com os parâmteros corretos para que isso aconteça.

O zeus é um application checkpointer (não sei a tradução disso) que pré carrega o stack do Rails na memória e quando você roda os comandos que precisam do environment do Rails, ele busca o que já está carregado na memória.

As tags do rspec permitem que você defina uma ou mais tags em um teste e passe um parâmetro na linha de comando para que o rspec só rode os testes com aquela tag.

Instalando o zeus:

```
gem install zeus
```

Instalando o guard-spec:

```ruby
# add to Gemfile
gem "guard-rspec", :group => :development
```

Meu Guadfile, arquivo de configuração do guard para o projeto:

```ruby
# Guadfile

notification :growl

guard 'rspec', :cli => "--tag focus --color --fail-fast", :all_after_pass => false, :all_on_start => false, :zeus => true, :parallel => false do
  watch('spec/spec_helper.rb')                        { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }

  # Rspec support
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }

  # Blueprints
  watch(%r{^spec/blueprints.rb$})                    { "spec" }

  # Capybara
  watch(%r{^spec/acceptance/(.+)\.rb$})
end
```

Agora basta abrir duas janelas do terminal e deixar uma rodando o zeus e outra o guard:

```bash
$ zeus start
```

```bash
$ guard start
```

No meu ciclo de TDD, eu deixo o guard testando os arquivos todos que ele detecta que são importantes. Em algums momentos eu quero trabalhar em apenas um teste e é muito chato ter que rodar todos os testes de um arquivo todas vezes que eu o salvo.
Você pode perceber que no meu Guarfile eu passo o parâmetro `--tag focus` para o rspec. Isso faz com que ele rode apenas os testes com a tag `focus`. Quando nenhum teste possui essa tag, ele roda todos os testes do arquivo.

Como eu também passo o parâmetro `--fail-fast` o rspec para no primeiro teste que quebra.

Nessa hora eu coloco a tag `focus` neste teste, ou no contexto inteiro dele, e a partir daí o guard fica rodando somente este teste a cada vez que eu salvo o arquivo. Para colocar a tag, basta passar um hash `{focus: true}` como segundo parâmetro do `describe`, do `context` ou do `it` Veja um exemplo de como colocar essa tag:

```ruby
describe "welcome" do
  let(:mailer) {
    Timecop.freeze(2011,06,05,10,20,30) { @mailer = AccountMailer.welcome(@account) }
    @mailer
  }
  it { expect { mailer }.not_to raise_error }
  it { expect { mailer.deliver }.not_to raise_error }
  it { expect { mailer.deliver }.to change(ActionMailer::Base.deliveries,:size).by(1) }
  context "mailer", focus: true do
    it { mailer.subject.should == "Muito obrigado por estar conosco" }
    it { mailer.header['From'].to_s.should == "\"Rafael Lima (Cobre Grátis)\" <suporte@cobregratis.com.br>" } # Ele coloca as aspas por que reconhece que existe um caracter UTF-8 (acento)
    it { mailer.header['To'].to_s.should == "Nome do Usuario <emaildousuario@example.com>" } # Ele não coloca as aspas por que não receonhece nenhum caracter UTF-8 (acento)
    it { mailer.from.size.should == 1 }
    it { mailer.to.size.should == 1 }
    it { mailer.cc.should be_nil }
    it { mailer.bcc.should be_nil }
    it { mailer.multipart?.should be_false }
    it { mailer.charset.should == "UTF-8" }
    it { mailer.content_type.should == "text/html; charset=UTF-8" }
    it { mailer.body.to_s.should == read_mail("welcome", @account.tracking_uid, "*|TRACKING_UID|*") }
  end
end
```

### Conclusão

Mesmo com problemas no código e testes mal escritos eu consegui reduzir o tempo de execução da suíte e criar um fluxo de trabalho que me permitiu fazer TDD e trabalhar para refatorar tudo, sem perder muito tempo no início. Na prática isso viabilizou a continuidade do trabalho e diminuiu significativamente a dor de ter uma suíte lenta. Uma suíte de testes lenta é um perigo por que nos leva a não querer rodar os testes e ignorar TDD.

Ainda tenho um bom caminho pela frente para melhorar o código atual, mas chegou num nível que já consigo refatorar o que existe em paralelo com desenvolver novas features.

Abraços e até a próxima.