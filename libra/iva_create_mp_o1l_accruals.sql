create
    definer = iva@`%` procedure iva_create_mp_o1l_accruals(in current_order_id    int,
                                                           in current_period_id   int,
                                                           in points_package      decimal(10, 2),
                                                           in points_subscribe    decimal(10, 2),
                                                           in source_package_name varchar(255),
                                                           in entity_type         varchar(255))
begin

    if entity_type = 'sale' and source_package_name <> 'Silver' then
      update
        iva_mp_transactions
      set
        o1l_package = points_package,
        o1l_subscribe = points_subscribe
      where
        order_id = current_order_id
        and source_user_id = target_user_id
        and type = entity_type;
    else
      update
        iva_mp_transactions bonus

        join iva_mp_user_roots tree
        on tree.order_id = current_order_id
          and tree.parent_id = bonus.target_user_id
          and tree.child_id = bonus.source_user_id
          and tree.is_leaf = true
      set
        bonus.o1l_package = points_package,
        bonus.o1l_subscribe = points_subscribe
      where
        bonus.period_id = current_period_id
        and bonus.order_id = current_order_id
        and bonus.type = entity_type;
    end if;

  end;

