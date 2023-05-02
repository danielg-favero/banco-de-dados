# MER Avançado

Existem diversas alternativas de modelagem, por exemplo:
- Modelos de modelagem geográficos
- Modelos de modelagem de oncologias
- Modelos que extendem o modelo padrão

É preciso ter cuidado para utilizar modelos extendidos do MER pois requerem conhecimento adicional sobre sobre o empreendimento que não é modelado no DE-R e que seu mapeamento não pode ser automatizado.

## Atributo composto

Tem diversas partes, que podem ser todas do mesmo tipo ou diversos tipos. Ex:
- Endereço

Em um DE-R, nem sempre é indicado os atrbutos que compoem a estrutura do atributo composto

```
ALUNO
┗ RA
┗ Nome
┗ Idade
┗ Endereço - {Rua, Número, CEP, Cidade}

// Os atributos de endereço ficam implicitos dentro do diagrama
```

> Atributos compostos podem SIM ser CHAVE PRIMÁRIA

## Atributo multivalorado

Tem possibilidade de ter diversos valores (de zero a qualquer quantidade), todos do mesmo tipo. Ex:
- Telefones
- Alergias

> Não existe simbologia universal para representar atribuitos multivalorados

> Atributos multivalorados NÃO podem ser CHAVE PRIMÁRIA, pois geralmente será criado uma tabela a parte para lidar com o relacionamento com o banco

### Mapeamento de atributos multivalorados
Existem duas maneiras de mapear atributos multivalorados:
- Criar uma tabela a parte que relaciona a chave primaria da entidade principal com os valores do atribuito em outra tabela
- Quando a quantidade de valores for muito pequena, é possível separar em diversos atributos separados (Atributo1, Atributo2, Atributo3...).

Isso serve não apenas para entidades, mas também para **relacionamentos**

## Cardinalidade

Determinaquantas vezes (no máximo) uma entidade pode ocorrer em uma relação.

## Multiplicidade

Foi criado para controlar a quantidade mínima e máxima entre entidade de um relacionamento. Ex:
- (0, 1)
- (0, 3)
- (0 , N)
- (1, 1)
- (1, N)
- (1, 3)
- (3, 6)

Para programar isso, é preciso implementar uma **trigger** para validar a inserção.

É possível atribuir a multiplicidade em atributos das entidades:
```
ALUNO
┗ RA (1: 1)
┗ Nome (0: 1)
┗ Idade (0: 1)
┗ Telefone (1: 2)
┗ Endereço (1, N)

// Quando a cardinalidade mínima é 1, isso significa que no CREATE TABLE ele é NOT NULL
```

> O método de mapear esses dados é importante para evitar uma grande grande NULLS nas tabelas, pois isso poderá causar problemas no processamento nos JOINS que serão feitos.