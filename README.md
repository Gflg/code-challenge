# Instruções para executar o projeto

Esse projeto utilizou Ruby na versão 3.0.3 e Rails na versão 7.0.4.1. O banco de dados escolhido foi o SQLite.
Com o Ruby e Rails em versões válidas, podemos executar o projeto. Para isso, basta executar os seguintes comandos:

Para instalar as dependências: 
```bundle install```

Para executar as migrações: 
```rake db:migrate```

Para executar o servidor em Rails: 
```rails s```

# Envio de e-mails
Para que o envio de e-mails funcione corretamente, é necessário configurar as variáveis dentro de config\app_environment_variables.rb.

Foram utilizadas as seguintes configurações para os testes desse projeto:

```
ENV['HOST'] = 'localhost:3000'
ENV['GMAIL_USERNAME'] = 'code.challenge.gustavo@gmail.com'
ENV['GMAIL_PASSWORD'] = 'hzlclxhmgerdurpx'
```

Fique à vontade para utilizar as configurações acima ou quaisquer outras.

# Passo a passo do desenvolvimento desse projeto

O projeto foi priorizado da seguinte forma, com o desenvolvimento seguindo a priorização:

1. Criação do modelo, views e controller para as invoices. Esse foi o primeiro passo do projeto pois acredito que o CRUD de invoices solicitado no desafio contenha as principais funcionalidades e é um módulo mais apartado do registro e login de novos usuários.

2. Incrementos ao modelo de Invoices para o acréscimo de e-mails. Com um CRUD básico criado para as invoices, criei um vínculo entre o modelo de Invoices com um modelo de Email criado para guardar vários e-mails em uma única invoice. Para poder estruturar essa ligação entre os modelos, foi utilizado a biblioteca cocoon.

3. Criação de PDFs de uma invoice. Aqui, poderia ter seguido também com a criação de e-mails mas, priorizei a geração de PDFs por entender que era uma tarefa menos complexa no momento. Para que a geração funcionasse, a biblioteca prawn foi utilizada.

4. Criação e envio de e-mails de invoices. Após completar o passo anterior, priorizei essa etapa para dar mais um passo na conclusão das funcionalidades desse módulo. Foram criados um mailer e views que contêm o que um e-mail deverá ter escrito em seu título e corpo.

5. Criação de filtros na listagem de invoices. Como último passo para concluir o módulo de invoices, adicionei filtros de número da invoice (tratado como id) e data (com datas de início e fim para configurar um intervalo de tempo a ser filtrado). Aqui, optei por fazer um filtro buscando diretamente no back-end em Rails. Entendo que seria mais adequado um filtro feito no front-end mas, no momento, entendi que era mais rápido e natural fazer esse filtro no back-end.

6. Geração de token para o usuário e ativação desse token. Aqui, foram criados modelo User junto com suas views e controller, um endpoint para ativação do token e tudo o que era necessário para o envio de e-mails relacionados ao usuário. Para o registro e geração de token, utilizei o endpoint padrão de criação de usuários. Após esse formulário ser enviado, um e-mail é enviado para o e-mail do form, contendo um link para confirmar um token criado para o usuário do form. Ao receber o e-mail e clicar no link, o token é confirmado e o usuário passa a ser ativo. Para o caso de usuários já ativos, o novo token só passaria a ser válido após o envio de um novo e-mail e o acesso do link enviado por lá.

7. Criação de autenticação para o usuário. Para que a autenticação fosse feita com sucesso, foram criados modelo, uma view e controller para Session. Session será responsável por buscar o token fornecido pelo usuário e, caso o encontre, fazer o login dele. Além disso, foi necessário criar outras classes auxiliares, como uma concern de Authentication, que disponiliza funções para o login/logout de usuários.

8. Refatorações de código e criação/ajuste de testes. Uma vez que as funcionalidades foram concluídas, adotei um processo de refatoração do código para deixá-lo melhor organizado junto com o ajuste e criação de testes. Para o código, a intenção foi remover códigos que continham "regras de negócio" e extrair essas "regras" para serviços, onde cada serviço seria responsável por fazer uma ação em específico. Para os testes, foram criados testes de integração para verificar se os endpoints possuem o comportamento esperado em alguns cenários e, além disso, testes unitários para criar cada um desses serviços criados.
