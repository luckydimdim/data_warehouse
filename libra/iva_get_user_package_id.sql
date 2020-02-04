create
    definer = iva@`%` function iva_get_user_package_id(current_user_id  int,
                                                       current_datetime datetime) returns int
begin
      return largo.iva_get_user_package_id(current_user_id, current_datetime);
  end;

