---
author: Thiago Belem
layout: post
title: "Protegendo seus buckets do S3 com chaves IAM"
date: 2013-05-09 11:00
comments: true
categories:
  - Thiago Belem
  - S3
  - IAM
  - AWS

---

![image](/images/posts/2013-05-08/bucket.jpg)

Você usa **buckets** do S3 para armazenar os uploads e assets da sua aplicação?

A maioria das pessoas usam os mesmos dados de acesso (_access key_ e _secret access key_) para acessar o(s) bucket(s), tanto em desenvolvimento quanto em produção.

Isso pode trazer alguns problemas para a aplicação...

<!-- more -->
Como:

* Os dados de acesso ao bucket (e provavelmente à conta do AWS) estão presentes nos arquivos de configuração;
* O bucket acessado (e bombardeado com arquivos de testes) é o mesmo bucket usado em produção;
* Não há nenhum tipo de restrição, quem estiver trabalhando no desenvolvimento do projeto terá acesso ao bucket com os arquivos de produção.

A solução para todos os problemas acima é restringir o acesso aos buckets, separando os dados de acesso (chaves) de cada um:

# Crie dois buckets

Não há nada de misterioso ou novo aqui, apenas crie dois buckets:

* Um bucket para desenvolvimento: **meuprojeto-development**
* Um bucket para production: **meuprojeto-produciton**

# Crie dois usuários IAM

Agora você precisa criar dois usuários (pra facilitar, com o mesmo nome dos buckets):


![image](/images/posts/2013-05-08/iam-new-user.png)

![image](/images/posts/2013-05-08/iam-new-users.png)

Não se esqueça de anotar as chaves de acesso de cada usuário:

![image](/images/posts/2013-05-08/iam-credentials.png)

# Defina as regras de acesso

Agora que os usuários estão criados, precisamos definir permissões de acesso.

Marque um usuário. Para isso, vá em **Permissions** > **Attach User Policy** > Custom Policy.

Dê um nome pra regra e use o seguinte template:

```json
{
  "Statement": [
    {
      "Sid": "Stmt1368030337093",
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::NOME_DO_BUCKET/*"
      ]
    }
  ]
}
```

Substitua **NOME_DO_BUCKET** pelo nome do bucket criado anteriormente e crie essa regra para o bucket de cada usuário.

# Conclusão

Agora você tem dois buckets com acessos separados, um para desenvolvimento e um para produção.

Espero que tenham gostado, e até a próxima! :)