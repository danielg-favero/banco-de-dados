--drop table cliente cascade
create table cliente (
	id serial primary key, 
	nome varchar, 
	renda numeric
);
--delete from cliente;

insert into cliente (id,nome,renda) values (1, 'Cliente1', 3000);

table cliente

--read committed: É definido como padrão caso não informado, apenas lê valores que foram commitados
begin;
set transaction isolation level read committed;
select * from cliente;
insert into cliente values (2,'Cliente2',2000);
select * from cliente;
commit;

--repeatable read: Durante a execução da transação, o estado dela se mantém o mesmo, qualquer alteração fora da transação não é refletida nela
begin;
set transaction isolation level repeatable read;
select * from cliente where nome = 'Cliente1';
select * from cliente where nome = 'Cliente1';
commit;

select * from cliente;

--serializable - Bloqueio: executa a transação de forma serial
begin;
set transaction isolation level serializable;
update cliente set renda = renda + 500 where id = 1;
commit;

--read committed -- Suspensao
begin;
set transaction isolation level read committed;
update cliente set renda = renda + 500 where id = 1;
abort;

select * from cliente where nome = 'Cliente1';

--read committed -- Deadlock
begin;
set transaction isolation level read committed;
update cliente set renda = renda * 2 where id = 1;
update cliente set renda = renda * 2 where id = 2;
commit;
rollback;