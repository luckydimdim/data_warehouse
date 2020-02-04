create
    definer = iva@`%` function iva_get_user_package_id(current_user_id  int,
                                                       current_datetime datetime) returns int
begin
      return
        (select ifnull(
          (select
            new_package_id
          from
            iva_user_packages
          where
            user_id = current_user_id
            and created <= current_datetime
          order by
            created desc
          limit 1), iva_get_package_id('Silver') ) package_name);
  end;

