create
    definer = iva@`%` function iva_get_personal_discount(current_package_id varchar(255)) returns decimal(9, 2)
begin
  return largo.iva_get_personal_discount(current_package_id);
end;

