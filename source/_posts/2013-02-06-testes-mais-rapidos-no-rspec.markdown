---
author: Rafael Lima
layout: post
title: "Testes (bem) mais rápidos no RSpec"
date: 2013-02-06 15:45
comments: true
categories: 
  - rails
  - rspec
  - tests
  - ruby
  - rafael lima
---

Conforme um projeto vai crescendo, a quantidade de casos de teste aumenta e a tendência é que a suíte completa comece a demorar mais para rodar, principalmente se você está fazendo testes de aceitação. Isso pode virar um problema muito grave em projetos legados, mas existem soluções rápidas (a.k.a marretas) que resolvem esse problema. Vou mostrar neste post como fiz para **reduzir em mais de 70% o tempo de execução da suíte de testes** de um projeto.
<!-- more -->

Se você está começando um projeto novo, eu sugiro seguir as [recomendação do Nando Vieira](http://simplesideias.com.br/fazendo-os-seus-testes-executarem-mais-rapido), que incluem decisões de como escrever o código de forma limpa, e que não vão criar gargalos para os testes.

No meu caso o buraco era mais embaixo e eu precisava de algo antes de sair refatorando tudo. Eu estava trabalhando num projeto Rails que possui um pouco menos de 8.000 linhas de código e um pouco mais de 30.000 linhas de teste, um Code to Test Ratio de 1:3.9 e mais de 5.000 testes.
Tanto o código quanto os testes precisavam de melhorias e a suíte estava demorando cerca de **13 minutos para rodar**. Tempo que qualquer um sabe que é ridiculamente alto e inviável para se trabalhar.

```
rake

Finished in 13 minutes 27.67 seconds
5162 examples, 0 failures, 16 pending
```

Eu precisava refatorar os testes, mas também o código e isso exigia um tempo de trabalho considerável.
Eu praticamente tinha um problema de "referência circular", ou [efeito Tostines](http://www.youtube.com/watch?v=tJ-BKu-WUEk). Eu precisava refatorar para ter os testes mais rápidos, mas também precisava dos testes mais rápidos para poder trabalhar e conseguir refatorar.

Enfim, uma situação desconfortável e que iria demandar paciência e um bocado de trabalho, principalmente no início.
Não havia mágica para resolver de uma vez, então eu comecei a buscar soluções que diminuíssem a dor do momento.

O resultado foi que **reduzi o tempo de execução dos testes de 13 minutos para 4 minutos**, sem refatorar o código e mexendo muito pouco nos testes. Eu sei que 4 minutos ainda é muito e tem que melhorar, mas para a realidade do momento, já estava ótimo!

Seguem as dicas do que eu fiz com as referências. As duas primeiras eu retirei do [post do José Valim](http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/)

### Dica 1: Shared Connections

O meu projeto tem testes de aceitação usando [capybara](https://github.com/jnicklas/capybara) e [capybara-webkit](https://github.com/thoughtbot/capybara-webkit) e eu usava a gem [database_cleaner](https://github.com/bmabey/database_cleaner) para limpar o banco de dados entre um teste e outro, como sugerido pelo próprio Capybara.

O problema é que o database cleaner torna a suíte muito lenta, por que a todo momento ele está acessando o banco de dados para limpar a base toda. A solução é fazer uma marreta no ActiveRecord para que o database cleaner não seja mais necessário.

Removi o database cleaner e voltei a configuração `use_transactional_fixtures` pra `true`

```ruby
# spec/spec_helper.rb
RSpec.configure do |config|
  [...]

  config.use_transactional_fixtures = true
end
```

Adicionei o código abaixo:

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

Esse código faz com que o ActiveRecord compartilhe a mesma conexão com o banco de dados em todas as threads. Na prática os testes do Capybara acabam rodando dentro de uma transação, então qualquer modificação no banco de dados não é comitada e é descartada a cada teste.


### Dica 2: Increase Log Level

Por default o Rails grava log de tudo que acontece no environment `test`. Isso faz com que o acesso à disco seja muito alto, o que torna a execução dos testes mais lenta. Aumentando o nível do log você reduz o IO durante os testes. Para isso, adicionei o código abaixo:

```ruby
# spec/support/suppress_log.rb

Rails.logger.level = 4 unless ENV['WITH_LOG']
```

Se você quiser que o log seja gravado, basta setar a variável de ambiente `WITH_LOG` para true.

```bash
$ WITH_LOG=true rake
```

### Dica 3: Deferred Garbage Collection

Quando os testes rodam, muitas variáveis são criadas na memória, o que consome muita memória e faz com que o Garbage Collector seja chamado diversas vezes. Se zerarmos as variáveis de instância e controlarmos "na mão" o Garbage Collector, conseguimos um ganho de performance bastante significativo.

Misturando [isso](http://37signals.com/svn/posts/2742-the-road-to-faster-tests) com [isso](https://makandracards.com/makandra/950-speed-up-rspec-by-deferring-garbage-collection) eu escrevi e adicionei o código abaixo:

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

Para instalar a gem, basta colocar a linha abaixo no Gemfile:

```ruby
# add to Gemfile
gem "parallel_tests", :group => :development
```

Eu deixei o parallel tests como opção default do rake, incluindo a seguinte rake task:

```ruby
# lib/tasks/default.rake

task(:default).clear
task :default  => "parallel:spec"
```

BTW eu fiz um [commit no guard-rspec](https://github.com/rafaelp/guard-rspec/commit/7bfdd649e85d3700716be2fd43277c10aa6cb8df) para ele suportar o parallel tests.

Rodando os testes em paralelo, você aproveita o máximo que da CPU, mas também consome muita bateria. Não recomendado se você estiver trabalhando durante um vôo, por exemplo :)

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

Os testes rodando em paralelo demoraram 4 minutos e 53 segundos e isso é um ganho incrível comparado com os 13 minutos iniciais. Críticos de plantão, eu sei que 4 minutos e pouco ainda é bastante e que dá pra melhorar ;-)

### Dica 5: Ruby Patch railsexpress

Existe um patch para as versões 1.8.7, 1.9.2 e 1.9.3 do Ruby que diminui o tempo de load do Rails e de execução dos testes.

Para usar é muito fácil.

Se você estiver no Mac OS, instale o automake:

```bash
brew install automake 
```

Agora rode o comando abaixo:

```bash
rvm reinstall 1.9.3 --patch railsexpress
```
(substitua 1.9.3 pela versão do ruby que você está usando)

Depois defina duas variáveis de ambiente:

```bash
# add to .bash_profile
export RUBY_GC_MALLOC_LIMIT=60000000
export RUBY_FREE_MIN=200000
```

Pronto!

Se quiser ler mais sobre isso:

[https://gist.github.com/4136519](https://gist.github.com/4136519)

[https://github.com/skaes/rvm-patchsets](https://github.com/skaes/rvm-patchsets)

[https://github.com/wayneeseguin/rvm/tree/master/patches/ruby/1.9.3/p374/railsexpress](https://github.com/wayneeseguin/rvm/tree/master/patches/ruby/1.9.3/p374/railsexpress)

### Resultado Final: Ganho de mais de 70% de tempo

Quando eu instalei esse patch do Rails, eu já tinha 203 testes a mais escritos no projeto e a suíte estava demorando 322.394261 segundos rodando em parelelo. Ou seja, mais tempo do que o benchmark anteior. Após aplicar o patch esse tempo diminuiu para 245.99421 segundos, menos tempo que o benchmark anterior!

```
rake

5366 examples, 0 failures, 9 pendings
Took 245.99421 seconds
```

Com esses resultados, posso afirmar que o ganho de tempo total para o meu projeto foi superior a 70%. 
Nada mal, sair de 13 minutos para 4 minutos, não acha!?

### Bônus: Guard + Zeus

Quando eu estou programando, não fico rodando os testes todos, até por que 4 minutos ainda é inviável para fazer TDD. Para resolver ese problema comecei a usar o [guard-rspec](https://github.com/guard/guard-rspec) com [zeus](https://github.com/burke/zeus) e [tags do RSpec](https://www.relishapp.com/rspec/rspec-core/v/2-4/docs/command-line/tag-option).

O guard é responsável por monitorar as mudanças nos arquivos e rodar testes específicos que são relativos ao arquivo alterado. O guard-rspec é uma gem que se encarrega de chamar o rspec com os parâmteros corretos para que isso aconteça.

O zeus é um aplicativo que pré carrega o stack do Rails na memória e quando você roda os comandos que precisam do environment do Rails, ele busca o que já está carregado na memória.

As tags do RSpec permitem que você defina uma ou mais tags em um teste e passe um parâmetro na linha de comando `rspec` para que somente os testes com aquela tag sejam rodados.

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

No meu ciclo de TDD, eu deixo o guard testando automaticamente os arquivos que ele detecta que foram modificados. Em algums momentos eu quero validar apenas um teste, e é muito chato ter que esperar todos os testes do arquivo que estou trabalhando, todas as vezes que eu o salvo.

Você pode perceber que no meu Guarfile eu passo o parâmetro `--tag focus` para o rspec. Isso faz com que ele rode apenas os testes com a tag `focus`. Quando nenhum teste possui essa tag, ele roda todos os testes do arquivo.

Como eu também passo o parâmetro `--fail-fast`, o rspec pára no primeiro teste que quebra.

Quando estou escrevendo um teste novo em um arquivo com muitos testes ou quando um dos testes quebra, eu coloco a tag `focus` no teste em questão, ou no contexto inteiro dele. A partir daí o guard roda somente este teste a cada vez que eu salvo o arquivo. Isso agiliza muito o meu trabalho, pois não preciso esperar todos os testes do arquivo serem rodados, ou seja, os testes que eu quero validar são executados de imediato.

Para colocar a tag, basta passar um hash `{focus: true}` como segundo parâmetro do `describe`, do `context` ou do `it`. Veja um exemplo de como colocar essa tag:

```ruby
describe "welcome" do
  let(:account) { Account.make }
  let(:mailer) { AccountMailer.welcome(account) }
  it { expect { mailer }.not_to raise_error }
  it { expect { mailer.deliver }.not_to raise_error }
  it { expect { mailer.deliver }.to change(ActionMailer::Base.deliveries,:size).by(1) }
  context "mailer", focus: true do
    it { mailer.subject.should == "Muito obrigado por estar conosco" }
    it { mailer.header['From'].to_s.should == "Suporte <suporte@example.com>" }
    it { mailer.header['To'].to_s.should == "Nome do Usuario <emaildousuario@example.com>" }
    it { mailer.from.size.should == 1 }
    it { mailer.to.size.should == 1 }
    it { mailer.cc.should be_nil }
    it { mailer.bcc.should be_nil }
    it { mailer.multipart?.should be_false }
    it { mailer.charset.should == "UTF-8" }
    it { mailer.content_type.should == "text/html; charset=UTF-8" }
  end
end
```

### Conclusão

Mesmo com problemas no código e testes mal escritos eu consegui reduzir o tempo de execução da suíte e criar um fluxo de trabalho que me permitiu fazer TDD e trabalhar para refatorar tudo, sem perder muito tempo no início. Na prática isso viabilizou a continuidade do trabalho e diminuiu significativamente a dor de ter uma suíte lenta. Uma suíte de testes lenta é um perigo por que nos leva a não querer rodar os testes e ignorar TDD.

Ainda tenho um bom caminho pela frente para melhorar o código atual, mas chegou num nível que já consigo refatorar o que existe em paralelo com desenvolver novas features.

Se uma das dicas já for algo útil pra você, ficarei feliz! Fique a vontade para dar o seu feedback nos comentários ou falar comigo pelo twitter [@rafaelp](https://twitter.com/rafaelp)

Abraços e até a próxima.
