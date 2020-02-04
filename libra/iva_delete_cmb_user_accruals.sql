create
    definer = iva@`%` procedure iva_delete_cmb_user_accruals(in current_user_id int)
begin
  delete from
    iva_cmb_accruals
  where
    user_id = current_user_id;
end;

