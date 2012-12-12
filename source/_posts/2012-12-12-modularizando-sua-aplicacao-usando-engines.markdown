---
author: Pedro Nascimento
layout: post
title: "Modularizando sua aplicação usando Engines"
date: 2012-12-12 12:12
comments: true
categories: engines lunks
---

Este é o primeiro post da série [Engines][engine_tag] aqui no blog da
[HE:labs][helabs].

Durante a última semana criamos três engines para agilizar nossos processos
no [StartupDev][startupdev]:
[omniauth-facebook-rails][omniauth_facebook_rails], [sigame][sigame] e
[favorite_it][favorite_it]. Todas elas partiram de códigos utilizados
várias vezes em outros projetos. Como qualquer outro projeto open
source, qualquer colaboração é bem vinda e incentivada.
<!-- more -->

##O que são Engines?
[Engines][engines_guide] são aplicações Rails que podem ser incluídas dentro da sua
aplicação. Um exemplo clássico é o Devise. Ele adiciona entre outras
coisas, controllers, views e vários helpers, além de disponibilizar
alguns generators.

##Quando criar Engines?
Engines servem para diminuir a duplicação de código em suas aplicações
e/ou permitir um bootstrap mais eficiente de novas aplicações. Casos
comuns:

* Aplicações dentro da empresa que usam um layout e estrutura
  semelhantes.
* Coisas que são feitas em grande parte das aplicações novas e que se
  perde algum tempo copiando código de uma aplicação pra outra.

Sem engines, se existe algum bug nessa funcionalidade duplicada, ou uma
alteração no layout compartilhado, todas as aplicações tem que ser
conferidas e consertadas. Isso demanda tempo desnecessário e caso você
esqueça alguma aplicação, pode ser difícil verificar em que situação ela
se encontra depois de um certo tempo.

##Como criar engines?
Essa é a parte mais fácil! Apesar de existir algumas formas diferentes
de fazê-lo, eu prefiro criar sempre uma "full engine", usando o comando:

```
rails plugin new nome_da_engine --full
```

Isso permite a você criar uma classe disponível em todas
as suas aplicações. Por exemplo:

```ruby
#Na sua engine, em app/models/tweet_new_user.rb
class TweetNewUser
  def initialize(user)
   @user = user
  end

  def tweet!
   Twitter.update("Novo usuário criado! #{@user.username}")
  end
end
```

```ruby
#Na sua app, em app/model/user.rb
after_create :tweet_about_me
def tweet_about_me
  TweetNewUser.new(self).tweet!
end
```

It just works&trade;. Tudo que você criar dentro da Engine fica
disponível na sua aplicação.

No próximo post da série discutiremos sobre alguns problemas que
você encontra ao desenvolver usando Engines, e como resolvê-los.

Tem alguma tip sobre Engines? Fala aí nos comentários!

[engine_tag]: http://helabs.com.br/blog/categories/engines/
[helabs]: http://helabs.com.br
[startupdev]: http://startupdev.com.br/
[omniauth_facebook_rails]: https://github.com/Helabs/omniauth-facebook-rails
[sigame]: https://github.com/Helabs/sigame
[favorite_it]: https://github.com/Helabs/favorite_it
[engines_guide]: http://guides.rubyonrails.org/engines.html
