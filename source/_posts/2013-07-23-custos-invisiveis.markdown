---
published: true
author: Sylvestre Mergulhão
layout: post
title: "Custos invisíveis"
date: 2013-07-23 11:34
comments: true
categories: 
  - TI
  - gastos
  - business
  - helabs
  - heroku
  - continuous integration
  - continuous deployment
  
---


Em qualquer tipo de projeto ou operação existem os custos diretos e os indiretos. Os diretos são aqueles fáceis de se perceber, pois implicam na saída direta de dinheiro. No caso dos projetos que trabalhamos na HE:labs, nos custos diretos estão incluídos o pagamento de uma equipe, a compra de equipamentos, a conta de luz, gasto com servidores, dentre outros.

<!--more-->

Reduzir os custos diretos é o que almejam os gerentes de projetos, _termo que não gostamos na HE:labs_, mas que é utilizado universalmente no ambiente de TI corporativo.

Contudo nem sempre reduzir os custos diretos é bom. Deve ser avaliado um contexto _macro_ para que se chegue a uma boa conclusão. Para avaliar o contexto de forma macro, é preciso entrar no problema e entender os *inners* de cada questão.

É comum em projetos de software que o custo com pessoal seja o mais alto do projeto. Levando isso em consideração, economizar dinheiro significa reduzir o tempo da equipe gasto com coisas que não geram valor e manter essa equipe sempre o mais motivada possível.

###Analisando o caso da hospedagem dos aplicativos que desenvolvemos na HE:labs

Na HE:labs, nós recomendamos enfaticamente a utilização do [Heroku](http://heroku.com/) como plataforma de hospedagem para todos os nossos clientes, incluindo grandes clientes corporativos. Todos utilizam, sem exceção.

O motivo é bem simples: apesar do custo direto ser relativamente alto se comparado com outros serviços de hospedagem, os custos indiretos são de longe os mais baixos existentes hoje e com vantagens técnicas diretas bem maiores.

Usando o Heroku como plataforma de hospedagem, a equipe está sempre livre para criar a maior quantidade de funcionalidades. E também, de se aproveitar de recursos avançados como ElasticSearch, memcached, websocket, entre muitos outros [addons](https://addons.heroku.com/), sem ter que se preocupar em como o Heroku vai fazer para disponibilizar aquele serviço.

Outras vantagens de se utilizar o Heroku incluem: elasticidade imediata, alta disponibilidade e imunidade a erosão. Todos estes tópicos são muito relevantes nos dias atuais.

Temos também uma série de ferramentas. Algumas [opensource](https://github.com/Helabs), que nos ajudam não somente a dar o kickoff de um projeto em poucos minutos, mas também a manter um projeto com extrema facilidade, incluindo os processos de [continuous deployment](http://en.wikipedia.org/wiki/Continuous_delivery) e [continuous integration](https://en.wikipedia.org/wiki/Continuous_integration).

###Nosso cenário atual

Todas as equipes estão sempre motivadas e entregando o máximo de valor, pois estão livres das amarras de qualquer burocracia tecnológica que as impeçam de realizar o seu trabalho.

Ninguém precisa fazer ssh, múltiplas vpns ou outras coisas exóticas para fazer um simples deploy de uma aplicação. Qualquer desses fatores ou semelhantes teriam implicações diretas, como gasto de tempo extra para realizar uma tarefa trivial. E também, indiretas como a motivação daquela pessoa em trabalhar naquele projeto "chato" e que atrapalha o seu trabalho por conta de empecilhos desnecessários.

Extrapolando a questão e seguindo pela teoria das [janelas quebradas](http://en.wikipedia.org/wiki/Broken_windows_theory), para a HE:labs, ter um projeto tecnologicamente burocrático é um risco. Pois abre um enorme precedente para outros projetos e poderia contaminar negativamente toda a equipe, influenciando no [coolness](http://www.urbandictionary.com/define.php?term=coolness) da empresa e em tudo que nos fez chegar onde chegamos.

