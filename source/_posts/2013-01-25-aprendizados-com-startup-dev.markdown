---
author: Matheus Bras
layout: post
title: "Aprendizados com o Startup DEV"
date: 2013-01-25 10:00
comments: true
categories:
  - startup dev
  - desenvolvimento agil
---

O [Startup DEV](http://startupdev.com.br) é um modelo de desenvolvimento bastante fora do padrão do mercado. Afinal, são dois dias e no final sai um produto funcional. Esses dois dias proporcionam experiências e aprendizados importantes. Vou listar alguns pontos neste post.

<!-- more -->

### *Desenhar é muito importante!*
Após conversamos com o cliente e captar a ideia do projeto, partimos para fazer os desenhos na folha de papel. Desenhamos todas as telas e os fluxos do sistema da forma que imaginamos que ele deva ser. Disposição dos elementos, textos, mensagens. Isso ajuda em dois pontos: procurar soluções simples e transmitir a ideia para os outros membros da equipe e para o cliente.

O Startup DEV é um processo de desenvolvimento ágil. É bem curto, mas é! Dois dias é o período de uma mini-iteração que no final consegue entregar um produto funcional. Miramos a [simplicidade](http://desenvolvimentoagil.com.br/xp/valores/simplicidade) nas soluções do problema não só porque é um dos valores do [XP](http://desenvolvimentoagil.com.br/xp), por exemplo, mas também porque não seria viável, nem inteligente, desenvolver algo complexo em tão pouco tempo.

### *Redução*
[Todo sistema começa pequeno](http://helabs.com.br/blog/2013/01/23/todo-sisteminha-comeca-pequenininho/). Normalmente o cliente chega com uma ideia gigante pra um sistema, que possívelmente demoraria 1 ano pra ficar pronta. Temos que reduzir isso para conseguirmos desenvolver algo em dois dias.

Como fazemos? Ao conversar com o cliente sobre a ideia dele, nós detectamos o core do produto e assim fazemos a priorização junto com o cliente sobre o que é mais importante para o sistema.

É o primeiro passo para o projeto. E para muitos projetos, o melhor primeiro passo pode ser o Startup DEV, pois em dois dias entrega uma pequena parte funcional do sistema onde, se for o caso, é possível validar a ideia no mercado. Muitos clientes são frustrados por prazos extensos e imprecisos.

[Uma dica para sucesso em software.](http://sucessoemsoftware.com.br/)

### *Rails Template e Heroku <3*
Aqui na HE:labs utilizamos o Heroku como Cloud SaaS para praticamente todos os nossos projetos. Perder pouco tempo no setup dos projetos ajuda bastante. Não precisamos ficar configurando praticamente nada. E com a ajuda do nosso [rails-template](https://github.com/Helabs/rails-template), que adiciona mais algumas configurações e gems default dos nossos projetos, conseguimos em menos de 30 minutos colocar a aplicação online.

O Rodrigo Pinto tem uma talk bacana sobre Platform as a Service que você pode ver [aqui](https://speakerdeck.com/rodrigoospinto/paas-plataform-as-a-service)

### *Código testado e reusável*
Nós nunca escrevemos códigos sem testes. Nunca! Nossos clientes sempre perguntam: "Mas e se der algum problema, algum bug depois que vocês finalizarem?". 100% de cobertura de testes ajudam a eliminar essa preocupação. Nunca fazemos deploys com a cobertura menor que 100%.

Isso também auxilia em outro ponto. Normalmente, acabamos usando alguns snippets de código de outro projeto, como: autenticação, integrações com APIs. Pelo fato do código estar coberto por testes, nós conseguimos extrair essas pequenas partes e reusá-las e outros projetos, ou até mesmo fazer [gems](http://helabs.com.br/opensource/).
