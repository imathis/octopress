---
author: Matheus Bras
layout: post
title: "Passwordless Login"
date: 2013-04-11 11:15
comments: true
categories:
  - matheus bras
  - ruby
  - passwordless
  - login
  - rails

---

![image](/images/posts/passwordless.png)

Neste post, vou mostrar como fazer uma aplicação permitir que o usuário faça login sem precisar digitar/lembrar de sua senha. Não será nada complexo demais e nem uma solução perfeita. No final, postarei o link para uma aplicação exemplo que preparei exemplificando o método.

# Por que fazer login sem senha?

Fazer login está se tornando uma tarefa complicada. Agora que temos muitos usuários acessando aplicações pelo smartphone, digitar a senha na telinha do telefone é complicado. Mesmo nas telas gigantes dos celulares da Samsung, é chato e ruim. Precisamos de uma maneira mais simples de fazê-lo.

<!-- more -->

Os usuários têm que lembrar seu username e senha para logarem. Mas muitas vezes não os lembram. E é aí que entra o “esqueci minha senha” e o usuário precisa abrir seu email e clicar no link para poder recuperar sua senha. Ou então para que a senha não seja esquecida eles usam: password, senha123 ou 123456.

Uma solução proposta por Ben Brown neste [post](http://notes.xoxco.com/post/27999787765/is-it-time-for-password-less-login) é gerar uma senha totalmente aleatória quando o usuário se cadastrar no site e enviar por email um link para fazer o login. A maioria dos sites permitem que o login seja mantido pra sempre, porém se o usuário precisar fazer o login novamente, a aplicação gera outra senha para o usuário e envia outro link para ele por email.

# Como eu resolvi esse problema

Então vamos ao código:

Primeiro, criei um model User com os campos _email_ e _access_token_.

```ruby
rails g model User email:string access_token:string
```

Depois, criei um método _generate_access_token _que se encarrega de gerar uma nova senha para o usuário. E também o método _access_token_exists? _(token) para checar se, por acaso, a senha já existe para algum usuário.

```ruby
def self.access_token_exists?(token)
  where(access_token: token).any?
end

private
  def generate_access_token
    loop do
      token = SecureRandom.hex(30)
      return self.access_token = token unless User.access_token_exists?(token)
    end
  end
```

E então implementei o método _generate_access_token_and_save _para gerar a senha para o usuário e salvá-la. Isso fecha por enquanto o model User. Voltaremos nele mais tarde.

```ruby
def generate_access_token_and_save
  generate_access_token and save
end
```

Agora vamos ao _UsersController _. Criei um controller simples com duas actions: New e Create.

```ruby
# encoding: UTF-8
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.generate_access_token_and_save
      redirect_to new_user_path, notice: "Agora olha teu email lá! :)"
    else
      render :new
    end
  end
end
```

Em seguida, criei o SessionsController para lidar com o login. O controller vai encontrar o usuário que possua a access_token fornecida e colocar seu id em uma session.

```ruby
# encoding: UTF-8
class SessionsController < ApplicationController
  def create
    user = User.find_by_access_token!(params[:token])
    session[:user_id] = user.id
    redirect_to(secret_page_path, notice: "Você está logado! :)")
  rescue ActiveRecord::RecordNotFound
    redirect_to(root_url, notice: "Acesso inválido... recupere sua senha.")
  end
end
```

Agora que já tenho o controller para lidar com o link de login, posso criar o Mailer para enviar o link para o email do usuário.

```ruby
# encoding: UTF-8
class Notification < ActionMailer::Base
  default from: "estagiario@passwordlessapp.com"
  layout "mailer"

  def auth_link(user)
    @user = user

    mail to: @user.email, subject: "[Passwordless App] Aqui está seu link de acesso"
  end
end
```

Coloquei, então, a chamada para o envio do email dentro do método _generate_access_token_and_save _no model User.

```ruby
def generate_access_token_and_save
  Notification.auth_link(self).deliver if generate_access_token and save
end
```

Usei o SecretPageController para ter uma action que requer autenticação.

```ruby
class SecretController < ApplicationController
  before_filter :authenticate!

  def index
  end
end
```

Aqui estão os helpers de autenticação criados para o SecretPageController.

```ruby
# encoding: UTF-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  ensure_security_headers
  helper_method :current_user, :user_signed_in?

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
      session.delete(:user_id)
      nil
  end

  def user_signed_in?
    !current_user.nil?
  end

  def authenticate!
    user_signed_in? || redirect_to(root_url, notice: "Você precisa estar autenticado...")
  end
end
```

E isso já faz o login sem senha funcionar. O usuário se cadastra, recebe um link por email, clica no link, se loga e é redirecionado para a action que requer autenticação.

Eu fiz uma aplicação exemplo que pode ser acessada [clicando aqui](http://passwordless.herokuapp.com) e o código também está no [GitHub](https://github.com/matheusbras/passwordless-app) com todos os testes. Sintam-se à vontade para mandar pull requests, issues e perguntas.

Obrigado pela sua atenção e abraços!