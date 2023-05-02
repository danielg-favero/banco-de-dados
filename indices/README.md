# Índices

São estruturas que organizam os dados (em geral em disco) para agilizar a recuperação dos dados.

Índices são criados quando:
- Automaticamente quando se declara conjuntos de atributos como chaves `PRIMARY KEY` ou `UNIQUE`
- Explicitamente quando executado o comando `CREATE/ALTER/DROP INDEX`.

```sql
CREATE { UNIQUE } INDEX <nome_index> ON <nome_tabela> { USING <metodo> }
    (
        { <atributos> | ( <expressao> ) }
            { ASC | DESC }
            { NULLS { FIRST | LAST } }
    )
{ WITH (storage_parameter = valor { ,... }) }
{ TABLESPACE <nome_tablespace> }
{ WHERE <predicado> }
```

Em PostgreSQL `<metodo>` pode ser:
- BTREE (múltiplos atributos, UNIQUE, ordem, etc.)
- HASH (atributos de texto)
- GIST (banco de dados geográficos)
- GIN (Generalized Invert Files)

Ex1:

```sql
CREATE INDEX IdxMedia ON Matricula ((NotaP1 + NotaP2) / 2);
```

> A consulta da média já fica calculada automaticamente, caso esse consulta seja requisitada diversas vezes

Ex2:

```sql
CREATE INDEX IdxUpNome ON Professor (Upper(Nome));
```

> É útil quando usado em expressões como: `WHERE Upper(Professor.Nome) = "José";`

Ex3:
```sql
CREATE INDEX IdxNivel ON Professor USING HASH (nivel);
```

## Indexação de chaves estrangeiras

Por padrão: Chaves estrangeiras **não são indexadas**

## Indexação em campos de texto

Não é recomendável utilizar indexação **B-tree**, o correto é habilitar uma indexação própria para texto. Para isso é preciso executar o comando:

```sql
CREATE EXTENSION pg_trgm;
```

E em seguida especificar o algoritmo de indexação

```sql
CREATE INDEX nome_index ON nome_tabela USING gin (nome_do_campo gin_trgm_ops);
```

> GIN é uma biblioteca de indexação que possui vários índices para vários casos especiais, nesse caso para textos é usado o GIN_TRGM_OPS

## Indexação Bitmap

Recomendado quando os campos da tabela são categorias que não passam de 5 tipos. Ex: Gênero (Masc. / Fem.), são apenas 2 tipos. Para habilitar a indexação bitmap, é preciso executar o comando:

```sql
CREATE EXTENSION btree_gin;
```

```sql 
CREATE INDEX nome_index ON nome_tabela USING gin (nome_campo);
```

> De 8 até 100 tipos, é recomendado usar HASH

## Indexação em JSON

Existem duas maneiras de indexar JSON:
- Indexar um campo específico em um B-tree
```sql
CREATE INDEX nome_index ON nome_tabela USING BTREE ((nome_coluna->>'nome_campo_do_jsons'));
```

- Indexar um campo genérico
```sql
CREATE INDEX nome_index ON nome_tabela USING GIN (nome_coluna);
```

> O tipo `jsonb` em Postgres é o único indexável