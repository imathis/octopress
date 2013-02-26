---
layout: post
author: Rodrigo Reginato Marques
title: "Scoped route com a gem friendly_id"
date: 2013-02-26 11:00
comments: true
categories:
  - rodrigo reginato marques
  - rails
  - friendly_id
  - clubedomenu
  - routes
---

Quando participei do desenvolvimento do projeto [clubedomenu.com](http://clubedomenu.com), um sistema voltado para delivery de comida, foi feito pensando exclusivamente para a cidade de Londrina. 
Recentemente surgiu a necessidade de expandir o sistema para outras localidades.
Feito um estudo das funcionalidades existentes. 
<!-- more -->

Foi visto que as urls do sistema foram contruídas dessa forma:

```
clubedomenu.com/nome_do_restaurante
```

Agora é preciso que a url seja montada dessa forma, para distinguir os restaurantes por cidade:

```
clubedomenu.com.br/nome_da_cidade/nome_do_restaurante
```

Além disso pode acontecer casos onde 2 restaurantes em diferentes cidades com o mesmo slug nome_do_restaurante. Como isso pode acontecer? Muito simples, basta a mesma empresa ter uma matriz e uma filial com o mesmo nome em cidades diferentes.

Desde o começo do projeto foi adotado a gem [friendly_id](https://github.com/norman/friendly_id) que transforma as urls em uma forma mais amigável.

Para resolver o problema de franquia de restaurantes em cidades diferentes com o mesmo slug a gem oferece essa solução:

```ruby
friendly_id :nome_do_campo_restaurante, :use => :scoped, :scope => :nome_do_campo_cidade.
validates_uniqueness_of :nome_do_campo_restaurante, :scope => :city
```

Dessa forma é possível obter urls assim.

```
clubedomenu.com.br/nome_da_cidade_1/nome_do_restaurante
clubedomenu.com.br/nome_da_cidade_2/nome_do_restaurante
```

Aqui está um teste que prova que é possível ter subdomínios iguais em cidades diferentes.

```ruby
describe "scoped city" do
    let!(:restaurant_1) { FactoryGirl.create(:restaurant, name: "Pizzaria Boa", city: "Maringa", subdomain: "veneza") }
    let!(:restaurant_2) { FactoryGirl.create(:restaurant, name: "Pizzaria Boa", city: "Londrina", subdomain: "veneza") }
    it "should repeat slug scoped by city", :vcr do
      restaurant_1.to_param.should eq("veneza")
      restaurant_2.to_param.should eq("veneza")
    end
end
```

Twitter [@reginato](http://twitter.com/reginato)