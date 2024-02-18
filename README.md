# API da comunidade
# Índice
1. [Listagem dos posts](#listagem-dos-posts)
2. [Obtenha uma postagem específica](#obtenha-uma-postagem-especifica)
- [Tags da resposta da consulta de posts](#tags-da-resposta-da-consulta-de-posts)
3. [Listagem dos comentários](#listagem-dos-comentarios)
4. [Obtenha um comentário específico](#obtenha-um-comentario-especifico)
- [Tags da resposta da consulta de comentários](#tags-da-resposta-da-consulta-de-comentarios)
5. [Listar todas as categorias](#inicializar-app-com-autenticacao)
6. [Criar uma nova postagem](#criar-uma-nova-postagem)
7. [Apagar uma postagem](#apagar-uma-postagem)
8. [Criar um novo comentário](#criar-um-novo-comentario)
9. [Apagar um comentário](#apagar-um-comentario)
10. [Curtir e desfazer uma curtida a uma postagem ou comentário](#curtir-e-desfazer-uma-curtida-a-uma-postagem-ou-comentario)
11. [API e conexão com o App Flutter](#api-e-conexao-com-o-app-flutter)


# Preparar o sistema para receber os dados e enviar os dados
- Para conectar o sistema é necessário configurar um token, esse token serve para realizar a autenticação entre o sistema.
- Esse token podem ser pego no Dashboard na aba configurações, campo 'Token'

## $TOKEN_API
- O token para autenticar o painel não é o token do usuário
## $TOKEN_USER
- O token do usuário, token obtido ao fazer login no aplicativo, não é obrigatório, mas é mais útil para verificar se o usuário recebeu curtidas em postagens ou comentários.

# ----------Postagens----------
# Tags da resposta da consulta de posts
```json
[
    {
        "tag": "ID",
        "tipo": "int",
        "Descrição": "Retorna o ID da postagem."
    },
    {
        "tag": "title",
        "tipo": "string",
        "Descrição": "Retorna o título da postagem."
    },
    {
        "tag": "content",
        "tipo": "string",
        "Descrição": "Retorna o conteúdo da postagem, que pode ser texto ou formato HTML."
    },
    {
        "tag": "category",
        "tipo": "string",
        "Descrição": "Retorna a categoria que se encontra o post."
    },
    {
        "tag": "post_date",
        "tipos": [
            "json",
            "null"
        ],
        "Descrição": "Retorna dois parâmetros se houver mídia na postagem.",
        "data": [
            {
                "tag": "type_media",
                "tipo": "string",
                "Descrição": "Retornar apenas 2 valores entre `foto` ou `video` se referindo ao formato do arquivo."
            },
            {
                "tag": "url",
                "tipo": "string",
                "Descrição": "Retornar o caminho do arquivo para consumo."
            }
        ]
    },
    {
        "tag": "like",
        "tipo": "bool",
        "Descrição": "Retorna se o usuário logado curtiu a postagem."
    },
    {
        "tag": "comments_count",
        "tipo": "int",
        "Descrição": "Retorna o número de comentários na postagem."
    },
    {
        "tag": "is_my_post",
        "tipo": "bool",
        "Descrição": "Retorna true se o post pertencer a pessoa logado no app."
    },
    {
        "tag": "author",
        "tipo": "json",
        "Descrição": "Retorna um JSON com os dados do author da postagem:",
        "data": [
            {
                "tag": "ID",
                "tipo": "int",
                "Descrição": "Que retorna o ID do usuário que fez apostagem."
            },
            {
                "tag": "avatar",
                "tipo": "string",
                "Descrição": "Retorna a foto de perfil do usuário."
            },
            {
                "tag": "user_email",
                "tipo": "string",
                "Descrição": "Retorna o e-mail do usuário."
            },
            {
                "tag": "display_name",
                "tipo": "string",
                "Descrição": "Retorna o nome do usuário."
            }
        ]
    }
]
```

# Listagem dos posts

1. Para solicitar postagens.
```dart
 var endpoint = 'http://notifications.poletododia.com/api/community/posts';
```

2. Há alguns parâmetros a serem passados para realizar a consulta

```text
limit: O limit é passado para determinar quantas postagem vêm por página. 
offset: o número da página
```

3. Exemplo usando parâmetros
```dart
// Este exemplo ira fazer a consulta e vai retornar 10 postagens
var exemple1 = '$endpoint?limit=10&offset=1'

// Este exemplo ira retornar 20 postagem
var exemple2 = '$endpoint?limit=10&offset=2'

```

4. Se nenhum parâmetro for passado, por padrão será limit=20 e offset=1

5. Existe um parâmetro opcional chamado `with_comments` que retorna comentários diretamente na lista de todos os posts
- Por padrão, este parâmetro é `0`
```dart
var exemple1 = '$endpoint?with_comments=1';

var exemple2 = '$endpoint?limit=10&offset=1&with_comments=1';
```

6. Faça a consulta obtendo os comentários nas postagens diretamente na lista.
```dart 
 URL = '$endpoint?limit=10&offset=1&with_comments=1'
 Type = 'GET'
 Headers = {
    "Authorization": "Bearer $TOKEN_API",
    "token": "$TOKEN_USER",
    "Content-Type": "application/json"
 } 
```
- Resposta
```json
{
    "data": {
        "total_size": 2122,
        "limit": "10",
        "offset": "1",
        "posts": [
            {
                "ID": 10725,
                "title": "Postagem test",
                "content": "Postagem test",
                "post_date": "2024-02-16 18:45:02",
                "media": {
                    "type_media": "foto",
                    "url": "https://play.poletododia.com/wp-content/themes/play-pole/images/avatar-default.png",
                },
                "like": false,
                "comments_count": 1,
                "is_my_post": true,
                "category": "Desafio SEM BARRA",
                "author": {
                    "ID": 1186,
                    "avatar": "https://play.poletododia.com/wp-content/themes/play-pole/images/avatar-default.png",
                    "user_email": "restritodk.ls@gmail.com",
                    "display_name": "Eurico"
                },
                "comments": [
                    {
                        "ID": 2556,
                        "post_id": 10725,
                        "comment_date": "2024-02-16 18:47:08",
                        "content": "Muito bom <span style=\"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 16px; font-style: normal; font-variant-caps: normal; font-weight: 700;\"><span class=\"mention-area\"><span class=\"highlight\"><span data-item-id=\"1186\" class=\"mentiony-link\" contenteditable=\"false\">Eurico</span></span></span><span class=\"normal-text\"> </span></span>",
                        "like": false,
                        "is_my_comment": true,
                        "user": {
                            "ID": 1186,
                            "avatar": "https://play.poletododia.com/wp-content/themes/play-pole/images/avatar-default.png",
                            "user_email": "restritodk.ls@gmail.com",
                            "display_name": "Eurico"
                        }
                    }
                ]
            },
            ...
        ]
    }
}
```

6. Faça a consulta sem os comentários nas postagens diretamente na lista.
```dart 
 URL = '$endpoint?limit=10&offset=1'
 Type = 'GET'
 Headers = {
    "Authorization": "Bearer $TOKEN_API",
    "token": "$TOKEN_USER",
    "Content-Type": "application/json"
 } 
```
- Resposta
```json
{
    "data": {
        "total_size": 2122,
        "limit": "10",
        "offset": "1",
        "posts": [
            {
                "ID": 10725,
                "title": "Postagem test",
                "content": "Postagem test",
                "post_date": "2024-02-16 18:45:02",
                "media": {
                    "type_media": "foto",
                    "url": "https://play.poletododia.com/wp-content/themes/play-pole/images/avatar-default.png",
                },
                "like": false,
                "comments_count": 1,
                "is_my_post": true,
                "category": "Desafio SEM BARRA",
                "author": {
                    "ID": 1186,
                    "avatar": "https://play.poletododia.com/wp-content/themes/play-pole/images/avatar-default.png",
                    "user_email": "restritodk.ls@gmail.com",
                    "display_name": "Eurico"
                }
            },
            ...
        ]
    }
}
```

# Obtenha uma postagem especifica

1. Para solicitar uma postagem.
```dart
 var $postId = 1; // ID da postagem
 var endpoint = 'http://notifications.poletododia.com/api/community/post/$postId';
```
- Parâmetro `$postId` é o ID da postagem a ser consultada
- Parâmetro opcional `with_comments` valor por padrão `0`
- Valor `1` retorna comentários, valor `0` ou qualquer outro não retorna comentários

2. Consulta pegando comentários usando o parâmetro `with_comments=1`.
```dart
 URL = '$endpoint?with_comments=1'
 Type = 'GET'
 Headers = {
    "Authorization": "Bearer $TOKEN_API",
    "token": "$TOKEN_USER",
    "Content-Type": "application/json"
 } 
```

- Se o ID passo não existir será retornado `Post not found`

- Resposta
```json
{
    "data": {
        "ID": 10725,
        "title": "Postagem test",
        "content": "Postagem test",
        "post_date": "2024-02-16 18:45:02",
        "media": {
            "type_media": "foto",
            "url": "https://play.poletododia.com/wp-content/themes/play-pole/images/avatar-default.png",
        },
        "like": false,
        "comments_count": 1,
        "author": {
            "ID": 1186,
            "avatar": "https://play.poletododia.com/wp-content/themes/play-pole/images/avatar-default.png",
            "user_email": "restritodk.ls@gmail.com",
            "display_name": "Eurico"
        },
        "comments": [
            {
                "ID": 2556,
                "post_id": 10725,
                "comment_date": "2024-02-16 18:47:08",
                "content": "Muito bom <span style=\"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: "Open Sans", sans-serif; font-size: 16px; font-style: normal; font-variant-caps: normal; font-weight: 700;\"><span class=\"mention-area\"><span class=\"highlight\"><span data-item-id=\"1186\" class=\"mentiony-link\" contenteditable=\"false\">Eurico</span></span></span><span class=\"normal-text\"> </span></span>",
                "like": false,
                "user": {
                    "ID": 1186,
                    "avatar": "https://play.poletododia.com/wp-content/themes/play-pole/images/avatar-default.png",
                    "user_email": "restritodk.ls@gmail.com",
                    "display_name": "Eurico"
                }
            }
        ]
    }
}
```

3. Consulta sem pegar comentários.
```dart
 URL = endpoint
 Type = 'GET'
 Headers = {
    "Authorization": "Bearer $TOKEN_API",
    "token": "$TOKEN_USER",
    "Content-Type": "application/json"
 } 
```
- Resposta
```json
{
    "data": {
        "ID": 10725,
        "title": "Postagem test",
        "content": "Postagem test",
        "post_date": "2024-02-16 18:45:02",
        "media": {
            "type_media": "foto",
            "url": "https://play.poletododia.com/wp-content/themes/play-pole/images/avatar-default.png",
        },
        "like": false,
        "comments_count": 1,
        "author": {
            "ID": 1186,
            "avatar": "https://play.poletododia.com/wp-content/themes/play-pole/images/avatar-default.png",
            "user_email": "restritodk.ls@gmail.com",
            "display_name": "Eurico"
        }
    }
}
```

# ----------Comentários----------
# Tags da resposta da consulta de comentarios
```json
[
    {
        "tag": "ID",
        "tipo": "int",
        "Descrição": "Retorna o ID da comentário."
    },
    {
        "tag": "post_id",
        "tipo": "int",
        "Descrição": "Retorna o ID da postagem que o comentário foi criado."
    },
    {
        "tag": "content",
        "tipo": "string",
        "Descrição": "Retorna o conteúdo do comentário, que pode ser texto ou formato HTML."
    }, 
    {
        "tag": "is_my_comment",
        "tipo": "bool",
        "Descrição": "Retorna true se o post pertencer a pessoa logado no app."
    },
    {
        "tag": "comment_date",
        "tipo": "string",
        "Descrição": "Retorna a data em que o comentário foi feita."
    },
    {
        "tag": "like",
        "tipo": "boolean",
        "Descrição": "Retorna se o usuário logado curtiu a postagem."
    },
    {
        "tag": "user",
        "tipo": "json",
        "Descrição": "Retorna um JSON com os dados do author do comentário:",
        "data": [
            {
                "tag": "ID",
                "tipo": "int",
                "Descrição": "Que retorna o ID do usuário que fez o comentário."
            },
            {
                "tag": "avatar",
                "tipo": "string",
                "Descrição": "Retorna a foto de perfil do usuário."
            },
            {
                "tag": "user_email",
                "tipo": "string",
                "Descrição": "Retorna o e-mail do usuário."
            },
            {
                "tag": "display_name",
                "tipo": "string",
                "Descrição": "Retorna o nome do usuário."
            }
        ]
    }
]
``` 

# Listagem dos comentarios
1. Para solicitar os comentários
```dart
  var postId = 1; // ID do post que deseja pegar os comentários
  var endpoint = 'http://notifications.poletododia.com/api/community/comments/$postId';
```

2. O parâmetro `postId` na rota é obrigatório.

3. Os parâmetros `limit` e `offset` são opcionais
- Se o `limit` não for passado a listagem vai retornar todos os comentários do post

4. Consulta com `limit` e `offset` sendo passados.

```
 URL = '$endpoint?limit=10&offset=1'
 Type = 'GET'
 Headers = {
    "Authorization": "Bearer $TOKEN_API",
    "token": "$TOKEN_USER",
    "Content-Type": "application/json"
 } 
```

- Se não existe um post com o `ID` passado a resta sera `Comment not found`

- Resposta
```json
{
    "data": {
        "total_size": 1,
        "limit": "10",
        "offset": "1",
        "comments": [
            {
                "ID": 2556,
                "post_id": 10725,
                "comment_date": "2024-02-16 18:47:08",
                "content": "Muito bom <span style=\"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 16px; font-style: normal; font-variant-caps: normal; font-weight: 700;\"><span class=\"mention-area\"><span class=\"highlight\"><span data-item-id=\"1186\" class=\"mentiony-link\" contenteditable=\"false\">Eurico</span></span></span><span class=\"normal-text\"> </span></span>",
                "like": false,
                "is_my_comment": true,
                "user": {
                    "ID": 1186,
                    "avatar": "https://play.poletododia.com/wp-content/themes/play-pole/images/avatar-default.png",
                    "user_email": "restritodk.ls@gmail.com",
                    "display_name": "Eurico"
                }
            },
            ...
        ]
    }
}
```

5. Consulta sem `limit` e `offset`, nessa caso todos os comentários seram listados.

```
 URL = endpoint
 Type = 'GET'
 Headers = {
    "Authorization": "Bearer $TOKEN_API",
    "token": "$TOKEN_USER",
    "Content-Type": "application/json"
 } 
```

- Se não existe um post com o `ID` passado a resta sera `Comment not found`

- Resposta
```json
{
    "data": [
        {
            "ID": 2556,
            "post_id": 10725,
            "comment_date": "2024-02-16 18:47:08",
            "content": "Muito bom <span style=\"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 16px; font-style: normal; font-variant-caps: normal; font-weight: 700;\"><span class=\"mention-area\"><span class=\"highlight\"><span data-item-id=\"1186\" class=\"mentiony-link\" contenteditable=\"false\">Eurico</span></span></span><span class=\"normal-text\"> </span></span>",
            "like": false,
            "user": {
                "ID": 1186,
                "avatar": "https://play.poletododia.com/wp-content/themes/play-pole/images/avatar-default.png",
                "user_email": "restritodk.ls@gmail.com",
                "display_name": "Eurico"
            }
        },
        ...
    ]
}
```

# Obtenha um comentario especifico
1. Para solicitar um comentário.
```dart
 var $commentId = 1; // ID do comentário
 var endpoint = 'http://notifications.poletododia.com/api/community/comment/$commentId';
```
- Parâmetro `$commentId` é o ID do comentário a ser consultado

2. Consulta pegando comentário.
```dart
 URL = endpoint
 Type = 'GET'
 Headers = {
    "Authorization": "Bearer $TOKEN_API",
    "token": "$TOKEN_USER",
    "Content-Type": "application/json"
 } 
```

- Se o ID não for econtrado será retornado `Comment not found`
- Resposta
```json
{
    "data": {
        "ID": 2556,
        "post_id": 10725,
        "comment_date": "2024-02-16 18:47:08",
        "content": "Muito bom <span style=\"caret-color: rgb(0, 0, 0); color: rgb(0, 0, 0); font-family: &quot;Open Sans&quot;, sans-serif; font-size: 16px; font-style: normal; font-variant-caps: normal; font-weight: 700;\"><span class=\"mention-area\"><span class=\"highlight\"><span data-item-id=\"1186\" class=\"mentiony-link\" contenteditable=\"false\">Eurico</span></span></span><span class=\"normal-text\"> </span></span>",
        "like": false,
        "is_my_comment": true,
        "user": {
            "ID": 1186,
            "avatar": "https://play.poletododia.com/wp-content/themes/play-pole/images/avatar-default.png",
            "user_email": "restritodk.ls@gmail.com",
            "display_name": "Eurico"
        }
    }
}
```

# Criar uma nova postagem
1. Para criar uma nova postagem o usuário precisa esta logado
- `userId` será obrigatório

2. Endepoint
```dart
  var endepoint = 'https://play.poletododia.com/wp-json/wp/v2/community-insert-post';
```

3. Será preciso enviar em `body` alguns parâmetros.
- `category` é a categoria do post
- `title` titulo do post
- `message` conteúdo do post, pode ser Texto ou Html
4. Se for compartilhar um arquivo como foto ou video esses parâmetros são precisos
- `tipoarchive` tipo do arquivo `foto` ou `video`
- `archivo` o arquivo

5. Criando um post
```dart
 URL = endpoint
 Type = 'POST'
 Headers = { 
    "userId": userId,
    "Content-Type": "application/json"
 }
 Body{
    "category": 16,
    "title":"Postagem test",
    "message": "Aqui descreva seu post.".
    "tipoarchive":"foto",
    "archive": //arquivo
 }
```

- Se houver error será retornado código `403` com a `message`
- Se sucesso será retornado código `200`

# Apagar uma postagem
1. Para apagar uma postagem o usuário precisa esta logado
- `userId` será obrigatório
- `rel_id` se refere ao post
- `rel_type` tipo da referencia `post`

2. Endepoint
```dart
  var endepoint = 'https://play.poletododia.com/wp-json/wp/v2/community-delete-post';
```

```dart
 URL = '$endpoint?rel_id=2012&rel_type=post'
 Type = 'DELETE'
 Headers = { 
    "userId": userId,
    "Content-Type": "application/json"
 } 
```

- Se houver error será retornado código `403` com a `message`
- Se sucesso será retornado código `200`

# Criar um novo comentario
1. Para criar umo novo comentário o usuário precisa esta logado
- `userId` será obrigatório 

2. Endepoint
```dart
  var endepoint = 'https://play.poletododia.com/wp-json/wp/v2/community-insert-comment';
```

3. Será preciso enviar em `body` alguns parâmetros.
- `author_id` author do comentário
- `post_id` ID do post a ser comentado
- `message` conteúdo do comentário, pode ser Texto ou Html

5. Criando um post
```dart
 URL = endpoint
 Type = 'POST'
 Headers = { 
    "userId": userId,
    "Content-Type": "application/json"
 }
 Body{
    "author_id": 163,
    "post_id":1929,
    "message": "Aqui descreva seu comentário.". 
 }
```

- Se houver error será retornado código `403` com a `message`
- Se sucesso será retornado código `200`

# Apagar um comentario
1. Para apagar um comentário o usuário precisa esta logado
- `userId` será obrigatório
- `comment` se refere ao comentário 

2. Endepoint
```dart
  var endepoint = 'https://play.poletododia.com/wp-json/wp/v2/community-delete-comment';
```

```dart
 URL = '$endpoint?comment=1992'
 Type = 'DELETE'
 Headers = { 
    "userId": userId,
    "Content-Type": "application/json"
 } 
```

- Se houver error será retornado código `403` com a `message`
- Se sucesso será retornado código `200`

# Curtir e desfazer uma curtida a uma postagem ou comentario
1. Para curtir o usuário precisa esta logado
- `userId` será obrigatório

2. Endepoint
```dart
  var endepoint = 'https://play.poletododia.com/wp-json/wp/v2/community-like-request';
```

3. Será preciso enviar em `body` alguns parâmetros.
- `author_id` author da curtida
- `post_id` ID do post ou comentário a ser curtido
- `type` tipos disponiveis `post` ou `comment`
- `event` tipos disponiveis `liked` e `unliked`
- `liked` é ação para curtir
- `unliked` é a ação para desfazer a curtida

4. Realizar um curtida em post
```dart
 URL = $endpoint
 Type = 'POST'
 Headers = { 
    "userId": userId,
    "Content-Type": "application/json"
 } 
 Body = {
    "author_id":1186,
    "post_id":10725,
    "type":"post",
    "event":"liked"
 }
```

4. Desfazer a curtida no post
```dart
 URL = $endpoint
 Type = 'POST'
 Headers = { 
    "userId": userId,
    "Content-Type": "application/json"
 } 
 Body = {
    "author_id":1186,
    "post_id":10725,
    "type":"post",
    "event":"unliked"
 }
```

4. Realizar um curtida em comentário
```dart
 URL = $endpoint
 Type = 'POST'
 Headers = { 
    "userId": userId,
    "Content-Type": "application/json"
 } 
 Body = {
    "author_id":1186,
    "post_id":1075,
    "type":"commen",
    "event":"liked"
 }
```

4. Desfazer a curtida no comentário
```dart
 URL = $endpoint
 Type = 'POST'
 Headers = { 
    "userId": userId,
    "Content-Type": "application/json"
 } 
 Body = {
    "author_id":1186,
    "post_id":1075,
    "type":"comment",
    "event":"unliked"
 }
```

- Se ocorrer erro será retornado `403` e a `message`
- Se ocorrer tudo certo será retornado `200`

# ----------App E conexão----------
# API e conexao com o App Flutter

## A API é responsável pelo conexão do sistema e aplicativo

1. Token de autenticacão com o servidor
- Código no app flutter com o `token`
```dart
static const String TOKEN_API = //O token esta na coluna `app_settings` na key `auth_server`;
```

2. Urls para acessar a api
```dart
static const String LOGIN_URI = '/api/login/auth'; // Realizar o login
static const String TOKEN_URI = '/api/customer/setting/cm-firebase-token'; // Atualizar o token do device no FirebaseMessage
static const String INITIALIZE_APP = '/api/customer/setting/initialize-app'; // Pegar informacoes sobre soft e app e verificiar login com o WordPress
static const String SETTING_CHANGE_URI = '/api/customer/setting/change-setting-user'; // Alterar as configuraçoes
```

# Realizar o login usando a API

1. Realizar a requisição
```
 URI = 'https://notification.nomemeusoft.com/api/login/auth';
 Type = 'POST'
 Headers = {
    "Authorization": "Bearer $TOKEN_API",
    "Content-Type": "application/json"
 }
 Body = {
   "email":"restritodk.ls@gmail.com",
   "password":"Manager030910"
 }
```

2. Possiveis respostas
- Se houver error
```
{
 "error":"Erro aqui"
}
```

- Se houver sucesso
```json
{
    "data": {
        "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3BsYXkucG9sZXRvZG9kaWEuY29tIiwiaWF0IjoxNzA3MzQ0MzY1LCJuYmYiOjE3MDczNDQzNjUsImV4cCI6MTcwNzk0OTE2NSwiZGF0YSI6eyJ1c2VyIjp7ImlkIjoiMTE4NiJ9fX0.CDTC4Q2DKo-ROjVW791w65WzWbWzKDkrVusEtbPwekw",
        "app_settings": {
            "topics_firebase": [
                "push_notification_topic",
                "new_classes_notification_topicnotification_community_topic",
                "payment_system_topic"
            ],
            "url_page_forgot_password": "https://play.nomemeusoft.com/wp-login.php?action=lostpassword&redirect_to=https%3A%2F%2Fplay.poletododia.com%2F",
            "url_page_create_account": "https://nomemeusoft.com/?utm_source=ESPERA_FEVEREIRO24_ORG_PLAY&utm_medium=ORG&utm_campaign=ESPERA_FEVEREIRO24&utm_content=PLAY",
            "categories": [
                {
                    "id": 13,
                    "name": "Correção de Movimento",
                    "count": 141
                },
                ...
            ]
        },
        "user_settings": {
            "calendar_trigger": {
                "value": "an_hour",
                "trigger": null
            },
            "is_receiver_notification_community": {
                "value": true,
                "trigger": "notification_community_topic"
            },
            "is_receiver_notification_new_comment": {
                "value": true,
                "trigger": null
            },
            "is_receiver_notification_recent_classes": {
                "value": true,
                "trigger": "new_classes_notification_topic"
            },
            "is_receiver_notification_training_calendar": {
                "value": true,
                "trigger": null
            }
        },
        "user": {
            "name": "Eurico",
            "email": "restritodk.ls@gmail.com"
        }
    }
}
```
O token recebido precisar ser armazenado para realizar as demais requisições.

# Inicializar app com autenticacao

## Obs: Sempre que o app for iniciado ele precisa verificar se o login com o WordPress esta valido e pegar as atuais configurações do app e usuário se estiver logado.

1. Realizar a requisição
```
 String $tokenUser = //local onde foi armazenado
 //Se não tiver um token, tipo ainda n tiver realizado o login o token sera enviado como nulo.
 
 URI = 'https://notification.nomemeusoft.com/api/customer/setting/initialize-app';
 Type = 'GET'
 Headers = {
    "Authorization": "Bearer $TOKEN_API",
    "Content-Type": "application/json",
    "token": $tokenUser
 }
```
2. Resposta do servidor
- Se não estiver logado com o WordPress

```json
{
    "data": {
        "is_logged": false,
        "app_settings": {
            "topics_firebase": [
                "push_notification_topic",
                "new_classes_notification_topicnotification_community_topic",
                "payment_system_topic"
            ],
            "url_page_forgot_password": "https://play.poletododia.com/wp-login.php?action=lostpassword&redirect_to=https%3A%2F%2Fplay.poletododia.com%2F",
            "url_page_create_account": "https://poletododia.com/?utm_source=ESPERA_FEVEREIRO24_ORG_PLAY&utm_medium=ORG&utm_campaign=ESPERA_FEVEREIRO24&utm_content=PLAY",
            "categories": [
                {
                    "id": 13,
                    "name": "Correção de Movimento",
                    "count": 141
                },
                ...
            ]
        },
        "user_settings": []
    }
}
```

- Se estiver logado com o WordPress

```json
{
    "data": {
        "is_logged": true,
        "app_settings": {
            "topics_firebase": [
                "push_notification_topic",
                "new_classes_notification_topicnotification_community_topic",
                "payment_system_topic"
            ],
            "url_page_forgot_password": "https://play.poletododia.com/wp-login.php?action=lostpassword&redirect_to=https%3A%2F%2Fplay.poletododia.com%2F",
            "url_page_create_account": "https://poletododia.com/?utm_source=ESPERA_FEVEREIRO24_ORG_PLAY&utm_medium=ORG&utm_campaign=ESPERA_FEVEREIRO24&utm_content=PLAY",
            "categories": [
                {
                    "id": 13,
                    "name": "Correção de Movimento",
                    "count": 141
                },
                ...
            ]
        },
        "user_settings": {
            "calendar_trigger": {
                "value": "an_hour",
                "trigger": null
            },
            "is_receiver_notification_community": {
                "value": true,
                "trigger": "notification_community_topic"
            },
            "is_receiver_notification_new_comment": {
                "value": true,
                "trigger": null
            },
            "is_receiver_notification_recent_classes": {
                "value": true,
                "trigger": "new_classes_notification_topic"
            },
            "is_receiver_notification_training_calendar": {
                "value": true,
                "trigger": null
            }
        }
    }
}
```
Se o usuario nao tiver logado redirecione a tela de login

## Envio do Token do dispositivo para receber notificações individuais


1. Realizar a requisição
```
 String $tokenUser = //local onde foi armazenado
 //Se não tiver um token, tipo ainda n tiver realizado o login o token sera enviado como nulo.
 
 URI = 'https://notification.nomemeusoft.com/api/customer/setting/cm-firebase-token';
 Type = 'PUT'
 body = {
   "cm_firebase_token": //Token
 }
 Headers = {
    "Authorization": "Bearer $TOKEN_API",
    "Content-Type": "application/json",
    "token": $tokenUser
 }
```

2. A resposta vai ser `Token saved`

## Alterar configurações do usuario

1. Realizar a requisição
```
 String $tokenUser = //local onde foi armazenado
 //Se não tiver um token, tipo ainda n tiver realizado o login o token sera enviado como nulo.
 
 var key = //A chame do nome da função pega pelo salva na requição anterior ao iniciar o app ou login
 var value = //Valor a ser salvo
 
 String payload = base64Encode(utf8.encode(jsonEncode({
      'key': key,
      'value': value
 })))
 
 URI = 'https://notification.nomemeusoft.com/api/customer/setting/change-setting-user/$payload';
 Type = 'GET'
 Headers = {
    "Authorization": "Bearer $TOKEN_API",
    "Content-Type": "application/json",
    "token": $tokenUser
 }
```

2. Se o codigo da resposta for 200 a configuraçoes foram salvas

3. Se houver error
4.
```
{
 "error":"Erro aqui"
}
```


# Documentação e Instalação do Dashboard e Aplicativo Flutter

## Introdução

Este documento fornece orientações sobre a instalação do aplicativo Flutter, bem como detalhes sobre a implementação das notificações. O objetivo é auxiliar desenvolvedores na configuração e utilização das funcionalidades no contexto de notificações.

## App Flutter - Pacotes Utilizados

Certifique-se de incluir os seguintes pacotes no arquivo pubspec.yaml do seu projeto Flutter:
```yaml
firebase_core: ^<versão>
firebase_messaging: ^<versão>
flutter_local_notifications: ^<versão>
http: ^<versão>
shared_preferences: ^<versão>
get: ^<versão>
loading_animation_widget: ^<versão>
path_provider: ^<versão>
connectivity: ^<versão>
url_launcher: ^<versão>
sqflite: ^<versão>
```

## Implementação das Notificações

### Salvar Notificações em Banco de Dados Local

Para armazenar notificações localmente, utilizamos a biblioteca sqflite. Siga os passos abaixo:

1. Para armazenar as notificações recebidas em *background (Segundo plano)* vamos criar funções dentro do módulo firebase_messaging.

2. Crie uma pasta chamada sqlite na raiz do projeto firebase_messaging.

3. Dentro da pasta sqlite, crie um arquivo chamado NotificationModel.java com o seguinte conteúdo:

```Java
package io.flutter.plugins.firebase.messaging.sqlite;

public class NotificationModel {
    String notificationID, title, body, image, link, itemID;
    int id;
    boolean read;
    NotificationType notificationType;

    public boolean getRead() {
        return read;
    }

    public void setRead(boolean read) {
        this.read = read;
    }

    public String getNotificationID() {
        return notificationID;
    }

    public void setNotificationID(String notificationID) {
        this.notificationID = notificationID;
    }
    
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getLink() {
        return link;
    }

    public void setLink(String link) {
        this.link = link;
    }

    public String getItemID() {
        return itemID;
    }

    public void setItemID(String itemID) {
        this.itemID = itemID;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public NotificationType getNotificationType() {
        return notificationType;
    }

    public void setNotificationType(NotificationType notificationType) {
        this.notificationType = notificationType;
    }

    public String getString() {
        return "notificationID: "+notificationID + ", title: "+title+", body: "+body+", image: "+image+", link: "+link+", itemID: "+itemID+", notificationType: "+notificationType.name();
    }
}
```

4. Crie um arquivo chamado NotificationType.java com o seguinte conteúdo:

```Java
package io.flutter.plugins.firebase.messaging.sqlite;

public enum NotificationType {
    calendar, comments, class_post, push_custom, payment, unknown
}
```

5. Crie outro arquivo chamado NotificationDB.java para gerenciar o banco de dados:

```Java
package io.flutter.plugins.firebase.messaging.sqlite;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

public class NotificationDB extends SQLiteOpenHelper {

    private static final String _id = "id";
    private static final String _table = "notifications";
    private static final String _notificationID = "notification_id";
    private static final String _title = "title";
    private static final String _body = "body";
    private static final String _image = "image";
    private static final String _link = "link";
    private static final String _itemID = "item_id";
    private static final String _read = "read";
    private static final String _notificationType = "notification_type";
    private static final String _createdAt = "created_at";

    private final String[] dataValues = new String[]{_id, _notificationID, _title, _body, _image, _link, _itemID, _notificationType, _createdAt};
    private Context context;

    public NotificationDB(Context mContext){
        super(mContext, "NotificationsApp.db", null, 3);
        this.context = mContext;
    }


    public void addNotification(NotificationModel notificationModel){
        try{
            SQLiteDatabase sqLiteDatabase = getReadableDatabase();
            System.out.println("sqLiteDatabase "+sqLiteDatabase.getPath());
            String[] selectionArgs = {notificationModel.notificationID};
            String selection = _notificationID + "=?";
            try (Cursor cursor = sqLiteDatabase.query(_table, null, selection, selectionArgs, null, null, null)) {

                if (cursor.getCount() == 0) {
                    ContentValues values = new ContentValues();
                    values.put(_notificationID, notificationModel.notificationID);
                    values.put(_title, notificationModel.title);
                    values.put(_body, notificationModel.body);
                    values.put(_link, notificationModel.link);
                    values.put(_image, notificationModel.image);
                    values.put(_itemID, notificationModel.itemID);
                    values.put(_read, notificationModel.read ? "true" : "false");
                    values.put(_notificationType, notificationModel.notificationType.name());
                    Date currentDate = new Date();

                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS");
                    String formattedDate = dateFormat.format(currentDate);
                    values.put(_createdAt, formattedDate);


                    sqLiteDatabase.insert(_table, null, values);
                }
            }
            sqLiteDatabase.close();
        }catch (Exception exception){
            System.out.println("Error ao salvar notificacao: "+exception.getMessage());
        }
    }

    @Override
    public void onCreate(SQLiteDatabase sqLiteDatabase) {
        sqLiteDatabase.execSQL("CREATE TABLE " +_table+ "(" + _id + " INTEGER PRIMARY KEY AUTOINCREMENT, " +_notificationID+" TEXT, "+_title+" TEXT, "+_body+" TEXT, "+_image+" TEXT, "+_link+" TEXT, "+_itemID+" TEXT, "+_notificationType+" TEXT, "+_read+" TEXT, "+_createdAt+" TEXT)");
    }

    @Override
    public void onUpgrade(SQLiteDatabase sqLiteDatabase, int i, int i1) {
        if(i == 2 && i1 == 3){
            sqLiteDatabase.execSQL("ALTER TABLE " + _table + " ADD COLUMN " + _notificationID + " TEXT;");
        }
    }

}
```

6. Adicione a seguinte dependência Gson no arquivo build.gradle do módulo firebase_messaging:

```gradle
dependencies {
implementation 'com.google.code.gson:gson:2.8.9'
... (outras dependências)
}
```

### Integração no Arquivo FlutterFirebaseMessagingReceiver.java

Modifique o arquivo FlutterFirebaseMessagingReceiver.java dentro do módulo firebase_messaging. Adicione as seguintes linhas:

```Java
... (código existente)
RemoteMessage remoteMessage = new RemoteMessage(intent.getExtras());
dbManager = new NotificationDB(context);

// Adicione a função jsonStringToMap
public static Map<String, String> jsonStringToMap(String jsonString) {
Gson gson = new Gson();
Type type = com.google.gson.internal.$Gson$Types.newParameterizedTypeWithOwner(null, Map.class, String.class, String.class);
return gson.fromJson(jsonString, type);
}

// Adicione o código de implementação de notificações
NotificationModel notificationModel = new NotificationModel();
notificationModel.setTitle(Objects.requireNonNull(remoteMessage.getNotification()).getTitle());
notificationModel.setBody(remoteMessage.getNotification().getBody());
Uri imageUri = remoteMessage.getNotification().getImageUrl();
notificationModel.setImage(imageUri == null ? "" : String.valueOf(imageUri));

Map<String, String> data = remoteMessage.getData();
String payloadJson = data.get("payload");


  if (payloadJson != null) {
      Map<String, String> payload = jsonStringToMap(payloadJson);

      String _notificationID = "";
      String link = "";
      String itemID = "";
      NotificationType notificationType = NotificationType.unknown;

      if (payload.containsKey("notification_id")) {
        _notificationID = payload.get("notification_id");
      }
      if (payload.containsKey("link")) {
        link = payload.get("link");
      }
      if (payload.containsKey("id")) {
        itemID = payload.get("id");
      }
      if (payload.containsKey("notification_type")) {
        notificationType = NotificationType.valueOf(payload.get("notification_type"));
      }

      notificationModel.setNotificationID(_notificationID);
      notificationModel.setLink(link);
      notificationModel.setItemID(itemID);
      notificationModel.setNotificationType(notificationType);
      notificationModel.setRead(false);

      dbManager.addNotification(notificationModel);

    }

... (código existente)
```

**Nota:** Certifique-se de realizar os passos com atenção e adapte conforme necessário. Essas instruções assumem uma estrutura básica do projeto e podem precisar de ajustes dependendo da organização específica do seu código.
