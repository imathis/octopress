---
layout: post
title: Métodos estáticos, porque evitá-los
date: 2013-03-13 11:00:00
comments: true
author: Pedro Nascimento
categories: lunks ruby refactor
---


Aparentemente existe na cultura de alguns desenvolvedores uma certa convenção sobre quando usar métodos estáticos. Se é um método relativamente simples, que itera sobre uma coleção dos objetos da classe em si, implementar um método estático é uma forma possível de implementação.

Diga-se que uma API está sendo feita, e é preciso retornar os usuários novos em um JSON bem específico às características da aplicação. Segue um exemplo, extraído de um projeto real:
<!-- more -->

```ruby
class User < ActiveRecord::Base
  # ...
  def self.last_users_since(time)
    response_data = {new_users: []}
    where(updated_at: time..Time.now).each do |user|
      user_hash = user.as_new_user
      response[:new_users] << (user_hash) if user_hash.present?
    end
    response_data
  end
  # ...
end
```

Da forma como se encontra, temos alguns problemas:

* É um método relativamente complexo;
* Não é um método fácil de ler;
* Existe um método no objeto user que só serve pra essa API (`User#as_new_user`);
* É chato de testar, pois só temos o retorno para ser testado.

Mas até então, ainda não é um problema.

Só que software é uma coisa que muda constantemente, e o cliente resolveu alterar a API. Agora existe um campo booleano em user chamado `synced` que dita quais objetos vão ser retornados para a API e, em seguida, considerar os mesmos como sincronizados. Ou seja, uma nova chamada à API não vai mais retornar os mesmos objetos, e sim somente os não sincronizados. Existe também um novo campo no JSON que indica quando a chamada foi resolvida.

Altera-se o método para a nova necessidade:

```ruby
class User < ActiveRecord::Base
  # ...
  def self.sync_unsynchronized_users
    response_data = {new_users: [], synced_at: Time.now}
    where(synced: false).each do |user|
      user_hash = user.as_new_user
      response[:new_users] << (user_hash) if user_hash.present?
      user.sync!
    end
    response_data
  end
  # ...
end
```

Todos os problemas ainda existem e dificilmente serão resolvidos se mantermos o método estático. 

E o pior de tudo: Mesmo com a introdução acima, a implementação é um pouco confusa. Imagine daqui há 2 meses quando algum desenvolvedor (ou até mesmo o próprio que escreveu) tiver que pegar esse código pra entender. Ainda que seja perfeitamente possível que se compreenda como o mesmo funciona, um método estático não declara intenção, os testes normalmente não são tão claros quanto se gostaria, e introduzir qualquer nova funcionalidade traz uma certa insegurança.

##Extraindo um método estático para uma nova classe

Extrair um método complexo para uma classe é um dos refactors mais clássicos e, no caso dos métodos estáticos, ataca-se os principais problemas:

* Facilita a leitura;
* Declara-se intenções através de nomes de métodos;
* Melhora a testabilidade.

O método acima extraído para uma classe ficaria assim:

```ruby
class User < ActiveRecord::Base
  # ...
  def self.sync_unsynchronized_users
    UsersSyncer.new.sync!
  end
  # ...
end

class UsersSyncer
  attr_reader :recently_synchronized_users
  def initialize
    @recently_synchronized_users = []
  end

  def unsyncronized_users
    User.where(synced: false)
  end

  def sync!
    add_and_sync_users
    response_hash
  end

  private
    def response_hash
      {new_users: recently_synchronized_users, synced_at: Time.now}
    end

    def add_and_sync_users
      unsyncronized_users.each do |user|
        mark_as_sync(user)
        add_user_to_list_if_present(user)
      end
    end

    def mark_as_sync(user)
      user.sync!
    end

    def add_user_to_list_if_present(user)
      user_hash = format_user_for_api(user)
      @recently_synchronized_users << if user_hash.present?
    end

    def format_user_for_api(user)
      # método extraído de User
    end
end
```

Nota-se que o método estático ainda existe, mas somente como uma interface. Esse é um dos poucos casos em que se é aceitável a criação de métodos estáticos, já que é bem prático chamar `User.sync_unsynchronized_users`.

O método `as_new_user` foi extraído de `User` porque neste caso somente
era usado somente uma vez. Poderia ficar em `User`, mas acredito ficar
mais claro desta forma.

Ler a classe acima 2 meses depois requer muito menos esforço por parte do desenvolvedor para compreender o funcionamento da mesma, e com certeza os testes estarão mais claros, além da complexidade ter diminuído consideravelmente.
