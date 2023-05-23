# PL PGSQL

A estrutura de um código sequencial em `PLPGSQL` é da forma: 

```
[<<Nome>>]
[DECLARE <variáveis, tipos, cursores, subprograma>]
BEGIN
    <instruções>
[EXCEPTION <tratamento de exceções>]
END [Nome];
```