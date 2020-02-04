create
    definer = iva@`%` function iva_get_user_discount(current_user_id int) returns decimal(9, 2)
begin
  return largo.iva_get_user_discount(current_user_id);
end;

