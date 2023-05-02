create or replace function generate_random_number(digits integer) returns integer as
$$
begin
    return trunc(random() * power(10, digits)) + 1;
end;
$$ language plpgsql;

SELECT generate_random_number(10);