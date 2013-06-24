---
author: Matheus Bras
layout: post
title: "Implementando Login via Facebook na sua App Rails"
date: 2013-06-24 10:00
comments: true
categories:
  - facebook login
  - oauth
  - omniauth
  - matheus bras
  
---

Eu falei anteriormente sobre o [Passwordless Login](http://helabs.com.br/blog/2013/04/11/passwordless-login/) e agora vou falar sobre o Login via Facebook. Este post será mais como uma 'receita' de como implementar na sua aplicação Rails. Então, vamos lá.

<!--more-->

Todo mundo que você conhece tem uma conta no Facebook, certo? Até minha mãe fez uma conta no Facebook! Só o Rafael Lima mesmo que não tem (truestory). Implementar login via Facebook na sua aplicação traz uma facilidade bem grande para o usuário fazer seu cadastro. Com uns dois cliques ele já cria a conta e você tem acesso ao nome, email, data de nascimento, avatar e outras informações que pode-se acessar pedindo permissão, como amigos, fotos, likes e por aí vai...

### O que você precisa para implementar o login:
- Uma conta no Facebook
- Criar uma App no Facebook
- Ter uma App usando Rails
- As gems _omniauth_ e _omniauth-facebook_
- Alguns métodos e controllers

## Criando um aplicativo no Facebook

Acesse [http://developers.facebook.com/apps](http://developers.facebook.com/apps) e clique em "**Criar Novo Aplicativo**". Digite o nome do seu App e um namespace.

![image](/images/posts/facebook-login/img0.png)

Próximo passo é pegar o _APP ID_ e o _APP Secret_ e configurá-los como variáveis de ambiente da sua aplicação Rails. Normalmente, colocamos as variáveis no _.rvmrc_ do projeto, mas nada impede que você crie um arquivo _.yml_ e salve estas informações.

![image](/images/posts/facebook-login/img1.png)

```ruby
  export FACEBOOK_APP_KEY= #{APP ID}
  export FACEBOOK_APP_SECRET= #{APP_SECRET}
```

Existe a opção de deixar o aplicativo no Facebook em modo 'Sandbox'. Caso esteja ativado, somente você e/ou outras pessoas que estiverem cadastradas como desenvolvedores ou testers poderão usar sua aplicação para fazer o login. Caso você prefira que qualquer pessoa possa se logar sem precisar dar permissão, desative o modo Sandbox. Para ver as configurações de permissões, clique em "**Privilégios de desenvolvedores**" na sidebar.

![image](/images/posts/facebook-login/img2.png)

Depois, na seção "**Selecione o modo como seu aplicativo se integra com Facebook**" clique em "**Site com o Login do Facebook**". Em _Site URL_, coloque a url onde o Facebook vai enviar as informações da autenticação. Normalmente o path _"/auth/facebook/callback"_ é usado com a gem _"omniauth"_. Vou explicar isto melhor depois.

Se você estiver configurando a App para desenvolvimento local, o host será "**http://localhost:3000**" ou qualquer que seja seu host local.

![image](/images/posts/facebook-login/img4.png)

E é isto para o aplicativo do Facebook. Agora, vamos para o Rails:
 
## A parte do Rails...

Primeiro, adicione no seu Gemfile estas gems:

```ruby
  gem 'omniauth'
  gem 'omniauth-facebook'
```

Depois, crie um arquivo chamado _"omniauth.rb"_ em config/initializers:

```ruby
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, ENV['FACEBOOK_APP_KEY'], ENV['FACEBOOK_APP_SECRET'], :scope => "email"
  end
```

Note que a opção "scope" tem o valor "email". Isto significa que pediremos permissão para ter acesso, além das informações básicas do usuários, ao email. Existem outros tipos de "scopes" para ter acesso a lista de amigos do usuário e aos posts no mural. Você pode saber mais sobre os tipos de permissão em: [https://developers.facebook.com/docs/reference/login/#permissions](https://developers.facebook.com/docs/reference/login/#permissions).

Precisamos agora de um model para o usuário:

```ruby
  $ rails g model User name:string email:string access_token:string uid:string photo_url:string provider:string
  $ rake db:migrate
```

Precisamos também de um controller para cuidar da autenticação. Vamos criar o _SessionsController_:

```ruby
  $ rails g controller Sessions
```

Neste controller vamos implementar algumas actions:

```ruby
  # encoding: UTF-8
  class SessionsController < ApplicationController
    def create
      auth = request.env["omniauth.auth"]
      user = User.find_or_create_with_omniauth(auth)
      session[:user_id] = user.id
      redirect_to secret_page_path, :notice => "Opa! Você está online!"
    end

    def failure
      redirect_to root_url
    end

    def destroy
      session[:user_id] = nil
      redirect_to root_url, :notice => "Volte em breve!"
    end
  end
```

A action _create_ vai receber as informações do usuário enviado pelo Facebook através do _request.env["omniauth.auth"]_. Caso ele não exista no banco de dados, nós criaremos o usuário ou então, somente o encontraremos através do método que ainda será implementado no model _User_, find_or_create_with_omniauth(). Para saber mais sobre o Auth Hash, [clique aqui](https://github.com/mkdynamic/omniauth-facebook#auth-hash). A action _failure_ vai redirecionar o usuário para o root_url, caso a autenticação falhe. E a action _destroy_, vai simplesmente deslogar o usuário.

Agora vamos criar as rotas para este controller:

```ruby
  match "/auth/:provider/callback" => "sessions#create", as: :auth_callback
  match "/auth/failure" => "sessions#failure", as: :auth_failure
  match "/logout" => "sessions#destroy", as: :logout
```

Lembra que ao criarmos o aplicativo no Facebook definimos a url para login como **http://localhost:3000/auth/facebook/callback**? Esta rota aponta para a action create do nosso _SessionsController_. Você pode mudar a rota para a action create, mas lembre-se de mudar nas configurações do aplicativo do Facebook também.

Vamos voltar ao model _User_ para implementar o método *find_or_create_with_omniauth*:

```ruby
  def self.find_or_create_with_omniauth(auth)
    user = self.find_or_create_by_provider_and_uid(auth.provider, auth.uid)
    user.assign_attributes({ name: auth.info.name, email: auth.info.email, photo_url: auth.info.image, access_token: auth.credentials.token })
    user.save!
    user
  end
```

Na primeira linha do método tente achar o usuário pelos campos provider e uid. Se não for encontrado, nós criaremos um. Logo na linha debaixo nós setamos alguns atributos pelo Auth Hash, como: *nome, email, avatar e o access_token*. Então, salvamos o usuário e o retornamos na última linha.

Para finalizar, só precisamos criar algum link onde o usuário clique e faça o login. Adicione na view da sua preferência:

```ruby
  <%= link_to "Login com Facebook", "/auth/facebook" %>
```

E pronto. O usuário já pode fazer o login usando o Facebook na sua aplicação Rails. Como no outro post, eu também preparei uma aplicação exemplo no [Heroku](https://facebook-login-example.herokuapp.com/) e disponibilizei o código no [Github](https://github.com/matheusbras/facebook-login-example). É uma versão modificada da aplicação do outro exemplo. ;)

Heroku -> https://facebook-login-example.herokuapp.com/
Github -> https://github.com/matheusbras/facebook-login-example

