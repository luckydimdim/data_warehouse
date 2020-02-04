create
    definer = iva@`%` procedure iva_read_period(in period_id int)
begin
  if period_id is null then
    set period_id = iva_get_period_id(null);
  end if;

  call largo.iva_read_period(period_id);
end;

