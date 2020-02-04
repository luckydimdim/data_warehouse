create
    definer = iva@`%` procedure iva_delete_mp_order_user_package(in current_order_id int)
begin

  delete from
    iva_user_packages
  where
    order_id = current_order_id;

end;

