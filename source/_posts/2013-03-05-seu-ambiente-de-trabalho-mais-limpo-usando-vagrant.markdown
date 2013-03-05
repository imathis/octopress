---
author: Sylvestre Mergulhão
layout: post
title: "Seu ambiente de trabalho mais limpo usando Vagrant"
date: 2013-03-05 10:20
comments: true
categories:
  - vagrant
  - osx
  - postgresql
  - redis
  - sphinx
  - mongodb
  - sylvestre mergulhao
---

Cada projeto tem suas peculiaridades. Alguns precisam apenas de um [banco de dados][postgresql] para rodar e outros precisam de uma série de serviços adicionais como [redis][] ou [sphinx][]. Instalar todos esses serviços diretamente no sistema operacional é uma opção, mas com o tempo a [erosão][software_erosion] atua e por muitas vezes os serviços ou o próprio sistema começam a apresentar problemas.
<!-- more -->

### Os serviços e o sistema sofrem erosão

Um exemplo bem simples de [erosão][software_erosion] ocorreu comigo há alguns dias. Fazia muito tempo que não rodava um projeto que usasse o [mongodb][] como banco de dados.

Quando precisei, percebi que o serviço não estava no ar. Avaliando os logs do sistema descobri que a cada 10 segundos o sistema tentava subir o serviço, mas por algum motivo ele dava um [segmentation fault][segmentation_fault]. O motivo do problema pode ter sido algumas das dezenas de atualizações feitas no sistema operacional e que podem ter atualizado uma biblioteca qualquer para uma versão incompatível com a versão do [mongodb][] que estava instalada.

Esse problema poderia estar acontecendo há meses, sem que eu percebesse. Não só influenciando no serviço específico, mas também degradando o sistema operacional como um todo.

### Vagrant como fornecedor de serviços

Algumas pessoas utilizam o [Vagrant][vagrant] como ambiente completo de desenvolvimento. Eu estou feliz com o ambiente que tenho no Mac OSX, me dou bem com o [brew][] e não tenho interesse em desenvolver dentro de uma máquina Linux. Nem mesmo por questões de compatibilidade. Nos dias de hoje são mínimas as diferenças e os problemas que podem ocorrer por desenvolver num ambiente e rodar em outro.

Minha proposta é utilizar o [Vagrant][vagrant] como fornecedor de serviços para o ambiente de desenvolvimento. Através da funcionalidade [forward_port][] do [Vagrant][vagrant] é possível rodar um serviço dentro da VM e mapeá-lo para uma porta da máquina host. Isso é perfeito.

Baseado nessa proposta eu criei uma box para o [Vagrant][vagrant] que roda [Ubuntu Precise 64][precise] com [postgresql][] 9.1 e mapeia a porta 5432 (usada normalmente pelo [postgresql][]) do host para dentro da VM. Isso tem o mesmo efeito de ter o [postgresql][] rodando nativamente e fica transparente para qualquer projeto.

Para mais informações veja: [https://github.com/mergulhao/vagrant-precise64-postgresql][vagrant-precise64-postgresql]

### Boxes para outros serviços

Por enquanto foi só isso que eu precisei, mas a ideia é criar um box desse para cada tipo de projeto que precise de serviços específicos.

Até o próximo!

[vagrant-precise64-postgresql]: https://github.com/mergulhao/vagrant-precise64-postgresql
[precise]: http://releases.ubuntu.com/precise/
[forward_port]: http://docs.vagrantup.com/v1/docs/config/vm/forward_port.html
[brew]: http://mxcl.github.com/homebrew/
[vagrant]: http://www.vagrantup.com/
[segmentation_fault]: http://en.wikipedia.org/wiki/Segmentation_fault
[software_erosion]: http://en.wikipedia.org/wiki/Software_erosion
[postgresql]: http://www.postgresql.org/
[redis]: http://redis.io/
[sphinx]: http://sphinxsearch.com/
[mongodb]: http://www.mongodb.org/