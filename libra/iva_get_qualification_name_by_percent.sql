create
    definer = iva@`%` function iva_get_qualification_name_by_percent(percent decimal(9, 2)) returns varchar(255)
begin

  return largo.iva_get_qualification_name_by_percent(percent);
  end;

