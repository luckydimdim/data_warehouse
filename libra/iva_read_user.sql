create
    definer = iva@`%` procedure iva_read_user(in user_id varchar(255))
begin

  call largo.iva_read_user(user_id);

end;

