create table students (
    info jsonb
);

-- Popular o campo 'info' dentro de 'students'
do $$
declare
    vartype varchar[] = '{"quiz", "exam", "homework"}';
    begin
        for i in 1..1000000 loop
            for j in 1..3 loop
                insert into students values (('
                {
                "student" : ' || i || ',
                "type" : "' || vartype[j] || '",
                "score" : ' || round(random()*100) || '
                }')::json);
            end loop;
        end loop;
    end; 
$$
language plpgsql;

explain analyze
Select info
FROM students
where info->>'type' = 'quiz'

-- Criar índice para o campo específico no JSON
create index idxtype on students
using BTREE ((info->>'type'));

-- @> seleciona a string que está contida dentro do JSON
explain analyze
Select *
FROM students
WHERE info @> '{"type": "quiz"}';

-- Criar um índice genérico para o JSON
create index idxJSON on students using GIN (info);

Select info->>'student'
FROM students
where info->>'score' = '10' -- Mesmo sendo números, a comparação sempre é feita com strings
group by info->>'student'
explain analyze

Select *
FROM students
WHERE info @> '{"student": 3212}' and info->>'type' = 'exam';

explain analyze
Select info->>'score'
FROM students
WHERE info->>'student' = '3212'


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
        {
            "telefone1" : ' || numero(11) || ',
            "telefone2" : "' || numero(11) || '",
            "timeFutebol" : ' || time() || '
        }')::json)
);