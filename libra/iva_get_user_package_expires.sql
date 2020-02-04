create
    definer = iva@`%` function iva_get_user_package_expires(current_user_id  int,
                                                            current_datetime datetime) returns datetime
begin
    return largo.iva_get_user_package_expires(current_user_id, current_datetime);

  end;

