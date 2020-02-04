create
    definer = iva@`%` procedure iva_create_mp_go_accruals(in current_order_id    int,
                                                          in current_period_id   int,
                                                          in payment_date        datetime,
                                                          in points_package      decimal(10, 2),
                                                          in points_subscribe    decimal(10, 2),
                                                          in source_user_id      int,
                                                          in source_package_name varchar(255),
                                                          in entity_type         varchar(255),
                                                          in payment_source      varchar(255))
begin

    if entity_type = 'user' then
      insert iva_mp_transactions
        (order_id, type, created, source, source_user_id, source_package_name,
         target_user_id, target_package_name, go_package, go_subscribe, period_id, status)
      select
        current_order_id,
        entity_type,
        payment_date,
        payment_source,
        source_user_id,
        source_package_name,
        tree.parent_id target_user_id,
        users.package_name target_package_name,
        points_package go_package,
        points_subscribe go_subscribe,
        current_period_id,
        'new'
      from
        iva_mp_user_roots tree

        join iva_users users
        on users.user_id = tree.parent_id
      where
        tree.order_id = current_order_id
        and tree.child_id = source_user_id;
    else
      insert iva_mp_transactions
        (order_id, type, created, source, source_user_id, source_package_name,
         target_user_id, target_package_name, go_package, go_subscribe, period_id, status)
      select
        current_order_id,
        entity_type,
        payment_date,
        payment_source,
        source_user_id,
        source_package_name,
        tree.parent_id target_user_id,
        users.package_name target_package_name,
        points_package go_package,
        points_subscribe go_subscribe,
        current_period_id,
        'new'
      from
        iva_mp_user_roots tree

        join iva_users users
        on users.user_id = tree.parent_id
      where
        tree.order_id = current_order_id
        and tree.child_id = source_user_id;

      if source_package_name <> 'Silver' then
        insert iva_mp_transactions
          (order_id, type, created, source, source_user_id, source_package_name,
           target_user_id, target_package_name, go_package, go_subscribe, period_id, status)
        values
          (current_order_id,
          entity_type,
          payment_date,
          payment_source,
          source_user_id,
          source_package_name,
          source_user_id,
          source_package_name,
          points_package,
          points_subscribe,
          current_period_id,
          'new');
      end if;
    end if;

end;

