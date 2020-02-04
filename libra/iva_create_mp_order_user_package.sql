create
    definer = iva@`%` procedure iva_create_mp_order_user_package(in current_order_id int)
proc:begin

    declare current_user_id int default null;
    declare current_package_id int default null;
    declare subscription_duration int default null;
    declare package_changed bool default false;
    declare old_package_id int default null;
    declare old_subscription_expires datetime default null;
    declare order_created datetime default null;

    select
      users.package_id,
      users.package_expires,
      users.user_id,
      packages.package_id,
      packages.subscription_duration_in_month,
      orders.created
    into
      old_package_id,
      old_subscription_expires,
      current_user_id,
      current_package_id,
      subscription_duration,
      order_created
    from
      libra.iva_mp_orders orders

      join iva_mp_order_positions positions
      on positions.order_id = orders.order_id

      join largo.iva_mp_position_packages packages
      on packages.total_position_id = positions.total_id

      join iva_users users
      on users.user_id = orders.user_id
    where
      orders.order_id = current_order_id;

    if current_package_id is null then
      leave proc;
    end if;

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

      update
        iva_users
      set
        package_id = current_package_id,
        package_name = iva_get_package_name(current_package_id)
      where
        user_id = current_user_id;

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

      update
        iva_users
      set
        package_expires = date_add(old_subscription_expires, interval +subscription_duration month)
      where
        user_id = current_user_id;

    end;
end;

