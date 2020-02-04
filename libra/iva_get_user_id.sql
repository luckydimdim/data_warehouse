create
    definer = iva@`%` function iva_get_user_id(current_email varchar(255)) returns int
begin
  return largo.iva_get_user_id(current_email);
end;

