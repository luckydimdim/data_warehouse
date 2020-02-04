create
    definer = iva@`%` function iva_get_cmb_comission(current_package_id int) returns int
begin
    return
      (select
        value
      from
        iva_package_commissions
      where
        package_id = current_package_id);
  end;

