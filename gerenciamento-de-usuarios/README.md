# Gerenciamento de usuários

## Conexão entre cliente e BD

- Conexão do cliente com o banco através de um protocolo de rede, **por default a conexão não é encriptada**
- O BD verifica se a conexão é possível através de um mini firewall
- O usuário é logado no sistema (com um login e senha)

Em PostgreSQL usa *Roles* para gerenciar os acessos ao banco de dados. Essas Roles podem atuar como *usuários*, um *grupo de usuário* ou ambos.

Criar uma Role
```sql
CREATE ROLE <nome> { { WITH } <option> { ... } };
```

Deleter uma Role
```sql
DROP ROLE <nome>;
```

Consultar Roles
```sql
SELECT * FROM pg_roles;
```

Criar um usuário
```sql
CREATE USER <nome>;
```

Deleter usuário
```sql
DROP USER <nome>;
```

> Quando instaldo, é criado a role postgres que é adm do banco

## Privilégios

### Login

Privilégio mais básico, permite o usuário logar no BD.

```sql
CREATE ROLE <nome> WITH LOGIN;
```

### Superuser

Cria um novo adm no BD, porém sem a permissão de login, é preciso informar a role de Login junto.

```sql
CREATE ROLE <nome> WITH SUPERUSER;
```

### Criar bando de dados

```sql
CREATE ROLE <nome> WITH CREATEDB;
```

### Criar role

```sql
CREATE ROLE <nome> WITH CREATEROLE;
```

### Replicação por stream

```sql
CREATE ROLE <nome> WITH REPLICATION;
```

### Definir senha de autenticação

```sql
CREATE ROLE <nome> WITH PASSWORD 'senha';
CREATE ROLE <nome> WITH PASSWORD 'senha' VALID UNTIL '2005-01-01'; -- Cria uma senha por tempo determinado
```

## Atribuir permissões a usuários

Quando um objeto (tabela, trigger, função, sequence, index, etc.) é criado, ele pertence ao papel de quem criou, ou seja, o usuário que executou `CREATE`

```sql
GRANT UPDATE ON <nome_objeto> TO <nome_usuario>; -- Garante permissão de UPDATE para usuário no objeto
GRANT ALL ON <nome_objeto> TO <nome_usuario>; -- Garante todas as permissões para o usuário no objeto
```

Para garantir acesso a todos os usuários
```sql
GRANT <permissao> ON <nome_objeto> TO PUBLIC;
```

Ex:
```sql
GRANT SELECT ON tabela1 TO PUBLIC;
GRANT SELECT, UPDATE, DELETE ON tabela2 TO zeca;
GRANT SELECT (col1), UPDATE (col2) ON tabela3 TO juca;
```

## Repassar privilégios para outros usuários

```sql
GRANT <role> TO <destinatario>;
```

## Rules

Regras / Ações associadas a operadores.

```sql
CREATE { OR REPLACE } RULE <nome_da_rule> AS
ON <nome_do_evento> TO <nome_tabela> { WHERE <condicao> }
DO { ALSO | INSTEAD } NOTHING | <comando>
```

> Eventos: SELECT, INSERT, UPDATE ou DELETE

Ex:
```sql
CREATE RULE "_RETURN" AS
ON SELECT TO tabela1
DO INSTEAD SELECT * FROM tabela1;
```

> Com INSTEAD, a ação é executada no lugar da operação

Ex:
```sql
CREATE RULE "replica" AS
ON INSERT TO tabela1
DO ALSO INSERT INTO tabela2 VALUES(...);
```

> Com ALSO, a ação é executada após a operação

Ex:
```sql
CREATE RULE "nome" AS
ON INSERT TO tabela1
DO INSTEAD NOTHING;
```

> Com NOTHING, nada irá acontecer após a execução do evento. É usado para proteger essas relações temporariamente em caso de manutenção, correção de erros, etc.

## Schemas

É um *namespace*, é uma pasta para colocar tabelas dentro. **O nome de um Schema deve ser diferente de todos que existem na base de dados**.

```sql
CREATE SCHEMA IF NOT EXISTS <nome_schema> AUTHORIZATION <nome_usuario>;
```

Com um schema criado, é possível criar tabelas referenciando o schema.
```sql
CREATE TABLE <nome_schema>.<nome_tabela> (...);
```

## Sequence

Gera valores sequenciais definidos. O `SERIAL` é criado usando um `SEQUENCE`.
```sql
CREATE SEQUENCE <id_sequencia>
START 1
INCREMENT 1
NO MAXVALUE
CACHE 1;
```

> CACHE: quantos valores pre definidos ele irá criar

EX: Para usar uma sequence em um evento
```sql
INSERT INTO tabela1 VALUES (nextval('id_sequencia'), ...);
```