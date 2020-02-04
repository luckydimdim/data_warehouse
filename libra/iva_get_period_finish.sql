create
    definer = iva@`%` function iva_get_period_finish(period_id int) returns datetime
begin
    return largo.iva_get_period_finish(period_id);
  end;

