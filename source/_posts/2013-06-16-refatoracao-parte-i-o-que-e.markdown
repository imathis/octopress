---
author: Eduardo Fiorezi
layout: post
title: "Refatoração Parte I - O que é?!"
date: 2013-06-16 18:17
comments: true
categories:
  - desenvolvimento agil
  - refactoring
  - refatoracao
  - eduardo fiorezi
---

Vejo várias pessoas falando sobre refatoracão, mas esse assunto é mais complexo do que os desenvolvedores imaginam. Para se ter a real profundidade do assunto é necessário uma leitura minuciosa do [livro Refactoring](http://www.amazon.com/Refactoring-Ruby-Edition-Jay-Fields/dp/0321603508) de Jay Fields, Shane Harvie, Martin Fowler e Kent Beck.

Uma das grandes verdades da refatoração é que um código limpo é mais fácil de receber mudanças que um código complexo.


<!--more-->

[Kent Beck](http://en.wikipedia.org/wiki/Kent_Beck) e [Ward Cunningham](http://en.wikipedia.org/wiki/Ward_Cunningham) trabalhavam com Smalltalk desde os anos 80. O ambiente  cultural do desenvolvimento de Smalltalk favorecia o ciclo de compilar-linkar-executar rapidamente. Esses caras ajudaram a difundir essa prática que era muito comum no ambiente Smalltalk. Hoje temos ferramentas de ótima qualidade em todas a linguagens de desenvolvimento atuais.

> Refatorar é alterar a estrutura do código sem alterar o seu comportamento.

Conforme a metáfora do Kent Beck, chamada de dois chapéus (The Two Hats), durante o desenvolvimento você deve dividir o tempo em duas tarefas distintas: adicionar novas funcionalidades e refatorar. Enquanto estiver adicionando uma nova funcionalidade, você não pode alterar outro código existente, apenas adiciona novos testes e funcionalidades. Quando você refatora, não adiciona novas funcionalidades, apenas reestrutura seu código. Essa troca de chapéus deve ser feita frequentemente.

Dentro da prática de desenvolvimento orientado a testes temos o uso contínuo de refatoracão, pois, os testes ajudam o desenvolvedor a ter um feedback rápido sobre suas mudanças e ter a certeza que nada quebrou no comportamento que foi pensado.

##Por que refatorar?

###Porque melhora do design do código do projeto.
Conforme um projeto vai crescendo, o design do código acaba caindo em qualidade, isso gera um débito de código no sistema, o sistema crescerá e ficará mais dificil adicionar funcionalidades e evoluir.

###Porque torna seu software fácil de entender.
O código de um sistema deve dizer exatamente o que ele faz. Aplicar pequenas refatorações ajudam a entender o que seu software faz e ajudam a deixar o código mais limpo. Todo desenvolvedor deve se preocupar em escrever o melhor código possível, não apenas para os outros integrantes do time, mas para si próprio, pois entenderá o código novamente quando precisar fazer alguma modificação.

###Porque ajuda a encontrar bugs.
Quando você altera a estrutura de um código, você garante e revisa certos comportamentos que você deseja, neste momento você pode identificar alguma situação que não foi prevista por você ou pelos integrantes do time.

###Porque ajuda você a programar mais rápido
Um bom design de código ajuda na evolução do sistema, já que tudo torna-se mais simples de entender. Pode parecer “perda de tempo” efetuar essa melhoria constante de código, mas na prática um código organizado irá facilitar muito sua vida de programador.

...

Eu gosto muito da frase do Kent Beck em que ele diz: “Eu não sou um grande programador; Sou apenas um bom programador com excelentes hábitos”. Acredito que bons programadores tem que cultivar esses hábitos e a refatoração merece um espaço considerável no nosso dia a dia de desenvolvedores de software.

No próximo artigo vou falar sobre os mal cheiros de códigos.

Siga-me no Twitter [@eduardofiorezi](http://twitter.com/eduardofiorezi)

