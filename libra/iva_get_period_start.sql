create
    definer = iva@`%` function iva_get_period_start(period_id int) returns datetime
begin
    return largo.iva_get_period_start(period_id);

  end;

