---
published: true
author: Cayo Medeiros (yogodoshi)
layout: post
title: "Evitando problemas com datas e time zones no Rails"
date: 2013-06-11 10:20
comments: true
categories:
  - time zone
  - data
  - hora
  
---
Volta e meia passo por alguns **problemas com time zones no Rails**. Hoje, demonstrarei algumas dicas para evitá-los:
<!-- more -->

A primeira coisa a ser feita para evitar problemas é **setar a time zone do projeto** no `config/application.rb` para Brasília (se o site for basileiro): `config.time_zone = 'Brasilia'` e não para "UTC -3" ou algo do gênero; de forma a evitar problemas com horário de verão também.

Dessa forma, o Rails permanecerá a hora certa para que seja salva no banco de dados corretamente em UTC 0, como mandam as regras. Da mesma forma, quando você puxar algo salvo no banco em UTC 0, ele já mostrará na tela a time zone do projeto utilizada corretamente.

Só que não!

O problema é que o Rails tem métodos que retornam a data em UTC 0 e outros, de acordo com a time zone do projeto.

Porém, a **boa notícia** é que você pode seguir essa cheat sheet sempre que for trabalhar com time zones para não ter problemas e rapidamente irá decorar quais métodos devem ou não ser usados.

## Não use
```ruby
  Time.now # => Retorna o horário do sistema e ignora a time zone do projeto.
  Time.parse("2012-03-02 16:05:37") # => Irá assumir que a string recebida tá na time zone do sistema.
  Time.strptime(time_string, '%Y-%m-%dT%H:%M:%S%z') # Mesmo problema do Time.parse.
  Date.today # Pode ser ontem ou amanhã de acordo com a time zona setada na máquina.
  Date.today.to_time # => # Também não segue a time zone do projeto.
```

## Use
```ruby
  2.hours.ago # => Fri, 02 Mar 2012 20:04:47 UTC -03:00
  1.day.from_now # => Fri, 03 Mar 2012 22:04:47 UTC -03:00
  Date.today.to_time_in_current_zone # => Fri, 02 Mar 2012 22:04:47 UTC -03:00
  Date.current # => Fri, 02 Mar
  Time.zone.parse("2012-03-02 16:05:37") # => Fri, 02 Mar 2012 16:05:37 UTC -03:00
  Time.zone.now # => Fri, 02 Mar 2012 22:04:47 UTC -03:00
  Time.current # Mesma coisa, só que de forma mais curta.
  Time.zone.today # Se você não pode usar Time ou DateTime.
  Time.zone.now.utc.iso8601 # Quando for trabalhar com APIs.
  Time.strptime(time_string, '%Y-%m-%dT%H:%M:%S%z').in_time_zone(Time.zone) # Se não pode usar Time.pars
```

Outra dica que recomendo é sempre escrever testes com horários limites. Exemplo: se quero uma query com os itens da semana passada, crio documentos no banco com domingo 23:59 e segunda 00:01, justamente para ter certeza de que não teremos problemas com time zone em lugar algum.

Fonte: [o excelente post da elabs.se][1] (quase nossa xará =p)

[1]: http://www.elabs.se/blog/36-working-with-time-zones-in-ruby-on-rails title: "elabs.se"
