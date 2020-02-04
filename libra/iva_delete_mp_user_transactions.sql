create
    definer = iva@`%` procedure iva_delete_mp_user_transactions(in current_user_id int)
begin
  delete from
    iva_mp_transactions
  where
    source_user_id = current_user_id
    or target_user_id = current_user_id;
end;

