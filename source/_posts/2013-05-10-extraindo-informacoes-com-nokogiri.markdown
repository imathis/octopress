---
published: true
author: Thiago Borges
layout: post
title: "Extraindo informações com Nokogiri"
date: 2013-05-15 11:00
comments: true
categories:
  - Thiago Borges
  - Nokogiri
  - Scraping
  - Crawling

---


Uma área de grande importância na computação é a extração de dados em sistemas web.
Nesse post irei abordar o uso da _gem_ **Nokogiri** para coletar essas informações, processo também conhecido por _Web Scraping_. Foi através desse trabalho que o Google iniciou seu império e ainda, muitos outros cases de sucesso utilizam esta técnica para oferecer serviços.

<!-- more -->

**Nokogiri** é uma poderosa _gem_ que realiza parsing de HTML e XML. Uma importante característica é a habilidade de utilizar seletores XPath e CSS3 para encontrar os nós da árvore DOM desejados. Isso faz com que o processo seja muito mais legível, fácil de acompanhar e de manter.

Como dito anteriormente, pode-se percorrer sites de compras e nele, realizar comparação de preço, listar imóveis de imobiliárias, criar API com JSON ou XML otimizadas para o consumo, dentre outras inúmeras utilidades.


# Seletores
Seletores são padrões que indicam uma parte do código HTML, como se fossem endereços. Para encontrar as informações, é preciso escolher os melhores seletores para determinado problema. Um bom seletor precisa ser específico o bastante para não selecionar informações erradas, mas não tão rígido a ponto de quebrar, caso a estrutura do site mude um pouco.

O código abaixo será usado pra exemplificar os seletores:


```html cinemas.html
<div class="theater">
  <div class="desc">
    <h2 class="name">Kinoplex Shopping Tijuca</h2>
  </div>
</div>
<div class="theater">
  <div class="desc">
    <h2 class="name">Iguatemi</h2>
  </div>
</div>
```

### XPath
O seletor XPath se baseia na árvore DOM para encontrar os nós. DOM é a estrutura que representa a organização dos elementos HTML e XML.
O caminho do XPath é fácil de ser encontrado e substituído, mas você pode ter problemas caso o HTML não esteja correto.

A seleção dos nomes dos cinemas acima é feita da seguinte forma:

```ruby
require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(File.open("cinemas.html"))
doc.xpath('//div[@class="desc"]/h2[@class="name"]').each do |node|
  puts node.text
end
```

Este exemplo deve exibir "Kinoplex Shopping Tijuca" e "Iguatemi".

Caso esteja utilizando o Google Chrome, o [XPath Helper](https://chrome.google.com/webstore/detail/xpath-helper/hgimnogjllphhhkhlmebbmlgjoejdpjl?utm_source=chrome-ntp-icon) pode ser utilizado para auxiliar na procura e teste de XPath.
Com o [Firebug](https://getfirebug.com) é possível copiar tanto o XPath quanto o CSS.

### CSS
O seletor CSS do **Nokogiri** é o mesmo utilizado no jQuery. São verificadas, principalmente, as classes, IDs e elementos do documento.

O exemplo abaixo retorna a mesma informação do código que utiliza xpath.

```ruby
require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(File.open("cinemas.html"))
doc.css('.desc > h2.name').each do |node|
  puts node.text
end
```


# Exemplo

Pra colocar em prática o que foi visto até aqui, fiz esse exemplo para listar os integrantes da HE:Labs e suas respectivas posições na empresa:

```ruby
require 'open-uri'
require 'nokogiri'

class Avassalador
  def initialize(node)
    @name = node.xpath("text()").text().strip
    @position = node.xpath("span/text()").text().strip
  end
  def to_s
    "#{@name} - #{@position}"
  end
end

doc = Nokogiri::HTML(open("http://helabs.com.br/nossotime/"))
doc.xpath('//*[@id="time"]/div/ul/li/p').each do |node|
  puts Avassalador.new(node)
end
```

Além dos elementos serem iteráveis, pode-se utilizar a API para navegar pelos nós da estrutura. Esta API pode ser utilizada para nós extraidos por XPath e CSS. Os métodos são:

```ruby
node.parent           #=> nó pai. (Sobe um nível na árvore)
node.children         #=> nós filhos. (Desce um nível na árvore)
node.next_sibling     #=> próximo irmão. (Seleciona o próximo elemento no mesmo nível)
node.previous_sibling #=> irmão anterior. (Volta um elemento no mesmo nível)
```

# Legalidade
Não é permitido publicar conteúdo na íntegra sem permissão. Se houver permissão, a fonte deve ser citada. Em 2005, o Google News foi processado por publicar conteúdo da [AFP](http://www.afp.com/) sem permissão. Para realizar análise de informações, a questão de direitos autorais pode ser parcialmente ignorada. Exemplo disso é o PageRank do Google que analisa o conteúdo das páginas, avalia sua relevância, mas não os reproduz.

Deve-se, também, respeitar as instruções do robots.txt. Nele, o scraper não pode acessar nada dentro do caminho /tmp/. :
```
User-agent: *
Disallow: /tmp/
```

É possível definir regras para User-agents específicos como o bot do Google. Clique para [informações complementares](http://www.robotstxt.org/robotstxt.html).


# Bônus

A _gem_ [google_movies](https://github.com/lucasallan/google_movies) é um exemplo de wrapper que retorna as informações sobre cinemas e filmes através do próprio Google Movies. Ela serve como uma referência bem completa e ao mesmo tempo simples de entender o processo.
