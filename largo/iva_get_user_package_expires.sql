create
    definer = iva@`%` function iva_get_user_package_expires(current_user_id  int,
                                                            current_datetime datetime) returns datetime
begin
    return
      (select
          new_package_expires
        from
          iva_user_packages
        where
          user_id = current_user_id
          and created <= current_datetime
          and new_package_expires > now()
        order by
          created desc
        limit 1);

  end;

