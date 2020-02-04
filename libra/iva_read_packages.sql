create
    definer = iva@`%` procedure iva_read_packages()
begin
  select
    *
  from
    largo.iva_packages
  order by
    id asc;
end;

