create
    definer = iva@`%` function iva_get_user_package_name(current_user_id  int,
                                                         current_datetime datetime) returns varchar(255)
begin
    return largo.iva_get_user_package_name(current_user_id, current_datetime);

  end;

