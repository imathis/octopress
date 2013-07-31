---
layout: post
title: "Como colaborar com projetos open-source"
date: 2013-07-31 15:20
comments: true
author: Pedro Nascimento
categories: 
- opensource
- lunks

---

Atualmente, quase todas as empresas de desenvolvimento de software usam algum projeto open-source no seu dia a dia. Nós da HE:labs acreditamos que faz parte do nosso trabalho contribuir de volta. Isto é, colaborar com projetos open-source e melhorar o conteúdo disponível para a comunidade. Mas muitas vezes, desenvolvedores e designers ficam perdidos em como contribuir. Vou tentar listar algumas formas produtivas de fazê-lo, seja em projetos grandes, como o [Rails](https://github.com/rails/rails), ou mesmo em projetos menores, que, porventura, você tenha utilizado e/ou tenha interesse em contribuir.

<!--more-->

###Tradução

Traduzir projetos como o [Better Specs](http://betterspecs.org/) é uma excelente forma de começar se você ainda se sente inseguro em contribuir com código. Traduzir permite que você, obrigatoriamente, leia e entenda como funciona. E ainda, facilita que desenvolvedores iniciantes, considerando que não dominam o Inglês, leiam determinado guia ou tutorial e possam aprender determinada tecnologia ou técnica sem ter a linguagem como barreira. A quantidade de materiais em Português é ainda bastante precária e apesar de eu mesmo não dar muita bola para os mesmos, já vi muitos desenvolvedores mais inexperientes procurando incessantemente como resolver determinado problema buscando por uma solução em português.

###Ressucitar issues antigas

[Projetos](https://github.com/rails/rails/issues) [maiores](https://github.com/joyent/node/issues) [muitas](https://github.com/gregbell/active_admin/issues) [vezes](https://github.com/robbyrussell/oh-my-zsh/issues) [tem](https://github.com/FortAwesome/Font-Awesome/issues) [centenas](https://github.com/angular/angular.js/issues) [de](https://github.com/zurb/foundation/issues) [issues](https://github.com/mxcl/homebrew/issues) [abertas](https://github.com/EllisLab/CodeIgniter/issues), e simplesmente tentar reproduzir o problema para ver se já foi resolvido ou não, e depois reportar é totalmente válido. 

Outra forma útil e eficiente de ressucitar issues é tentar isolar o problema com um exemplo em um [repositório com testes](https://github.com/plentz/jruby_report). Isto ajuda outras pessoas a entenderem mais facilmente o problema. Às vezes, o simples fato de isolá-lo já melhora a visibilidade do mesmo e permite desenvolvedores mais experientes e com menos tempo a resolvê-los.

Um simples "isso pode ser fechado?" também ajuda.

###Faça backports e publique-os

Às vezes você se encontra em um projeto com dependências mais antigas, onde precisa resolver certos problemas que já foram anteriormente resolvidos para versões mais recentes. E ainda, necessita fazer o backport das soluções. Após consertar para seu projeto interno, contribua de volta. Existem inúmeros exemplos:

* [lunks/kiqstand](https://github.com/lunks/kiqstand)
* [grosser/rails2_asset_pipeline](https://github.com/grosser/rails2_asset_pipeline)
* [grosser/strong_parameters](https://github.com/grosser/strong_parameters/tree/rails2)
* [marcandre/backports](https://github.com/marcandre/backports)

###Melhore a biblioteca para você, extraia para um plugin e faça um pull request

Uma das coisas mais recorrentes no Rails são desenvolvedores experientes aparecerem no [Ruby on Rails Core](https://groups.google.com/forum/#!forum/rubyonrails-core) fazendo sugestões de melhorias, com a intenção de fazê-lo, mas somente se a comunidade aceitar. 90% das vezes a resposta é *você pode fazer um pull request?*.

A argumentação é simples: Se você quer uma feature, vá lá e faça! Não espere algum commiter ou core member falar que seria legal. Muitas vezes somente vislumbrar uma feature não é nem de perto vislumbrar o esforço para que ela se concretize e que *side effects* ela pode trazer. Não é à toa que [observers](https://github.com/rails/rails-observers) e [Active Resource](https://github.com/rails/activeresource) não fazem mais parte do Rails. Mesmo features boas requerem manutenção uma vez incorporadas à algum projeto open-source e isso é custoso.

Com o código pronto, é muito mais fácil convencer alguém a aceitar a sua sugestão. É claro, não garante. Não fique chateado se rejeitarem. Lançar em um plugin (uma *gem* no vocabulário Ruby) permite que outras pessoas que concordam com você usufruam do seu trabalho e possam fazer parte do lobby para incorporar a sua sugestão à biblioteca que você tanto quer contribuir.

Contribuir com projetos open-source é extremamente gratificante. De quebra, ainda é um excelente portfólio se você pretende se candidatar a alguma vaga [em uma empresa legal](http://helabs.com.br/jobs). E fica bonito no seu [Open Source Report Card](http://osrc.dfm.io/lunks).

E você, tem alguma outra forma interessante de contribuir para projetos open-source?

*Se quiser ajuda, inclusive para parear em um projeto opensource, [me siga no Twitter](https://twitter.com/lunks) e entre em contato.*
