CREATE TABLE aluno (
    ra INTEGER PRIMARY KEY,
    nome varchar(30)
);

INSERT INTO aluno VALUES (1, 'Daniel');
INSERT INTO aluno VALUES (2, 'Cinglair');
INSERT INTO aluno VALUES (3, 'Jeferson');
INSERT INTO aluno VALUES (4, 'João');
INSERT INTO aluno VALUES (5, 'Gustavo');

SELECT ra, nome FROM aluno WHERE nome = "Daniel";

CREATE INDEX IdxNome ON aluno (nome);

-- Dependendo da seletividade, ele não vai consultar o índice
SELECT ra, nome FROM aluno WHERE nome = "Daniel";

-- Inserir mais dados para estimular o índice
do $$
begin
    for i IN 6..10000 LOOP
        INSERT INTO aluno VALUES (i, 'nome');
    end LOOP;
end $$

-- Nesse caso a seletividade aumentou, pois a quantidade de tuplas aumentou, portanto ele irá consultar o index
SELECT ra, nome FROM aluno WHERE nome = "Daniel";