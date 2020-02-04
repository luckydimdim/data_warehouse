create
    definer = iva@`%` function iva_get_qualification_id(turnover decimal(9, 2)) returns int
begin
  return largo.iva_get_qualification_id(turnover);
  end;

