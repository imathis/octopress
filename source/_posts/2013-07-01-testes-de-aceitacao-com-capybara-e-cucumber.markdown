---
layout: post
published: true
title: "Testes de aceitação com capybara e cucumber"
date: 2013-07-01 18:00
author: Rodrigo Reginato
comments: true
categories: 
  - rodrigo reginato
  - cucumber
  - capybara
  - testes de aceitação
  - cucumber-rails
---

A idéia desse post é mostrar um pouco como funciona o capybara com o cucumber.

<!--more-->

Vou criar um projeto com apenas um formulårio para usar de exemplo para os testes de aceitação, usarei o ruby 2.0.0-p0 e o rails 3.2.13.

Cucumber é uma gem que cria um novo ambiente no projeto e permite a escrita de testes de aceitação em uma linguagem muito próximo da natural. 

Capybara também é uma gem que ajuda a testar aplicações web  simulando como um usuário real iria interagir com o aplicativo.

Primeira etapa é adicionar a gem cucumber em seu gemfile, adicione também a gem database_cleanear, ela não é obrigatória, mas altamente recomendável, depois de 'bundle install'.

```ruby
group :test do   
  gem 'cucumber-rails', :require => false   
  gem 'database_cleaner' 
end
```

Após a instalação das gems rode o comando, para gerar os aquivos de configuração do cucumber.

```ruby
$ rails generate cucumber:install
```

Agora execute o comando:

```ruby
$ rake cucumber
```
Você deve obter o resultado:

```ruby
0 scenarios
0 steps
0m0.000s
```

Crie um arquivo “/features/valida_form.feature” onde será escrito os Cenários. Descreva a ação de como o sistema deve se comportar.

```ruby
# encoding: utf-8
# language: pt
Funcionalidade: Preencher o formulário

  Cenário: Deve preencher todos os campos do formulário e salvar com sucesso
    Dado que eu estou na página do formulário
    Quando eu preencher todos os campos
    E clicar em salvar
    Então então deve receber a mensagem Cadastrado com Sucesso
```

Após salvar esse arquivo execute novamente o comando:

```ruby
$ rake cucumber
```

O resultado obtido será:

```ruby
1 scenario (1 undefined)
4 steps (4 undefined)
0m0.812s
```

Próximo passo para agilizar o processo vou criar um scaffold de Usuário e validar presença de todos os campos.

```ruby
$ rails g scaffold usuario nome:string endereco:string telefone:string estado:string tipo:string
$ rake db:migrate
```

Vários cenários podem ser criados, um exemplo é não preencher todos os campos do formulário de novo usuário e clicar em salvar, nesse caso é so criar um passo onde deve garantir que não foi redirecionado para o “show” do usuário e sim manter na mesma página “new”.
O capybara vai nos ajudar a preencher os fields do formulário, como mostra o código a seguir. 

Agora crie um arquivo “/features/step_definitions/valida_form_steps.rb” com o conteúdo abaixo:

```ruby
# encoding: utf-8
Dado /^que eu estou na página do formulario$/ do
  visit new_user_path
end

Quando /^eu preencher todos os campos$/ do
  fill_in "user_nome", :with=> "Rodrigo Reginato"
  fill_in "user_endereco", :with=> "Rua alagoas 3872"
  fill_in "user_telefone", :with=> '4398765425'
  page.select "SC", :from => 'user_estado'
  page.choose("user_tipo_fisico")
end  

E /^clicar em "(.*?)"$/ do |nome_do_botao|
  find_button(nome_do_botao).click
  save_and_open_page
end  

Então /^então deve ver receber a mensagem "(.*?)"$/ do |mensagem|
  page.has_content?(mensagem)
end   
```

Após adicionar esse código rode novamente o comando:

```ruby
$ rake cucumber
```

O resultado obtido sera:

```ruby
1 scenario (1 passed)
4 steps (4 passed)
0m0.425s
```

##Dicas

Para facilitar a nossa vida existe algumas funções que são fundamentais como:

```ruby
save_and_open_page
```

Para utilizarmos esse recurso é necessário instalar a gem:

```ruby
gem 'launchy'
```

Um browser é aberto no momento que esse comando é adicionado entre os steps, facilitando para encontrar possíveis erros.

No caso da página ter algum javascript ou se quiser ver todo o processo passo a passo como se o usuário estivesse digitando os dados é necessário instalar a gem [selenium-webdriver](https://github.com/vertis/selenium-webdriver), existem outras opções como o [capybara-webkit](https://github.com/thoughtbot/capybara-webkit) mas apresentou um erro na hora do bundle, ja [selenium-webdriver](https://github.com/vertis/selenium-webdriver) funcionou perfeitamente.

```ruby
gem 'selenium-webdriver'
```

Adicione @javascript na primeira linha antes do Cenário iniciar.

```ruby
@javascript
Cenário: Deve preencher todos os campos do formulário e salvar com sucesso
```

Um browser será aberto logo no início do processo  e todos os passos que descrevi acima ficará visível como se um usuário estivesse preenchendo os campos.

É isso pessoal até a próxima.