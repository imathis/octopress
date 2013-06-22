---
layout: post
title: "Implementando Login via Facebook na sua App Rails"
date: 2013-06-18 21:52
comments: true
categories:
  - facebook login
  - oauth
  - omniauth
---

Eu falei anteriormente sobre o [Passwordless Login](http://helabs.com.br/blog/2013/04/11/passwordless-login/) e agora vou falar sobre o Login via Facebook. Este post será mais como uma 'receita' de como implementar na sua aplicação Rails. Então, vamos lá.

<!--more-->

Todo mundo que você conhece tem uma conta no Facebook, certo? Até minha mãe fez uma conta no Facebook. Só o Rafael Lima mesmo que não tem conta (truestory). Implementar login via Facebook na sua aplicação traz uma facilidade bem grande para o usuário fazer seu cadastro. Com uns dois cliques o usuário já cria sua conta e você tem acesso ao nome, email, data de nascimento, avatar e outras informações que você pode acessar pedindo permissão, como amigos, fotos, likes e por aí vai...

### O que você precisa para implementar o login:
- Uma conta no Facebook
- Criar uma App no Facebook
- Ter uma App usando Rails
- As gems 'omniauth' e 'omniauth-facebook'
- Alguns métodos e controllers

### Criando um aplicativo no Facebook

Acesse [http://developers.facebook.com/apps](http://developers.facebook.com/apps) e clique em "**Criar Novo Aplicativo**". Digite o nome do seu App e um namespace.

![image](/images/posts/facebook-login/img0.png)

Próximo passo é pegar o APP ID e o APP Secret e configurá-los como variáveis de ambiente da sua aplicação Rails. Normalmente, colocamos as variáveis no .rvmrc do projeto, mas nada impede que você crie um arquivo .yml e salve essas informações.

![image](/images/posts/facebook-login/img1.png)

```ruby
  export FACEBOOK_APP_KEY= #{APP ID}
  export FACEBOOK_APP_SECRET= #{APP_SECRET}
```

Existe a opção de deixar o aplicativo no Facebook em modo Sandbox. Caso esteja ativado, somente você ou outras pessoas que estiverem cadastradas como desenvolvedores ou testers poderão usar sua aplicação para fazer o login. Caso você prefira que qualquer pessoa possa se logar sem precisar dar permissão. Para ver as configurações de permissões, clique em "Privilégios de desenvolvedores" na sidebar.

![image](/images/posts/facebook-login/img2.png)

Depois, na seção "Selecione o modo como seu aplicativo se integra com Facebook" clique em "Site com o Login do Facebook". Em Site URL, coloque a url onde o Facebook vai enviar as informações da autênticação. Normalmente o path "/auth/facebook/callback" é usado com a gem "omniauth". Vou explicar isso melhor depois.

Se você estiver configurando a App para desenvolvimento local, o host será "http://localhost:3000" ou qualquer que seja seu host local.

![image](/images/posts/facebook-login/img4.png)

E é isso para o aplicativo do Facebook. Vamos pro Rails agora.

### A parte do Rails...

Primeiro, adicione no seu Gemfile estas gems:

```ruby
  gem 'omniauth'
  gem 'omniauth-facebook'
```

Depois, crie um arquivo chamado "omniauth.rb" em config/initializers:

```ruby
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, ENV['FACEBOOK_APP_KEY'], ENV['FACEBOOK_APP_SECRET'], :scope => "email"
  end
```

Note que a opção "scope" tem o valor "email". Isso significa que pediremos permissão para ter acesso, além das informações básicas do usuários, ao email. Existem outros tipos de "scopes" para ter acesso a lista de amigos do usuário, aos posts no mural. Você pode saber mais sobre os tipos de permissão, leia em [https://developers.facebook.com/docs/reference/login/#permissions](https://developers.facebook.com/docs/reference/login/#permissions).

Precisamos agora de um model para o usuário:

```ruby
  $ rails g model User name:string email:string access_token:string uid:string photo_url:string
  $ rake db:migrate
```

