create
    definer = iva@`%` procedure iva_delete_user_withdrawals(in current_user_id int)
begin
  delete from
    iva_withdrawals
  where
    user_id = current_user_id;


  call largo.iva_delete_user_withdrawals(current_user_id);
end;

