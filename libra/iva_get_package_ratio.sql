create
    definer = iva@`%` function iva_get_package_ratio(package_id int) returns decimal(9, 2)
begin

  return largo.iva_get_package_ratio(package_id);

  end;

