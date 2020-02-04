create
    definer = iva@`%` function iva_get_package_id(package_name varchar(255)) returns int
begin

  return largo.iva_get_package_id(package_name);

end;

