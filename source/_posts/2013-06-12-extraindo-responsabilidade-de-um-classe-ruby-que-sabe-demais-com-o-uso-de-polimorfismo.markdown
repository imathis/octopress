---
published: true
author: Mauro George
layout: post
title: "Extraindo responsabilidade de um classe ruby utilizando polimorfismo"
date: 2013-06-06
comments: true
categories:
  - mauro george
  - decorator
  - model
  - rails
  
---

Já falei anteriormente um pouco sobre o uso do pattern decorator no rails [neste link](http://helabs.com.br/blog/2013/01/28/extraindo-a-responsabilidade-de-fat-models-com-o-uso-de-decorators/). Em algum momento a lógica pode ser tão complexa que quebraríamos os decorators em _decorators especializados_.

<!--more-->

Vamos a um exemplo: dado um `PostDecorator` com apenas um método público `show`, responsável por exibir um post, podemos reduzir a sua complexidade e manter a responsabilidade única de cada classe, baseando-se no tipo de status. Mas como? 

```ruby
class PostDecorator

  def initialize(post)
    @post = post
  end

  def show
    if post.status == "draft"
      # ... lógica de draft aqui
    elsif post.status == 'published'
      # ... lógica de published aqui
    end
  end

  private

    attr_reader :post
end
```

O primeiro passo que poderíamos fazer seria extrair a lógica de cada um dos status para classes especializadas, delegando as responsabilidades. Exemplo:

```ruby
class PostDecorator

  def initialize(post)
    @post = post
  end

  def show
    if post.status == "draft"
      PostDraftDecorator.new(post).show
    elsif post.status == 'published'
      PostPublishedDecorator.new(post).show
    end
  end

  private

    attr_reader :post
end

class PostDraftDecorator
# ... lógica de draft aqui
end

class PostPublishedDecorator
# ... lógica de published aqui
end
```

Agora ficou melhor, já que a responsabilidade foi dividida.

Um outro pequeno refactory que poderíamos fazer é melhorar essa verificação de `if post.status == "draft"`. Podendo implementar em nosso model `Post#draft?` e `Post#published?`.

E assim, encapsulamos a lógica de `#draft?` e `#published?`, pois se a complexidade aumentar, teremos que mudar N contextos que fazem a verificação de tal lógica. Como agora elas estão encapsuladas, caso a lógica mude, teremos que alterar apenas no model.

```ruby
class PostDecorator

  def initialize(post)
    @post = post
  end

  def show
    if post.draft?
      PostDraftDecorator.new(post).show
    elsif post.published?
      PostPublishedDecorator.new(post).show
    end
  end

  private

    attr_reader :post
end
```

Para evitarmos criar todos estes métodos na mão, podemos utilizar a _gem_ [Jacaranda](https://github.com/maurogeorge/jacaranda) que foi a minha primeira gem ;)

Mas ainda não é o melhor que podemos fazer para este caso. Vamos agora ao uso de polimorfismo:

## Resolvendo com o uso de polimorfismo

Podemos usar _polimorfismo_ para, dependendo do status do post, instanciar e utilizar o decorator correto.

```ruby
class PostDecorator

  def initialize(post)
    @post = post
  end

  def show
    post_decorator.new(post).show
  end

  private

    attr_reader :post

    def post_decorator
      "Post#{post.status.capitalize}Decorator".constantize
    end
end
```

Como pode-se notar, criamos o método `post_decorator` que retorna a classe correta. Em seguida, instanciamos ela e chamamos o método `show` na classe específica.
Caso não seja de seu conhecimento, utilizamos o [`constantize`](http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html#method-i-constantize) do ActiveSupport que nos retorna uma constante de mesmo nome baseado na string recebida.

Agora vamos aos testes do nosso `PostDecorator`:

```ruby
describe PostDecorator do

  let(:post_decorator) do
    PostDecorator.new(post)
  end

  describe "#show" do

    context "when post is a draft" do

      let!(:post) do
        Post.create(status: "draft")
      end

      it "call PostDraftDecorator" do
        post_draft_decorator = double("PostDraftDecorator")
        PostDraftDecorator.should_receive(:new).with(post).and_return(post_draft_decorator)
        post_draft_decorator.should_receive(:show)
        post_decorator.show
      end
    end

    context "when post is published" do

      let!(:post) do
        Post.create(status: "published")
      end

      it "call PostPublishedDecorator" do
        post_published_decorator = double("PostPublishedDecorator")
        PostPublishedDecorator.should_receive(:new).with(post).and_return(post_published_decorator)
        post_published_decorator.should_receive(:show)
        post_decorator.show
      end
    end
  end
end
```

Como visualiza-se acima, nossos testes ficaram bem simples. Testamos apenas se a delegação foi feita corretamente, pois a implementação seria testada unitariamente em cada uma das classes especializadas (`PostDraftDecorator` e `PostPublishedDecorator`).

## Conclusão

Utilizando _polimorfismo_, agora nossa classe `PostDecorator` pode instanciar outros decorators e não precisaremos mais dos _ifs_ e _elses_. Apenas crie uma nova classe como `PostUnpublishedDecorator` e todos os posts com o status **unpublished** usarão esta nova classe, pois segue-se a convenção.

