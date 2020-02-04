create
    definer = iva@`%` procedure iva_read_periods()
begin
  select
    *
  from
    iva_periods
  order by
    id desc;
end;

