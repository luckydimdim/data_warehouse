create
    definer = iva@`%` function iva_get_cmb_generation_percent(generation int) returns decimal(9, 2)
begin
    return largo.iva_get_cmb_generation_percent(generation);
  end;

