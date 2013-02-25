---
author: Pedro Marins
layout: post
title: "Melhorando a performance do web site com gzip"
date: 2013-02-01 12:30
comments: true
categories:
  - pedro marins
  - performance
  - http compression
  - gzip
  
---

O tempo inteiro chovem dicas de performance pela internet. É bem difícil filtrar tudo que aparece e saber o que realmente importa, o que realmente dá resultado, e mais ainda, o que é fácil de se fazer. Não adianta uma solução mirabolante, em que para ganhar 1 milisegundo tenhamos que envolver toda a equipe de um projeto e consumir um sprint inteiro.
<!-- more -->

Assistindo uma palestra do [Chris Coyier](https://twitter.com/chriscoyier), fiquei impressionado em como ele organizou as dicas. Achei genial a forma como ele resumiu como uma dica de performance deve ser. E a dica de hoje segue esses pontos:

- Eleve a performance de bom à excelente.
- __Uma__ única pessoa pode resolver.
- Não necessite de processos complexos.
- Não precise de manutenção constante.

O objetivo desse post, é explicar como usar o gzip para que os arquivos do seu website sejam comprimidos e fornecidos ao browser quando receber uma requisição. Uma dica simples, mas de altíssimo impacto. _Comprimir_ os arquivos reduz o tempo de transferência de arquivos em **70%** em media.

O primeiro passo para ativar a compressão de HTTP é conferir se o seu projeto já está comprimido. Você pode testar a sua url nesse site: 
__[http://gzipwtf.com/](http://gzipwtf.com/)__

Se já tiver comprimido seu trabalho já está feito. Se foi alguem da sua equipe, descubra e dê os parabéns, se não foi, a compressão pode ter sido feita pelo serviço de hospedagem que você está usando, por exemplo. Sei que o [Heroku](http://heroku.com), o serviço que usamos para hospedar os 40+ projetos internos e de clientes aqui na [HE:labs](http://helabs.com.br) já faz isso automáticamente, por exemplo.

Se você constatou que no seu projeto os arquivos não estão comprimidos, a única coisa que precisa fazer é colar esse código no ```.htaccess``` se você usar o Apache. 

```
# ----------------------------------------------------------------------
# Gzip compression
# ----------------------------------------------------------------------

<IfModule mod_deflate.c>

  # Force deflate for mangled headers developer.yahoo.com/blogs/ydn/posts/2010/12/pushing-beyond-gzipping/
  <IfModule mod_setenvif.c>
    <IfModule mod_headers.c>
      SetEnvIfNoCase ^(Accept-EncodXng|X-cept-Encoding|X{15}|~{15}|-{15})$ ^((gzip|deflate)\s*,?\s*)+|[X~-]{4,13}$ HAVE_Accept-Encoding
      RequestHeader append Accept-Encoding "gzip,deflate" env=HAVE_Accept-Encoding
    </IfModule>
  </IfModule>

  # Compress all output labeled with one of the following MIME-types
  # (for Apache versions below 2.3.7, you don't need to enable `mod_filter`
  # and can remove the `<IfModule mod_filter.c>` and `</IfModule>` lines as
  # `AddOutputFilterByType` is still in the core directives)
  <IfModule mod_filter.c>
    AddOutputFilterByType DEFLATE application/atom+xml \
                                  application/javascript \
                                  application/json \
                                  application/rss+xml \
                                  application/vnd.ms-fontobject \
                                  application/x-font-ttf \
                                  application/xhtml+xml \
                                  application/xml \
                                  font/opentype \
                                  image/svg+xml \
                                  image/x-icon \
                                  text/css \
                                  text/html \
                                  text/plain \
                                  text/x-component \
                                  text/xml
  </IfModule>

</IfModule>
```

Simples assim!

Com esse código, a compressão já está habilitada e os arquivos do seu site estarão carregando ridiculamente mais **rápido**.

Esse conteúdo foi retirado do ```.htaccess``` do HTML5 Boilerplate, que além de ser um excelente boilerplate para iniciar o seu projeto, é um repositório enorme de excelentes dicas e boas práticas.

Espero que essa dica seja útil para você! Em breve postarei outras dicas simples e efetivas.

Aquele abraço,
Pedro Marins
