create table cliente (
	idCliente serial primary key,
	nome varchar, 
    datanasc date
);
	
create table carro(
	id serial primary key,
	ano integer,
    modelo varchar,
	idCliente integer references cliente(idCliente)
);

-- Popular Tabela cliente
do $$
begin
    for i in 1..100000 loop
        insert into cliente (nome,datanasc) values (texto(6), data());
    end loop;
end
$$ language plpgsql

-- Popular Tabela carro
do $$
begin
    for i in 1..100000 loop
        insert into carro (ano,modelo,idCliente) values ((random()*100)::integer, texto(6), i);
    end loop;
end
$$ language plpgsql

-- Após a inserção de dados é importante atualizar as métricas das tabelas
analyze cliente;
analyze carro;

-- Analisar o desempenho da consulta
EXPLAIN ANALYZE
SELECT NOME, MODELO
FROM CLIENTE NATURAL JOIN CARRO
WHERE IDCLIENTE=30

-- Criar um índice na chave estrangeira
create index idxCliCarro on carro(idCliente);
drop index idxCliCarro



