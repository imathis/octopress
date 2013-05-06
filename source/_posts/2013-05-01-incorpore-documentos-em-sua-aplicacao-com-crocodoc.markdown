---
author: Rodrigo Reginato Marques
layout: post
title: "Incorpore documentos em sua aplicação com Crocodoc"
date: 2013-05-06 14:56
comments: true
categories: 
  - Rodrigo Reginato
  - Crocodoc

---

O [Crocodoc](https://crocodoc.com/) é uma forma fácil de embutir documentos na sua aplicação protegendo-os de download e CTRL + C/ CTRL + V. É possível adicionar comentários no texto, criar um thumbnail de qualquer arquivo doc, xls e pdf. E ainda, pode-se adicionar uma marca d'água no documento, protegendo-o de print screen.
Para fazer essa integração é necessário fazer um cadastro no site do **crocodoc** para conseguir o _token_. E em seguida, o acesso ao dashboard para acompanhar o gráfico com os uploads dos documentos.

O _token_ é necessário para fazer qualquer transação com a API do **crocodoc**. Ele se parece com o exemplo abaixo:

```ruby
token: A7s7BwvDKOp@nqtYmQfPyLNx
```

<!-- more -->


Dashboard:

![image](/images/posts/2013-05-02/crocodoc_dashboard.jpg)

Será usado o [crocodoc-ruby](https://github.com/crocodoc/crocodoc-ruby), a gem oficial indicada no site do **crocodoc**.

Para fazer o upload dos documentos é bem fácil! Basta usar as 2 linhas de código abaixo: (Explicarei mais adiante sobre o _path_ do arquivo.)

```ruby
Crocodoc.api_token = "A7s7BwvDKOp@nqtYmQfPyLNx"
uid = Crocodoc::Document.upload(path_do_arquivo)
```

É gerado um _uid_ que através dele será possível acessar o documento mais tarde. Portanto, grave esse uid para cada arquivo que for feito upload.

Existem 2 formas de visualizar o documento: por Iframe ou pela [API](https://crocodoc.com/docs/js-intro/) via javascript. Nesta, tive alguns problemas com o layout. Toda vez que um usuário for visualizar um arquivo é necessário gerar uma sessão específica do **crocodoc**. Lembrando que cada sessão é válida por 1 hora. Para gerá-la basta usar o seguinte código:

```ruby
Crocodoc.api_token = " A7s7BwvDKOp@nqtYmQfPyLNx "
session_key = Crocodoc::Session.create(document.uid, {'is_editable' => false, 'is_downloadable' => false, 'is_copyprotected' => true})
```

Na sessão, ainda é possível passar alguns parâmetros como proteger o documento de cópia, download e edição. Estas opções são as mais importantes, mas existem outras como filtros e sidebar.

É necessária uma cópia do projeto que está utilizando o **crocodoc** na _Amazon S3_. 
Logo, o processo de upload do documento para a Amazon é o mesmo. Nós optamos pela _gem_ [carrierwave](https://github.com/jnicklas/carrierwave).

Assim que o envio para a _Amazon S3_ é finalizado, gera-se uma URL. A partir dela, é feita o upload do documento para o **crocodoc**. Outro item fundamental é o suporte. As dúvidas enviadas são esclarecidas através do email, com no máximo, 24 horas. 


Nesse [link](https://crocodoc.com/see-it-in-action/) é possível ver o **crocodoc** em ação.
