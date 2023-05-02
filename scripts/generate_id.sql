---funcoes uteis
create or replace function generate_id() returns integer as $$
declare
   h integer := 500000;
   l integer := 1;
begin
	return floor(random() * (h - l + 1) + l)::int;
end
$$ language plpgsql;

select generate_id();