---
author: Sylvestre Mergulhão
layout: post
title: "4 Hour Workweek, Lean Startup, Teste A/B, Optimizely e o Futuro"
date: 2012-11-09 12:12
comments: true
categories: 
- lean startup
- sylvestre mergulhao
---

Quando li o livro [The 4 Hour Workweek] , percebi que muitas das otimizações exemplificadas pelo [Timothy] eram baseadas em experimentação sobre o que funciona melhor, ou seja, tem maior taxa de conversão. Na época não existia uma ferramenta como o [Optimizely]. Ele deve ter tido um bom trabalho para chegar nas conclusões sobre que converte melhor.
<!-- more -->

Algum tempo depois li o [The Lean Startup] do [Eric Ries]. Depois de muitas repetições sobre [validated learning], caiu a ficha de que para isso existir, não basta um serviço como o [Optimizely].

É claro que o [Optimizely] é sensacional para testar coisas como cor, imagem ou descrição que faz melhores conversões... Ou seja: faz o usuário se cadastrar ou clicar num determinado botão. Para isso ele é imbatível.

Contudo, para o processo do Lean Startup, mais que isso é necessário. Para se obter aprendizado validado dentro de um aplicativo web, é necessário que ele se comporte realmente de forma diferente. Não é apenas um posicionamento, cor ou imagem. É uma coisa interna!

Dado que validamos com o [Optimizely] qual é a melhor posição, cor e descrição para um botão, agora precisamos validar qual é a melhor implementação! Precisamos que um mesmo clique de botão execute uma determinada função de forma diferente, que exiba o resultado de forma diferente. Uma mesma action, no caso do Rails, deve ser implementada de mais de uma forma. Quantas forem as versões que estão sendo validadas. E, após um número de experimentos executados, determinamos qual a melhor, removendo as demais.

Isso tudo já estava na minha cabeça há bastante tempo, mas o arcabouço técnico necessário para ter isso realizado e funcionando de forma simples é enorme. Não tenho dúvidas de que o Eric construiu esse arcabouço para o [IMVU], case que ele conta no livro.

A parte boa é que agora apareceu uma ferramenta chamada [FluidFeatures] que tem o propósito de exatamente fornecer suporte a esses tipos de testes. É o futuro!

[The 4 Hour Workweek]: http://www.fourhourworkweek.com/
[Timothy]: http://en.wikipedia.org/wiki/Timothy_Ferriss
[Optimizely]: https://www.optimizely.com/
[The Lean Startup]: http://lean.st/
[Eric Ries]: http://en.wikipedia.org/wiki/Eric_Ries
[validated learning]: http://lean.st/principles/validated-learning
[IMVU]: http://www.imvu.com/
[FluidFeatures]: http://www.fluidfeatures.com/