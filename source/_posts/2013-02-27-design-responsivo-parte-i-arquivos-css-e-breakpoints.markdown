---
published: true
author: Mikael Carrara
layout: post
title: "Design Responsivo Parte I: Arquivos CSS e Breakpoints"
date: 2013-02-27 10:15
comments: true
categories:
  - design
  - css
  - design responsivo
  - mikael carrara
  - media queries
---

Irei a partir de hoje lançar uma série de posts com minhas considerações a respeito de design responsivo.

Ao projetar uma interface Web responsiva (otimizada para *Tablets*, Celulares, TVs, Geladeiras e Carros), primeiramente defino os *breakpoints*, ou seja, defino os pontos de “quebra” do layout (resoluções de agentes de usuários) e através de *Media Queries (*CSS*3)* seto o comportamento desejado para cada uma das resoluções que gostaria de considerar no meu projeto.

<!-- more -->

Em “90%” dos casos, a solução a seguir atendeu muito bem minhas necessidades. Em primeiro lugar divido meus arquivos *CSS* da seguinte forma:

**site-core.css**
Aqui eu coloco todo *CSS* genérico, estilos comuns em todas as versões da interface. este arquivo vai alimentar os outros dois abaixo;

**site-web.css**
Responsável por estilos exclusivos para web;

**site-mobile.css**
Finalmente um arquivo responsável por estilos específicos para dispositivos móveis.

Separo uma versão só para Web por questões de compatibilidade com *Internet Explorer 8*. Sendo assim, no **HEAD** da aplicação eu seto através de um [comentário condicional](http://en.wikipedia.org/wiki/Conditional_comment) para que o *IE8* leia apenas a versão Web:

```html
<!--[if IE]>
  <link type="text/css" rel="stylesheet" href="site-web.css" media="screen" />
<![endif]-->
```

Outros *browsers* com maior suporte a especificação das *CSS3* aplicam as *Media Queries* como explicado no início do post. Então juntando tudo ficaria assim:

```html
<link type="text/css" rel="stylesheet" href="site-core.css" />
<link type="text/css" rel="stylesheet" href="site-web.css" media="screen and (min-width:801px)" />
<link type="text/css" rel="stylesheet" href="site-mobile.css" media="handheld, screen and (max-width:801px)" />
```

Então, explicando melhor: Estou dizendo que o *CSS* para Web só deve ser exibido quando a largura **mínima** do navegador for no mínimo **801px** e a versão mobile apenas em resoluções com largura **máxima** de **801px**. O arquivo **site-core.css** como já explicado, alimenta os outros dois com estilos genéricos.

A seguir, configure sua *viewport* da forma como preferir (entrarei em mais detalhes num próximo post):

```html
<meta name="viewport" content="width=device-width, user-scalable=no" />
```

Agora vamos definir os breakpoints para todas as versões mobile. Apenas para frisar: O arquivo *CSS* mobile engloba tanto *Tablets* quando Celulares e *Smartphones*. Deixei apenas a versão Web num arquivo separado para poder usá-la também como uma “versão IE8” sem necessariamente criar uma versão de *CSS* com Hacks só para ele. Não tive trabalho a mais com o *IE8*.

Voltando...

Todo estilo que coloco dentro do arquivo *CSS* **site-mobile.css** mas “fora” de Media Queries é destinado a agentes de usuários com largura **máxima** de **801px** como já explicado. Na verdade então, podemos já ir definindo os estilos pra *Tablets* diretamente no arquivo.

```css
.holder {
  width:700px;
}
```

Então finalmente os estilos para agentes de usuários com largura **máxima** de **686px**. Nos meus testes funcionou muito bem tanto em *Smartphones* modernos como *Galaxy Nexus* e *iPhone 5* que possuem resoluções bem grandes no modo *landscape* como também no *iPhone 4* e *HTC Nexus One* que já são mais antigos.

```css
@media (max-width:686px) {

  .holder {
    width:86%;
    padding:0 7% 0 7%;
  }

}
```

Esses valores são os que usei em algumas situações mas você é livre para explorar melhor as *Media Queries*, garanto que vai muito além de larguras definidas com unidades de medidas absolutas como estou fazendo nos exemplos. Experimente **criar grids** responsivas usando unidades de medidas relativas como **%** e **EM**.

Voltando pras *Medias Queries*...

Daí por diante é só ir diminuindo a resolução conformo você vai dando mais suporte a vários dispositivos:

```css
@media (max-width:381px) {

  background-image:none;

  .holder {
    width:94%;
    padding:0 3% 0 3%;
  }

}
```

Na maioria das vezes, conforme a resolução do dispositivo diminui, a capacidade de processamento também, então começam a aparecer estilos que otimizam o desempenho em dispositivos mais modestos.

Mudando um pouco de assunto mas dentro de um mesmo contexto, acho que quando você está aprendendo *CSS* básico ainda, mais importante do que o conceito de **“Design Responsivo”** em si é o conceito de “[Box-Model](http://www.w3.org/TR/CSS2/box.html)”. Procure entender melhor como se comporta a renderização em cada browser.

Se você não domina completamente todos os elementos da sua interface no navegador Web, será um pouco mais difícil “aprender design responsivo”. Talvez você até o faça, mas seu trabalho não terá a qualidade esperada no final.

**Conclusão:** Você precisa pensar para que cada dispositivo tenha a melhor experiência possível dentro de suas limitações. Através das *Media Queries* podemos definir estilos específicos para cada contexto e assim otimizar a experiência do usuário em diferentes situações.

## Outros posts da série

[Design Responsivo Parte II: Listagens e Galerias](http://helabs.com.br/blog/2013/05/24/design-responsivo-parte-ii-listagens-e-galerias/)

## Links

- [Site Pessoal](http://www.mikaelcarrara.com)
- [Linkedin](br.linkedin.com/in/mikaelcarrara/)
- [Portfólio no Dribbble](http://dribbble.com/mikaelcarrara)