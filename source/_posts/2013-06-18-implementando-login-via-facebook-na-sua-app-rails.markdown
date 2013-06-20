---
layout: post
title: "Implementando Login via Facebook na sua App Rails"
date: 2013-06-18 21:52
comments: true
categories:
  - facebook login
  - oauth
  - omniauth
  - matheus bras
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

### Criando uma App no Facebook

Acesse [http://developers.facebook.com/apps](http://developers.facebook.com/apps) e clique em "**Criar Novo Aplicativo**". Digite o nome do seu App e um namespace.

![image](/images/facebook-login/img0.png)