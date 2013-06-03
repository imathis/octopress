---
published: false
author: Mauro George
layout: post
title: "Extraindo responsábilidade de um classe ruby que sabe demais com o uso de polimorfismo"
date: 2013-06-12
comments: true
categories:
  - mauro george
  - decorator
  - model
  - rails
---

Já falei anteriormente um pouco sobre o uso do [pattern decorator no rails aqui](http://helabs.com.br/blog/2013/01/28/extraindo-a-responsabilidade-de-fat-models-com-o-uso-de-decorators/). E em algum momento a lógica pode ser tão complexa que quebramos os decorators em decorators especializados.

Vamos a um exemplo: dado um `PostDecorator` que tem apenas um método público `show` responsável por exibir um post como podemos reduzir a sua complexidade e manter a responsábilidade única de cada classe, dado que ela é baseado no tipo de status.

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

o primeiro passo que poderiamos fazer seria extrair a lógica de cada um dos status para classes especializadas, delegando as responsábilidades. Exemplo:

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

já ficou melhor, agora a responsábilidade foi dividida.

Um outro pequeno refactory que poderiamos fazer é melhorar esta verificação de `if post.status == "draft"` podemos implementar em nosso model `Post#draft?` e `Post#published?`.

E assim encapsulamos a lógica de `#draft?` e `#published?` pois se a complexidade aumentar teriamos que mudar em N contextos que fazem a verificação de tal lógica, agora que elas estão encapsuladas caso a lógica mude teremos que alterar apenas no model.

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

Para evitarmos criar todos estes métodos na mão podemos utilizar a gem [Jacaranda](https://github.com/maurogeorge/jacaranda) que foi a minha primeira gem ;)

Mas ainda não é o melhor que podemos fazer, para este caso. Vamos agora ao uso de polimorfismo!

## Resolvendo com o uso de polimorfismo

Podemos usar de polimorfismo para dependendo do status do post, instanciar e utilizar o decorator correto.

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

Como pode ver criamos o método `post_decorator` que retorna a classe correta, em seguida instanciamos ela e chamamos o método `show` na classe especifica.
Caso não conheça utilizamos o [`constantize`](http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html#method-i-constantize) do ActiveSupport que nos retorna uma constante de mesmo nome baseado string recebida.

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

Como pode ver os nossos testes ficaram bem simples, testando apenas se a delegação foi feita corretamente, pois a implementação teria sido testada unitariamente em cada uma das classes especializadas(`PostDraftDecorator` e `PostPublishedDecorator`).

## Conclusão

Como pode ver utilizando de polimorfismo, agora nossa classe `PostDecorator` pode instanciar outros decorators e não precisamos mais de ifs e elses, apenas criar uma nova classe como `PostUnpublishedDecorator` e todos os posts com o status unpublished usarão esta nova classe, pois estamos seguindo a convenção.

