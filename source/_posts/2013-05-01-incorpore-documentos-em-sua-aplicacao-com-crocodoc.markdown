---
author: Rodrigo Reginato Marques
layout: post
title: "Incorpore documentos em sua aplicação com Crocodoc"
date: 2013-05-01 14:56
comments: true
categories: 
  - Rodrigo Reginato
  - Crocodoc
---

O [Crocodoc](https://crocodoc.com/) é uma forma fácil de embutir documentos na sua aplicação protegendo-os de download, CTRL + C, CTRL + V, adicionar comentários no texto, criar um thumbnail de qualquer arquivo doc, xls e pdf e ainda é possível adicionar uma marca d'água no documento, protegendo de print screen.
Para fazer essa integração é necessário fazer um cadastro no site do crocodoc para conseguir o token e o acesso ao dashboard para acompanhar o gráfico com os uploads dos documentos.

O token é necessário para fazer qualquer transação com a API do crocodoc, é parecido com isso:

```ruby
token: A7s7BwvDKOp@nqtYmQfPyLNx
```

<!-- more -->


Dashboard:

![image](/images/posts/2013-05-02/crocodoc_dashboard.jpg)

Será usado a gem [crocodoc-ruby](https://github.com/crocodoc/crocodoc-ruby) que é a gem oficial indicada no site do crocodoc.

Para fazer o upload dos documentos é bem fácil basta usar essas 2 linhas de código. O path do arquivo irei explicar mais adiante.

```ruby
Crocodoc.api_token = "A7s7BwvDKOp@nqtYmQfPyLNx"
uid = Crocodoc::Document.upload(path_do_arquivo)
```

É gerado um uid que através dele será possível acessar o documento mais tarde, por tanto, grave esse uid para cada documento que for feito upload.

Existe 2 formas de vizualizar o documento, pode ser por Iframe ou pela [API](https://crocodoc.com/docs/js-intro/) via javascript.

Via javascript por exemplo tive alguns problemas com o layout.

Toda vez que um usuário for visualizar um arquivo é necessário gerar uma sessão especifica do crocodoc, cada sessão é válida por 1 hr.

Para gerar a sessão basta usar o seguinte código:

```ruby
Crocodoc.api_token = " A7s7BwvDKOp@nqtYmQfPyLNx "
session_key = Crocodoc::Session.create(document.uid, {'is_editable' => false, 'is_downloadable' => false, 'is_copyprotected' => true})
```

Na sessão ainda é possível passar alguns parâmetros como proteger o documento de cópia, download e edição. Essas opções são as mais importantes, existem outras como filtros e sidebar mas não irei aprofundar tanto.

No projeto que está utilizando o crocodoc, é necessário que uma cópia do documento seja enviado para o Amazon S3.
Portanto o processo de upload do documento para o Amazon é o mesmo. Nós optamos pela gem [carrierwave](https://github.com/jnicklas/carrierwave).
Assim que o upload para o Amazon S3 é finalizado é gerado uma URL e apartir dessa URL é feito o upload do documento para o crocodoc.

Outra item fundamental é o suporte, as dúvidas foram tiradas por email com delay de no máximo 24 hrs para todas as perguntas.

Nesse [link] (https://crocodoc.com/see-it-in-action/) é possível ver o crocodoc em ação.
