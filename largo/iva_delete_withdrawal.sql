create
    definer = iva@`%` procedure iva_delete_withdrawal(in current_id int)
begin
  delete from
    iva_withdrawals
  where
    id = current_id;
end;

