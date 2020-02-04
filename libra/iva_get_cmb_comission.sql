create
    definer = iva@`%` function iva_get_cmb_comission(current_package_id int) returns int
begin
    return largo.iva_get_cmb_comission(current_package_id);
  end;

