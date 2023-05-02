create table teste(
    nome varchar
);

-- Popular tabela com 100000 dados
do $$
begin
    for i in 1..100000 loop
        insert into teste values (texto(10));
    end loop;
end; $$
language plpgsql;

-- Atualizar as métricas da tabela
analyze teste;

create index idxtext on teste(nome);

explain analyze
select * from teste where nome LIKE 'eQi%';

explain analyze
select * from teste where nome LIKE '%eQi%';

-- Habilitar outros tipos de indexação
CREATE EXTENSION pg_trgm;

-- Criar índice com indexação por texto
create index idxtextTrgm on teste using GIN(nome gin_trgm_ops);


