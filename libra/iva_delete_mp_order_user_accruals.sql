create
    definer = iva@`%` procedure iva_delete_mp_order_user_accruals(in current_user_id int)
begin
  delete from
    iva_mp_order_accruals
  where
    user_id = current_user_id;
end;

