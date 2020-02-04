create
    definer = iva@`%` function iva_get_qualification_percent(amount decimal(9, 2)) returns decimal(9, 2)
begin

  return largo.iva_get_qualification_percent(amount);
  end;

