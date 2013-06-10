---
author: Cayo Medeiros (yogodoshi)
layout: post
title: "Estouro de memória ao fazer loops com MongoDB"
date: 2013-01-17 11:00
comments: true
categories:
  - cayo medeiros
  - mongoid
  - mongodb
  - mongomapper
---
Esse post não será útil para 99% dos desenvolvedores mas tenho certeza de que será um salvador de vidas pro 1% que está passando pelo mesmo perrengue que passei.

Deixe-me adivinhar: você está usando MongoDB com [Mongoid][1] ou [MongoMapper][2]? Tem uma collection razoavelmente grande, com 100-150k de documentos? A memória do seu servidor vai nas nuvens quando faz um loop ou roda uma migration nessa collection? Ou o [Heroku][3] começa a baleiar porque a memoria do dyno já passou dos 512 megas faz tempo?!
<!-- more -->

Você já leu várias perguntas e respostas no [StackOverflow][4], procurou na documentação do MongoDB e do seu ODM preferido e também não encontrou a resposta?

Eu já estive nos seus sapatos e depois de MUITO sofrer com esse problema no [Estou Jogando][5], encontrei o maldito motivo: o Identity Map!

O Identity Map é muito útil pois reduz a quantidade de consultas que fazemos ao banco e também é necessário quando queremos fazer eager loading nos relacionamentos entre as coleções.

Porém, quando fazemos um loop em uma collection gigantesca com o Identity Map habilitado, ele vai tacando todos os milhares de documentos pra memoria e isso, obviamente, não há servidor que aguente.

Então a solução pra esse problema é bem simples: você não precisa desabilitar o Identity Map globalmente na sua aplicação nem nada, basta desabilita-lo antes de fazer um grande loop na sua aplicação. No Mongoid ficaria assim:

```ruby
	Mongoid.unit_of_work(disable: :all) do
		Jogo.only(:jogos_relacionados, :nome, :genero, :plataforma).asc(:plataforma, :nome)	.each do |jogo|
    		jogo.popula_jogos_relacionados
		end
	end
```

A primeira linha serve justamente para desabilitar o Identity Map em tudo que ocorrer dentro do bloco interno. Outra dica ao fazer loops em grandes coleções é puxar da collection apenas os campos que serão usados no loop, com o Mongoid isso é feito através do 'only' e do 'without'.

É isso pessoal, espero que essa descoberta seja tão útil pra vocês como foi pra mim! E se esse post lhe ajudou, deixe um comentário avisando para os próximos leitores =)

[1]: http://mongoid.org title: "ODM para MongoDB escrito em Ruby"
[2]: http://mongomapper.com title: "Outro ODM para MongoDB escrito em Ruby"
[3]: http://heroku.com/ "Nosso host preferido na HE"
[4]: http://stackoverflow.com/ "O salvador dos devs"
[5]: http://www.estoujogando.com.br/ "Rede social para os gamers brasileiros"
