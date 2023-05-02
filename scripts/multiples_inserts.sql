do $$
begin
    for i in 1..100000 loop
        insert into tabela (colunas) values ((random() * 100)::integer);
    end loop;
end
$$ language plpgsql