---
published: true
author: Thiago Borges
layout: post
title: "The 12 Factor app"
date: 2013-07-10 14:00
comments: true
categories:
  - Thiago Borges
  - Deploy
  - Boas praticas
  - SaaS
  
---

Aplicações web estão muito populares e se tornando preferência pelas vantagens que os SaaS (Software as a Service) oferecem.

* Não precisam ser instalados na máquina de quem usa;
* É muito mais fácil de atualizar;
* O cliente não precisa se preocupar com a infraestrutura;
* Geralmente, só precisa de um navegador e conexão com internet.

<!-- more -->

Com tanta popularidade, esse tipo de sistema recebe diversas sugestões de boas práticas. E o [12 factor][12factor] é um destes guide lines. Este guia é independente de linguagem de programação e foi criado por Adam Wiggins, Co-fundador do [heroku][], um dos mais conhecidos PaaS (Platform as a Service).

Nesse post, falarei um pouco sobre alguns dos *factors* que merecem atenção especial.

### Codebase

Use algum sistema de versionamento distribuído. O Git é o mais recomendado hoje e evita soluções toscas como copiar o projeto inteiro em outro diretório para em seguida, adicionar features e fazer alguns experimentos.

Em um sistema ideal, existem, no mínimo, versões de _staging_ e _production_ no ar. Todas executando o mesmo codebase, mas possivelmente versões (commits) diferentes. Os servidores do _staging_ e _production_ devem ter a mesma configuração. Lembrando  que o _staging_ deve ser constantemente atualizado para evitar o famoso "mas funcionou na minha máquina" na hora de enviar para a produção.

Ter o mesmo **codebase** em todos os ambientes acaba forçando o desenvolvedor a utilizar algumas boas práticas, como: não usar o path absoluto para NADA ou impedir que ele altere o código diretamente no servidor.


### Dependências

A maioria das linguagens possui sistemas de pacotes para distribuição de bibliotecas. Por exemplo: no Ruby é o _RubyGems_. Uma aplicação que segue os *12 factors* nunca confia em um pacote que supostamente deveria estar no sistema. As dependências devem ser declaradas explicitamente e o ambiente deve ser isolado para se certificar que nenhuma biblioteca do sistema está sendo usada. No Ruby, as dependências são declaradas no Gemfile (arquivo de manifesto). O isolamento pode ser feito utilizando `bundle exec` ou ferramentas mais avançadas como [rvm][] ou [rbenv][], as quais também isolam as versões do ruby com mais facilidade.

Um exemplo de Gemfile pode ser visto a seguir:

```ruby
gem 'rake', '~> 0.9'
gem 'jekyll', '~> 0.12'
gem 'rdiscount', '~> 2.0.7'
gem 'pygments.rb', '~> 0.3.4'
gem 'RedCloth', '~> 4.2.9'
```

É de extrema importância que as versões estejam declaradas neste manifesto. Isto reforça que os diferentes ambientes estejam em funcionamento com as mesmas bibliotecas. No [post][post-bower] do meu xará, Thiago Belem, ele apresentou o Bower, que é um gerenciador de bibliotecas web.


### Config

As configurações variam entre os ambientes. Dentre elas, estão as credenciais para o banco de dados, S3, Twitter, Facebook, security tokens, etc. Mas a configuração não deve ficar no código, pois além de não ser seguro, dificulta o setup em outro ambiente.

O problema das configurações pode ser resolvido usando arquivos de configuração para cada ambiente, como yml ou xml, que devem estar no `.gitignore`. Caso contrário, as credenciais continuam compartilhadas. Porém, a solução mais recomendada é utilizar variáveis de ambiente, pois estão presentes em todos os sistemas operacionais e acessíveis de qualquer linguagem de programação. Além disso, podem ser facilmente alteradas.

#### Conclusão

Esses pontos impactam diretamente na qualidade e manutenção de um SaaS. Também é muito importante um README (atualizado) para facilitar o setup do projeto por qualquer novo desenvolvedor. Deve haver uma padronização do ambiente e o vagrant pode ajudar bastante. O [Sylvestre Mergulhão][sm] propõe [isolar os serviços usando o vagrant][post-sm]. Mas há também quem prefira o seu uso como ambiente completo de desenvolvimento.

O guia completo para o 12 Factor App pode ser acessado [aqui][12factor].

Você faz alguma coisa diferente? Pode melhorar algo? Deixe seu comentário.

#### Links

- [Site Pessoal](http://www.thiagogabriel.com)
- [Twitter](http://twitter.com/tgabrielborges)
- [Github](https://github.com/thiagogabriel)

[12factor]: http://12factor.net/
[heroku]: http://heroku.com/
[rvm]: https://rvm.io/
[rbenv]: https://github.com/sstephenson/rbenv
[post-bower]: http://helabs.com.br/blog/2013/07/08/gerenciando-assets-com-o-bower/
[sm]: http://www.twitter.com/smergulhao
[post-sm]: http://helabs.com.br/blog/2013/03/05/seu-ambiente-de-trabalho-mais-limpo-usando-vagrant/