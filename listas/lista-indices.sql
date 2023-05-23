-- Nome: Daniel Gustavo Favero
-- RA: 2157128

drop table Aluno;
drop table Discip;
drop table Matricula;

delete from Aluno;
delete from Discip;
delete from Matricula;

CREATE TABLE Aluno(
	Nome VARCHAR(50) NOT null,
	RA DECIMAL(8) NOT null primary key,
	DataNasc DATE NOT NULL,
	Idade DECIMAL(3),
	NomeMae VARCHAR(50) NOT NULL,
	Cidade VARCHAR(30),
	Estado CHAR(2),
	Curso VARCHAR(50),
	periodo integer,
);

CREATE TABLE Discip(
	Sigla CHAR(7) NOT null primary key,
	Nome VARCHAR(25) NOT NULL,
	SiglaPreReq CHAR(7),
	NNCred DECIMAL(2) NOT NULL,
	Monitor DECIMAL(8) references Aluno(RA),
	Depto CHAR(8)
);

CREATE TABLE Matricula(
	RA DECIMAL(8) NOT null references Aluno(RA),
	Sigla CHAR(7) NOT null references Discip(Sigla),
	Ano CHAR(4) NOT NULL,
	Semestre CHAR(1) NOT NULL,
	CodTurma DECIMAL(4) NOT NULL,
	NotaP1 NUMERIC(3,1),
	NotaP2 NUMERIC(3,1),
	NotaTrab NUMERIC(3,1),
	NotaFIM NUMERIC(3,1),
	Frequencia DECIMAL(3),
	primary key(RA, Sigla, Ano, Semestre)
);

-- Número aleatorio
create or replace function numero(digitos integer) returns integer as
$$
begin
	return trunc(random()*power(10,  digitos));
end;
$$ language plpgsql;

-- Data aleatoria
create or replace function data() returns date as
$$
begin
	return date(timestamp '1980-01-01 00:00:00' +
			random() * (timestamp '2017-01-30 00:00:00' -
			timestamp '1990-01-01 00:00:00'));
end;
$$ language plpgsql;

-- Texto aleatorio
Create or replace function texto(tamanho integer) returns text as
$$
declare
	chars text[] := '{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
	result text := '';
	i integer := 0;
begin
	if tamanho < 0 then
		raise exception 'Tamanho dado nao pode ser menor que zero';
	end if;

	for i in 1..tamanho loop
		result := result || chars[1+random()*(array_length(chars, 1)-1)];
	end loop;

	return result;
end;
$$ language plpgsql;

-- Exerício 1) Crie as constraints que julgar necessário após as tabelas forem criadas. Popule as tabelas
-- com várias tuplas, de preferência acima de mil tuplas, até que os  ́ındices sejam usados em suas
-- consultas. Não se esqueça de atualizar as métricas das tabelas após a inserção (analyze).

SET datestyle TO "YMD";

do $$
begin
	for i in 1..2000 loop
		insert into Aluno(Nome, RA, DataNasc, Idade, NomeMae, Cidade, Estado, Curso, periodo) values (texto(30), i, data(), numero(2), texto(30), texto(10), texto(2), texto(30), numero(1));
	end loop;
end;
$$ language plpgsql;

do $$
begin
	for i in 1..2000 loop
		insert into Discip(Sigla, Nome, SiglaPreReq, NNCred, Monitor, Depto) values (texto(7), texto(20), texto(7), numero(2), numero(2) + 1, texto(8));
	end loop;
end;
$$ language plpgsql;

do $$
declare
	sgl text = '';
	result text = '';
begin
	for i in 1..2000 loop
		for j in 1..8 loop
			sgl = texto(7);
			
			-- Verificar se a tupla está presente na tabela
			select sigla
			into result
			from Discip
			WHERE sgl like sigla;
			
			if found then
				insert into Matricula(RA, Sigla, Ano, Semestre, CodTurma, NotaP1, NotaP2, NotaTrab, NotaFIM, Frequencia) values (i, texto(20), '2023', '1', numero(2), 0, 0, 0, 0, numero(2));
			end if;	
		end loop;
	end loop;
end;
$$ language plpgsql;

-- Exercício 2) Suponha que o seguinte ́ındice foi criado para a relação Aluno.

CREATE UNIQUE INDEX IdxAlunoNNI ON Aluno (Nome, NomeMae, Idade);
drop index IdxAlunoNNI;
analyze Aluno;

-- a. Escreva uma consulta que utilize esse  ́ındice.

explain analyze select Nome, NomeMae, Idade from Aluno where nome = 'xihbdkysqkornxneobidofnhbulmsi';

-- b. Mostre um exemplo onde o ́ındice não ́e usado mesmo utilizando algum campo indexado na cláusula where, e explique por quê.

explain analyze select Nome, NomeMae, Idade from Aluno where upper(nome) = 'xihbdkysqkornxneobidofnhbulmsi';

-- Exercício 3) Crie ́Índices e mostre exemplos de consultas (resultados e explain) que usam os seguintes tipos de acessos:
-- a) Sequential Scan

CREATE INDEX IdxAlunoNNI ON Aluno (Nome, NomeMae, Idade);
explain analyze select Nome, NomeMae, Idade from Aluno;

-- b) Bitmap Index Scan

CREATE EXTENSION btree_gin;
CREATE INDEX IdxDiscipNNCred ON Discip USING gin (NNCred);
explain analyze select NNCred from Discip where NNCred = 3;

-- c) Index Scan

explain analyze select Nome, NomeMae, Idade, RA from Aluno where nome = 'xihbdkysqkornxneobidofnhbulmsi';

-- d) Index-Only Scan

explain analyze select Nome, NomeMae, Idade from Aluno where nome = 'xihbdkysqkornxneobidofnhbulmsi';

-- e) Multi-Index Scan

create index IdxDiscipSigla on Discip (Sigla);
explain analyze select A.Nome, A.NomeMae, A.Idade, A.RA, D.Sigla from Aluno as A, Discip as D where A.Nome = 'xihbdkysqkornxneobidofnhbulmsi' and D.Sigla = 'ljywpzo';

-- Exercício 4) Faça consultas com junções entre as tabelas e mostre o desempenho criando-se índices para cada chave estrangeira.

create index IdxAlunoDiscpMonitor on discip (monitor);

explain analyze select aluno.ra, discip.sigla 
from aluno, discip
where aluno.ra = discip.monitor;

-- Exercício 5) Utilize um  ́ındice bitmap para período e mostre-o em uso nas consultas.
drop index IdxAlunoPeriodo;
explain analyze select periodo from Aluno where periodo > 5; -- sem index

CREATE INDEX IdxAlunoPeriodo ON Aluno (periodo);

explain analyze select periodo from Aluno where periodo > 5; -- com index

-- Exercício 6) Compare na prática o custo de executar uma consulta com e sem um  ́ındice clusterizado 
-- na tabela aluno. Ou seja, faça uma consulta sobre algum dado indexado, clusterize a tabela naquele
-- ındice e refaça a consulta. Mostre os comandos e os resultados do explain analyze.

analyze Aluno;

drop index IdxAlunoEstado;
explain analyze select estado from Aluno where estado = 'gk'; -- sem index

CREATE INDEX IdxAlunoEstado ON Aluno (estado);
explain analyze select estado from Aluno where estado = 'gk'; -- com index

cluster Aluno using IdxAlunoEstado;
explain analyze select estado from Aluno where estado = 'gk'; -- com index clusterizado

-- Exercício 7) Acrescente um campo adicional na tabela de Aluno, chamado de informacoesExtras, do
-- tipo JSON. Insira dados diferentes telefônicos e de times de futebol que o aluno torce para cada aluno
-- neste JSON. Crie  ́ındices para o JSON e mostre consultas que o utiliza (explain analyze). Exemplo:
-- retorne os alunos que torcem para o Internacional.

alter table aluno
add column 	informacoesExtras jsonb;

--Time aleatorio
Create or replace function time_futebol() returns text as
$$
declare
	times text[][] := '{{Grêmio}, {Internacional}, {Chapecoense}, {Flamengo}, {São Paulo}, {Corinthians}}';
	result text := '';
begin
	result := times[1 + random() * (array_length(times, 1) - 1)];

	return result;
end;
$$ language plpgsql;

do $$
begin
	for i in 2001..4000 loop
		insert into Aluno(Nome, RA, DataNasc, Idade, NomeMae, Cidade, Estado, Curso, periodo, informacoesExtras) 
		values (
			texto(30),
	        i,
	        data(),
	        numero(2),
	        texto(30),
	        texto(10),
	        texto(2),
	        texto(30),
	        numero(1),
	        ('{
	            "telefone1" : ' || numero(5) || ',
	            "telefone2" : "' || numero(5) || '",
	            "timeFutebol" : ' || time_futebol() || '
	        }')::json
		);
	end loop;
end;
$$ language plpgsql;

create index IdxTimeFutebol1 on Aluno
using BTREE ((informacoesExtras->>'timeFutebol'));

analyze Aluno;

explain analyze 
select informacoesExtras->>'timeFutebol'
from aluno
where informacoesExtras->>'timeFutebol' = 'Chapecoense';

explain analyze 
select informacoesExtras->>'timeFutebol'
from aluno
where informacoesExtras @> '{"timeFutebol": "Chapecoense"}';

drop index IdxTimeFutebol;

