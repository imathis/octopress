---
author: Thiago Belem
layout: post
title: "Gerenciando assets com o Bower"
date: 2013-07-08 13:35
comments: true
categories:
  - Thiago Belem
  - Bower
  - Node.js
  
---

![Bower](http://bower.io/img/bower-logo.png "Bower")

O Bower ([bower.io](http://bower.io)), criado pelo galerê do **Twitter**, é um "gerenciador de pacotes para web", mas especificamente para pacotes de Front-end.

<!--more-->

A ideia por trás dele é bem simples: você lista as dependências de JS (jQuery, jQuery Highlight, Backbone e etc.) em um arquivo `bower.json` que fica dentro do seu projeto, e controla a instalação/atualização desses pacotes por linha de comando.

### Intalando o Bower

Antes de tudo, você vai precisar do [Node.js](http://nodejs.org/) e do [NPM](http://npmjs.org/) instalados na sua máquina.

Agora é só usar o NPM para instalar o Bower globalmente no seu sistema:

```bash
npm install -g bower
```

### Instalando pacotes com o Bower

Agora você pode instalar pacotes de três formas diferentes:

```bash
# Instala os pacotes definidos no bower.json do seu projeto
bower install
# Instala um pacote específico
bower install <package>
# Instala uma versão (git tag) de um pacote
bower install <package>#<version>
```

Onde `<package>` pode ser um dos seguintes itens:

* O nome de um pacote registrado no Bower, por exemplo `jquery`
* Um repositório Git remoto, por exemplo `git://github.com/someone/some-package.git` (público ou privado)
* Um repositório Git local, por exemplo `/var/www/jquery.git/`
* Um atalho para um repositório no GitHub, por exemplo `someone/some-package`
* A URL de um arquivo `zip` ou `tar.gz`

Todos os pacotes serão instalados numa pasta `bower_components` dentro do seu projeto. E a ideia é que você nunca altere o conteúdo dessa pasta, nem dos pacotes dentro dela. Por isso, uma boa é colocá-la no seu `.gitignore`.

### Definindo as dependências do seu projeto no bower.json

O conteúdo do arquivo do seu bower.json descreve o seu projeto e suas dependências num projeto onde usamos o **jQuery** e o **Angular.js**. Ele seria mais ou menos assim:

```json
{
  "name": "meu-projeto",
  "version": "0.0.0",
  "dependencies": {
    "jquery": "master",
    "angular": "1.0.7"
  }
}
```

Após rodar o comando de instalação:

```bash
bower install
```

Veríamos o seguinte output:

```bash
bower cloning git://github.com/angular/bower-angular.git
bower cached git://github.com/angular/bower-angular.git
bower fetching angular
bower cloning git://github.com/components/jquery.git
bower cached git://github.com/components/jquery.git
bower fetching jquery
bower checking out angular#v1.0.7
bower copying /Users/digdin/.bower/cache/angular/ef2188def21eb1bbd1f1792311942a53
bower checking out jquery#2.0.2
bower copying /Users/digdin/.bower/cache/jquery/29cb4373d29144ca260ac7c3997f4381
bower installing angular#1.0.7
bower installing jquery#2.0.2
```

E com isso acabamos de instalar o Angular.js (1.0.7) e o jQuery (2.0.2) no nosso projeto!

Se amanhã sair outra versão do jQuery, podemos atualizá-lo com:


```bash
bower update
```

E o jQuery será atualizado, mas o Angular permancerá na versão 1.0.7, pois foi assim que definimos no nosso `bower.json`.

### Incluindo assets instalados com o Bower

Claro que esse passo é opcional se você estiver incluindo assets de outra forma (Sprockets?). Mas vou deixar aqui um pequeno exemplo para não ficarem dúvidas.

Para incluir os arquivos de um projeto, não existe magia negra, é só usar o caminho completo:

```html
<script src="/bower_components/jquery/jquery.min.js"></script>
<script src="/bower_components/angular/angular.min.js"></script>
```

### Conclusão

Acredito que o Bower tenha bastante futuro, pois estamos cada vez mais tirando as dependências de dentro dos nossos projetos e repositórios, deixando apenas o que é realmente único e importante para a aplicação.

Até a próxima!