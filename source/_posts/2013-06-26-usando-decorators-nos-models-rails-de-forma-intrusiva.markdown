---
layout: post
published: false
title: "Usando decorators nos models Rails de forma intrusiva"
date: 2013-06-26 20:08
author: Rodrigo Pinto
comments: true
categories:
  - rodrigo pinto
  - decorator
  - rails
  - patterns
  - active decorator
  
---

Muito já se falou sobre decorators nos últimos tempos, até mesmo por [aqui][dec]. Melhorar a legibilidade e remover lógica das views de uma aplicação é um assunto que [me interessa][tech] já faz algum tempo. Nesse post vou falar sobre a alternativa que no meu ponto de vista preencheu a lacuna do problema decorators de views no rails .

<!--more-->

Existem diversas formas de implementar um decorator e já existem diversas gems que auxiliam nesse trabalho, como o [simple_presenter][sp] e o [draper][draper]. O que me incomodava em todas nas diversas soluções existentes, é que o desenvolvedor teria de passar o objeto ou a coleção de objetos para a classe do decorator, para que o objeto fosse _decorado_. Pensando no caso de uma action, ela teria de ser alterada, como pode ser visto no exemplo a seguir:

```ruby
# any controller...
def index
  @users = UserPresenter.map(User.all) # simple presenter
  @articles = ArticleDecorator.decorate_collection(Article.all) # draper
end
```

Esse tipo de solução sempre me incomodou, e eu mantive minha busca por alguma solução que funcionasse de forma intrusiva, sem que fosse preciso modificar a chamada na action. E essa solução existe, chama-se [active_decorator][ad].

O active_decorator _injeta_ o decorator em um model, ou em uma coleção de models ou uma instância do ActiveRecord::Relation automaticamente a partir de um controller ou renderizando uma view com `:collection` ou `:object` ou `:local`, sendo assim, não é preciso alterar nenhuma chamada no seu controller.

Vamos ver o exemplo anterior usando o active decorator.

```ruby
# any controller...
def index
  @users = User.all
  @articles = Article.all
end
```

Existindo um `UserDecorator` e um `ArticleDecorator`, os objectos das coleções serão automaticamente _decorados_ quando forem ser usados nas views.

Veja um exemplo mais completo:

```ruby
# any controller...
def index
  @user = current_user
  @articles = current_user.articles
end

# user decorator
module UserDecorator

  def full_name
    "#{first_name}-#{last_name}"
  end

end

# article decorator
module ArticleDecorator

  def link_to_publish
    if published?
      "On air!"
    else
      link_to "Publish", publish_article_path(self)
    end
  end
end

```

```erb
# app/views/articles/index.erb

Olá <%= @user.full_name %>

<ul>
<% @articles.each do |article| %>
  <li>
    <%= article.title %>
    <%= article.link_to_publish %>
  </li>
<% end %>
</ul>

```

O active decorator é totalmente "plugável" a uma aplicação existente o que reduz bastante o esforço de implementação de decorators, facilitando a implementação gradual.


Abraços, [Rodrigo Pinto](http://twitter.com/rodrigoospinto).


[tech]: http://helabs.com.br/blog/2012/11/16/tech-talk-rodrigo-pinto-explorando-as-views-rails/
[cafe]: http://helabs.com.br/eventos/cafe-com-dev/
[dec]: http://helabs.com.br/blog/categories/decorator/
[sp]: https://github.com/fnando/simple_presenter
[draper]: https://github.com/drapergem/draper
[ad]: https://github.com/amatsuda/active_decorator