create
    definer = iva@`%` function iva_get_available_balance(current_user_id int) returns decimal(9, 2)
begin
  return largo.iva_get_available_balance(current_user_id);
end;

