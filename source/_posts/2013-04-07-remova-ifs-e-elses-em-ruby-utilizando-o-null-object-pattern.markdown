---
author: Mauro George
layout: post
title: "Remova Ifs e Elses em Ruby utilizando o Null Object Pattern"
date: 2013-04-07 11:16
comments: true
categories:
  - mauro george
  - ruby
  - OOP
  - Pattern

---

O [Null Object pattern](https://en.wikipedia.org/wiki/Null_object) tem como principal objetivo tratar o comportamento do valor `Null`, ou em ruby o `nil`.
Sabemos que em algum momento de nosso código podemos ter referências nulas, sendo assim, temos que verificar se tal refêrencia é nula ou não para não recebermos uma _exception_ como a seguinte:

    NoMethodError: undefined method `name' for nil:NilClass

<!-- more -->

Vamos a um exemplo: Temos uma classe Game responsável pelas informações de um dado jogo e um classe Report, responsável por imprimir os dados deste tal jogo.

Vamos a classe Game:

```ruby
require 'ostruct'

class Game < OpenStruct
end
```

Uma simples classe que herda de OpenStruct.

Agora vamos a nossa classe Report:

```ruby
class Report

  def initialize(game)
    @game = game
  end

  def show
    %Q{Game: #{name}
    Platform: #{platform}
    Description: #{description}}
  end

  private

    def name
      @game.name
    end

    def platform
      @game.platform
    end

    def description
      @game.description
    end
end
```

Como podem ver, a nossa classe funciona muito bem para o Game. No entanto, se em algum momento recebermos uma referência nula (por exemplo de um find do ActiveRecord),  receberemos a seguinte exception:

```ruby
game = nil
report = Report.new(game)
puts report.show # undefined method `name' for nil:NilClass (NoMethodError) ...
```

Vamos resolvê-la utilizando os mais comuns: `if` e `else`.

```ruby
class Report

  def initialize(game)
    @game = game
  end

  def show
    %Q{Game: #{name}
    Platform: #{platform}
    Description: #{description}}
  end

  private

    def name
      if @game
        @game.name
      else
       'no name'
      end
    end

    def platform
      if @game
        @game.platform
      else
        'no platform'
      end
    end

    def description
      if @game
        @game.description
      else
        'no description'
      end
    end
end
```

Como podem ver, alteramos os métodos da classe `Report`, responsável por criar os campos de `Game` na exibição do relatório, para tratar quando recebemos um valor nil.
Até funciona, mas como notamos, estamos adicionando mais complexidade a simples métodos que apenas delegam o valor, além de, claramente, estarmos repetindo código. E é neste ponto que o Null Object Pattern vem para nos ajudar. Vamos aos refactories.

```ruby
class NullGame

  def name
    'no name'
  end

  def platform
    'no platform'
  end

  def description
    'no description'
  end
end

class Report

  def initialize(game)
    @game = game || NullGame.new
  end

  def show
    %Q{Game: #{name}
    Platform: #{platform}
    Description: #{description}}
  end

  private

    def name
      @game.name
    end

    def platform
      @game.platform
    end

    def description
      @game.description
    end
end
```

Primeiro criamos uma classe `NullGame` responsável por definir os valores quando um `Game` for nulo. Em Seguida, alteramos a classe `Report` para instanciar um `NullGame` (caso o game seja nulo) e assim, podemos alterar nossos métodos que funcionam como delegators para continuarem fazendo apenas isto.
Veja como seria o comportamento de `Report` ao receber um `nil`:

```ruby
game = nil
report = Report.new(game)
puts report.show # Game: no name
                 # Platform: no platform
                 # Description: no description
```

Como podem ver, ao utilizarmos o Null Object Pattern, conseguimos manter o nosso código muito mais Ruby Way utilizando classes coesas, com responsabilidades bem definidas e one line methods.

Para finalizar fica a dica da excelente palestra do [Ben Orenstein](https://twitter.com/@r00k) [Refactoring from Good to Great](http://www.confreaks.com/videos/1233-aloharuby2012-refactoring-from-good-to-great) , de onde este post foi inspirado.
