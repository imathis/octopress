---
author: Mikael Carrara
layout: post
title: "Design Responsivo Parte II: Listagens e Galerias"
date: 2013-05-24 10:30
comments: true
categories:
  - design
  - css
  - design responsivo
  - mikael carrara
  - media queries
  
---

Na maioria dos contextos, uma parte considerável de uma interface Web é feita de listas. Pense num *e-commerce*, blog ou até mesmo numa *Job Board*. Seja lá o que for, as listas resolvem bem os nossos problemas e são parte fundamental do Web Design.

<!--more-->

Irei agora demonstrar um pouco como podemos "brincar" com listas usando *Media Queries (CSS3)*. No exemplo, criarei uma galeria de imagens simples que se comportará de acordo com a resolução de cada dispositivo, seja ele *Desktop* ou móvel, como *Tablets* e *Smartphones*.

Vamos criar uma listagem com a foto de oito pessoas:

```html
<ul class="team-list">
    <li><img src="#" alt="Pessoa 01" /></li>
    ...
</ul>
```

Então, no CSS eu preciso setar a quantidade de ítens que eu quero por linha. Como são oito ítens no total, utilizaremos quatro por linha:

```css
.team-list li {
    width:23%;
    margin:1% 1% 0 1%;
}
```

100% / 4 = 25%; menos 2% das margens left e right e 23% de largura pra cada ítem da lista. E agora em cada ítem, seto para que a imagem de dentro tenha sempre 100% de largura:

```css
.team-list img {
    width:100%;
}
```

Agora, utilizarei um pouco as *Media Queries* para fazer a mágica acontecer:

```css
@media (max-width:481px) {

	.team-list li {
	    width:48%;
	}

}
```

Quando a lista é acessada de um dispositivo com largura máxima de **481px**, será exibido apenas dois ítens por linha. Use essa lógica para otimizar ao máximo sua lista em cada tipo de resolução.

Utilizando quase o mesmo código, essa galeria de imagens poderia facilmente transformar-se numa listagem responsiva de produtos para *e-commerce*. Um comparador de preços ou qualquer outro tipo de interface que liste algo horizontalmente também se encaixaria. Um conceito importante em **Design Modular** é **Refatoração**.

Ao se trabalhar com listagens responsivas, é muito importante entender o velho e bom **layout fluído**. Dentro dos *breakpoints*, seus componentes (no caso a listagem) devem comportar-se de forma fluída e não engessada. Ou seja, não podemos apenas definir os *breakpoints* e esperar que as “coisas” fiquem certas dentro deles. Estas “coisas” precisam esticar, diminuir, aumentar, se comportar de acordo com cada contexto.

**Conclusão:** Juntando o poder das *Media Queries* e o domínio por completo dos conceitos básicos de *box-model*, você pode criar interfaces bastante trabalhadas e relativamente acessíveis com pouco esforço. Antes de sair enxendo seu design de "firúlas", concentre-se no básico que é criar uma estrutura modular e não fixa; algo que se expanda.

Sua interface não deve ser feita apenas para atender a necessidade de hoje. Ela precisa ser projetada também para o futuro, fácil de ser continuada e integrada a novas features. Web Design é uma diciplina que trabalha com conteúdos e estratégias mutáveis, nada é definido, nada é para sempre. Faça sua interface responder a estas mudanças com facilidade, desenvolvendo-a de forma modular e flexível.

Não pense no Web Design apenas como um layout “codado” em HTML/CSS. Pense num Design projetado para Web que tenha vida própria, como algo subjetivo e não apenas visual.

## Outros posts da série

[Design Responsivo Parte I: Arquivos CSS e Breakpoints](http://helabs.com.br/blog/2013/02/27/design-responsivo-parte-i-arquivos-css-e-breakpoints)

## Links

- [Site Pessoal](http://www.mikaelcarrara.com)
- [Linkedin](br.linkedin.com/in/mikaelcarrara/)
- [Portfólio no Dribbble](http://dribbble.com/mikaelcarrara)