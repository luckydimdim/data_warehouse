create
    definer = iva@`%` procedure iva_update_user_package(in current_user_id       int,
                                                        in current_order_id      int,
                                                        in current_package_id    int,
                                                        in subscription_duration int)
proc:begin

    declare package_changed bool default false;
    declare old_package_id int;
    declare old_subscription_expires datetime;

    set @is_package_already_updated = (
      select
        id
      from
        largo.iva_user_packages
      where
        order_id = current_order_id
      limit 1);

    if @is_package_already_updated is not null then
      leave proc;
    end if;

    select
      uf_package_new,
      uf_active_date
    into
      old_package_id,
      old_subscription_expires
    from
      iva.b_uts_user
    where
      value_id = current_user_id;

    if old_package_id <> current_package_id then
      set package_changed = true;
    end if;

    change_package:begin

      if package_changed = false then
        leave change_package;
      end if;

      update
        iva.b_uts_user user_info
      set
        uf_previous_package = uf_package_new,
        uf_package_new = current_package_id
      where
        value_id = current_user_id;


      call largo.iva_update_user_package(
        current_user_id,
        current_order_id,
        old_package_id,
        current_package_id);

    end;

    change_subscription:begin

      if subscription_duration is null then
        leave change_subscription;
      end if;

      if old_subscription_expires is null or old_subscription_expires < now() then
        set old_subscription_expires = now();
      end if;

      if package_changed = false then
        if old_package_id = iva_get_package_id('Silver') then
          leave change_subscription;
        end if;
      end if;

      update
        iva.b_uts_user
      set
        uf_active_date = date_add(old_subscription_expires, interval +subscription_duration month)
      where
        value_id = current_user_id;

    end;


    call largo.iva_update_user(current_user_id);
end;

