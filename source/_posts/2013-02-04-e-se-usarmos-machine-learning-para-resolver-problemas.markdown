---
author: Rafael Fiuza
layout: post
title: "E se usarmos Machine Learning para resolver problemas"
date: 2013-02-04 14:00
comments: true
categories:
  - rafael fiuza
  - machine learning
  - id3
  - classificadores
  - rails
---


Para mim, uma das coisas mais interessantes no meio de desenvolvimento de softwares é a que não existe apenas uma forma de se fazer. Existem diversas formas corretas (e incorretas) de se resolver algum problema. Elas vão do incrivelmente simples à forma mais rebuscada ou a mais marretada.
Geralmente, quando posso, escolho a forma mais divertida.
<!-- more -->

![image](/images/posts/2013-02-04/dr-evil.jpg)

> **Number Two:** *Why not use your knowledge of the future to play the stock markets? We could make trillions.*

> **Dr. Evil:** *Why make a trillion when we could make... billions?'*


Certa vez conheci um cliente com um problema interessante.
Ele tinha uma tabela com uma série de prefixos de telefone contendo o código do pais mais código de área mais os primeiros números do telefone, o suficiente para diferenciar um de outro. O código de área era opcional bem como a quantidade de números de telefone.
Para cada prefixo, uma taxa especifica.

------------------------------------------------------------------------

Ex:

- **prefix** ---- **rate**
- 551198 ----  0.025
- 55119 ----   0.015
- 55118 ----   0.025
- 55113 ----   0.01
- 55112 ----   0.012
- 52199 ----   0.03
- 55218 ----   0.025
- 55213 ----   0.011
- 55212 ----   0.013
- 240 ----     0.50

------------------------------------------------------------------------


O principal problema consistia no fato de não saber que parte da string que continha o número era de fato o prefixo e o que era o número, pois recebíamos o número como uma string inteira, por exemplo: “5511980000000”.

E como qualquer outro problema, existem diversas maneiras de se resolver.

Sempre fui fascinado por [Machine Learning](http://en.wikipedia.org/wiki/Machine_learning). Na realidade, desde a época que eu não sabia direito o que significava mas já sabia que ele foi muito mal implementado no Exterminador do Futuro 1[¹](#1). Vi aí uma oportunidade de me divertir, mesmo que a solução não viesse a ser usada.

![image](/images/posts/2013-02-04/sarahconnor.png)

Caso não saiba o que é Machine Learning e para que serve, vamos para o Wikipédia:

>“Machine learning, a branch of artificial intelligence, is about the construction and study of systems that can learn from data.”
> --- <cite>Wikipédia</cite>

Era exatamente o que eu estava procurando. Não queria pensar em um algoritmo que fizesse isso por mim. Vou deixar o próprio computador aprender com os dados e decidir o valor correto.

Um dos ramos do Machine Learning é a classificação. Acredito que é a parte mais simples de se explicar e ver como funciona.

Existem, atualmente, diversos algoritmos que conseguem cobrir virtualmente qualquer situação. Para esse exemplo usarei o [ID3](http://en.wikipedia.org/wiki/ID3_algorithm) e como o Ruby ainda não tem uma grande variedade de bibliotecas de Machine Learning, usarei a que acredito ser a mais famosa: [AI4r](http://ai4r.org/).

```
gem install ai4r
```

O próximo passo seria obter o dataset. Fiz um collect da tabela com os campos necessários para nossa pesquisa (no nosso caso, apenas prefix e rate). O Ai4r leva em conta todos os valores que adicionamos no array, sendo que o último elemento da array seria o valor que estamos buscando.
Caso você esteja lendo esse blog do futuro, provavelmente já estará usando o rails 4 ou superior, onde o active record pode fazer o pluck com múltiplos valores. E eu os invejo.

```ruby
def dataset
   data = NumberPattern.collect{|d| [d.prefix, d.rate]}
   label = ['prefix', 'rate']
   Ai4r::Data::DataSet.new(data_items: data, data_labels: label)
end
```

Agora com nosso dataset preparado, basta adicionar água, digo, a biblioteca de classificação ID3. É um algoritmo nem tão complicado mas que foge ao escopo desse texto.

```
@a = Ai4r::Classifiers::ID3.new.build dataset
```

Agora começa a magica. O classificador lê o dataset que adicionamos e cria uma árvore de decisão. No nosso caso seria uma árvore de decisão simples visto que, para deixar o exemplo simples, temos apenas uma variante que é o prefixo. Caso recebêssemos os valores do prefixo separadamente, a árvore seria bem mais complexa. Você pode visualizar essa árvore ao perguntar pelas regras

```
@a.get_rules
```

Com a árvore de decisão criada, ficou simples obter o rate para nosso prefixo.
```
prefix = ‘55118’
eval @a.get_rules
#‘0.025’
```
Mas agora você diz: Peraê, você está dizendo que se apenas alimentar a variável prefixo com o número completo ele traz o resultado correto?
Ok, eu admito. Não é tão mágico assim. Para meu exemplo ficar completo, somente o que foi feito não resolveria, ja que, como eu disse, o valor que obteríamos seria uma string com o número inteiro. Caso eu coloque o valor inteiro da string na variável prefix não encontraria nenhum resultado pois o ID3 não faz predições. Faz apenas classificações.

```
@prefix = number
…

  def get_rate
    prefix = @prefix
    result = (eval @a.get_rules)
  rescue
    if !@prefix.empty?
      @prefix.chop!
      get_rate
    else
      raise ‘Sem rate para esse número’
    end
  end
```

Ok. Ta certo. Você pode dizer que nesse exemplo eu usei o mesmo princípio de eliminar os números que não se encaixavam com nosso dataset, como o usado no Exterminador do Futuro 1, mas se a Skynet usou no T-800, quem sou eu para dizer algo contra?






<a id="1"></a> **1 - Não importa o que digam, a solução de matar todas as mulheres que se chamavam Sarah Connor para atingir a mãe do John Connor não parece muito inteligente.**

<a id="2"></a> **2 - Indicaria fazer esse exemplo com mais colunas, ou com outros casos para ver como se comporta a árvore de decisão em cada caso.**
