---
author: Anézio Marques
layout: post
title: "Cuidados com Observers e callbacks"
date: 2013-01-14 16:30
comments: true
categories: 
  - anezio marques
  - rails 4
  - observer
  - callbacks

---

Já foi divulgado que na versão __4 do Rails__ removerão o __Observer__ e ele deverá ser utilizado como uma gem. Analizei em alguns projetos a utilização dessa classe e as vezes encontro situações onde acredito que ela pode estar prejudicando mais do que colaborando com o projeto.
<!-- more -->

A grosso modo a utilização de Observer nada mais é do que uma extração de código dos callbacks. Ou seja, é necessário também muito cuidado ao ser utilizado para não exagerar na lógica que é colocada nela, já que isso pode gerar comportamentos não desejados da classe, além de aumentar a complexidade nos testes onde a gente acaba tendo que mockar/implementar funcionalidades extras do que realmente está querendo ser testado. 

Um exemplo dessa situação é o __Welcome email__ que é enviado quando um usuário é cadastrado. 

```ruby
	class UserObserver < ActiveRecord::Observer
		def after_create(user)
			NotificationsMailer.welcome_user(user.id).deliver
		end
	end
```

### DRY utilizando Observer ###

A utilização de observer sem que ele seja utilizado em multiplas classes é desnecessária, você não está fazendo nada mais do que pegando o callback de uma classe e extraindo para outra classe. Não vejo o que se ganha com isso. Além de estar complicando o desenvolvedor, já que ele tem que abrir 2 arquivos para entender o que está sendo realizado. 

Essa extração é produtiva no caso onde diversas classes acabam executando o mesmo callback como nesse exemplo:

```ruby
	class AuditObserver < ActiveModel::Observer
		observe :account, :balance

		def after_update(record)
			AuditTrail.new(record, "UPDATED")
		end
	end
```


Aqui o Observer está criando um registro de auditoria tanto no Account quanto no Balance. Já justifica a sua utilização.


### Caos do callback ###

Este tipo de callback cria um comportamento padrão para toda criação de usuário que nem sempre pode ser desejada. Por exemplo, posso querer importar usuários e não querer que seja disparado o welcome email, e sim outro email customizado. 

Além disso isso também cria mais complexidade nos testes, suponha que quero enviar um email na mudança de status do User, nos testes vou precisar criar o usuário e alterar seu status para disparar o email que quero testar, no entanto ao criar o usuario estarei enviando o Welcome email, algo que realmente não é necessario e terei de fazer um tratamento nos testes para evita-lo.

Este caso é de um simples email extra enviado, mas agora imagine um after_create executando 4 ou 5 tarefas o quanto isso vai implicar na implementação de diversos testes e também o quanto vai surgir de tratamentos que deverão ser realizados para executar ou não cada tarefa, isso pode se tornar um grande BAD SMELL.


### Exemplo de solução ###

Uma solução que tem se mostrado muito claro, simples e quebra a complexidade dos models é extrair comportamentos de um determinado cenario para uma nova classe. Por exemplo:

```ruby
  class UserSignup
    def initialize(params)
      @user = User.new(params)
    end
    
    def signup
      if @user.save
        NotificationsMailer.welcome_user(user.id).deliver
      end
      @user
    end
  end
  
  class UserController < ApplicationController
    def create
      @user = UserSignup.new(params).signup
      
      if @user.errors.present?
        render :new
      else
        redirect_to dashboard_path, notice: "User create successfully"
      end  
    end
  end    
```
Dessa forma estou extraindo a situação específica da criação de usuários pelo formulário padrão do projeto para uma classe que terá seu comportamento bem específico deixando assim o código mais simples para se testar, tirando complexidade da classe User e de quebra ainda deixará de executar em diversos testes do projeto os callbacks da criação do User o que irá impactar positivamente na velocidade da execução dos testes.