---
author: Mauro George
layout: post
title: "Extraindo a responsabilidade de Fat Models com o uso de Decorators no Rails"
date: 2013-01-28 10:30
comments: true
categories: 
  - mauro george
  - decorator
  - model
  - rails
---


Desde o [15 minutes blog](http://www.youtube.com/watch?v=Gzj723LkRJY) o rails tem evoluido bastante e novos conceitos foram introduzidos com o passar do tempo, um mantra que foi introduzido na comunidade foi o "Skinny Controller, Fat Model" que pode gerar uma confusão aos desenvolvedores novatos e alguns mais experientes também.
<!-- more -->

### Fat model não necessariamente herda de ActiveRecord::Base

Quando lemos o mantra pela primeira vez podemos ficar tentados a fazer algo que seria mover nossas lógicas do controller para o model.

Primeiro temos o código de enfileirar o envio de email no controller.

```ruby
class PostsController < ApplicationController

  def create
    @post = Post.new(params[:post])

    if @post.save
      NotifyMailer.delay.notify(@post)
      redirect_to(@post, :notice => 'Post was successfully created.') }
    else
      render :action => "new"
    end
  end
end
```

Refatorariamos para algo assim em nosso model Post.

```ruby
class Post < ActiveRecord::Base
  after_save :notify_users
  
  private
    
    def notify_users
      NotifyMailer.delay.notify(self)
    end
end
```

Com certeza melhor que a solução anterior, mas agora o nosso model está sabendo demais. Além de fazer o seu papel em tratar as informações do banco de dados, agora também enfileira emails toda vez que é salvo. Ou seja, temos um problema de alto acoplamento, a operação de salvar sempre ativa o enfileiramento de envio de emails e com isso violamos o [SRP](http://en.wikipedia.org/wiki/Single_responsibility_principle).

É aí que chegamos no ponto que fat models não necessariamente são classes que herdam de `ActiveRecord::Base`, pois como vimos isso nos gera os seguintes problemas:

- alto acoplamento
- testes mais lentos
- falta de coesão

### Definindo melhor as responsabilidades e assim deixando tudo mais claro

Para deixar as coisas mais claras e com as responsabilidade melhores definidas podemos criar um [decorator](http://en.wikipedia.org/wiki/Decorator_pattern).

```ruby
class PostNotifyUsers
  
  def initialize(post)
    @post = post
  end
  
  def save
    @post.save && notify_users
  end
  
  private
    
    def notify_users
      NotifyMailer.delay.notify(@post)
    end
end
```

No código acima criamos uma classe em Ruby pura, conhecida também como PORO (Plain Old Ruby Objects). E o papel desta classe é notificar os usuários de um post novo enfileirando o email. Com isso conseguimos:

- **Baixo acoplamento**: `Post` lida com o banco de dados e `PostNotifyUsers` notifica os usuários. Cada um com sua responsabilidade.
- **Testes mais rápidos**: Quando se cria um `Post` em seus testes ele não envia mais email
- **Alta coesão**: Pois agora sabemos de tudo o que ocorre ao salvar um `Post`, ele apenas é salvo.

Veja agora como ficaria o nosso controller usando o decorator que acabamos de criar:

```ruby
class PostsController < ApplicationController

  def create
    @post = Post.new(params[:post])

    if PostNotifyUsers.new(@post).save
      redirect_to(@post, :notice => 'Post was successfully created.') }
    else
      render :action => "new"
    end
  end
end
```

Como pode ver ficou mais claro pois agora sei que nesta action eu salvo o post e notifico os usuários. Outra coisa legal é que o a nossa classe `PostNotifyUsers` [quacks](http://en.wikipedia.org/wiki/Duck_typing) como `User` sendo assim podemos continuar usando o `#save` só que agora do `PostNotifyUsers` em nosso controller.

O [Anézio](http://twitter.com/aneziojunior) falou recentemente sobre a extração de responsábilidades também no post [Cuidados com Observers e callbacks](http://helabs.com.br/blog/2013/01/14/cuidados-com-observers-e-callbacks/).

### O Rails way e os iniciantes no rails

O que é comum são as pessoas iniciarem no rails sem noção nenhuma de Ruby e às vezes até [orientação a objetos](https://en.wikipedia.org/wiki/Object-oriented_programming). O que levam a seguir sempre a abordagem do conhecido Rails Way esquecendo(às vezes nem sabendo) que Ruby é uma linguagem orientada a objetos, e que assim pode resolver muito dos seus problemas.