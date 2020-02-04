create
    definer = iva@`%` procedure iva_delete_user_transfers(in current_user_id int)
begin
  delete from
    iva_user_transfers
  where
    user_id = current_user_id;
end;

