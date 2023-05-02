set datestyle to "DMY,SQL";

create or replace function generate_random_data() returns date as
$$
   begin
   return date(timestamp '1980-01-01 00:00:00' +
       random() * (timestamp '2020-07-18 00:00:00' -
                   timestamp '1980-01-01 00:00:00'));
   end;
$$ language plpgsql;
