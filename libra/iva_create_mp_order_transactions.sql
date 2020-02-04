create
    definer = iva@`%` procedure iva_create_mp_order_transactions(in current_order_id  int,
                                                                 in current_period_id int)
begin
    proc:begin
      declare done int default false;

      declare point_price     decimal(10, 2) default 60;
      declare package_price   decimal(10, 2) default 0;
      declare subscribe_price decimal(10, 2) default 0;
      declare package_name    varchar(255)   default '';
      declare user_id         int            default 0;
      declare payment_date    datetime       default current_timestamp;
      declare entity_type     varchar(255)   default '';
      declare payment_source  varchar(255);

      declare cursor1 cursor for
        select
          if (packages.id is null, 'sale', 'user'),
          ifnull( packages.package_price, sum(positions.amount) ),
          ifnull(packages.subsription_price, 0),
          if ( packages.id is null, users.package_name, iva_get_package_name(orders.user_package_id) ),
          orders.user_id,
          orders.created
        from
          iva_mp_orders orders

          join iva_users users
          on users.user_id = orders.user_id

          join iva_mp_order_positions positions
          on positions.order_id = orders.order_id

          left join largo.iva_mp_position_packages packages
          on packages.total_position_id = positions.total_id
        where
          orders.period_id = current_period_id
          and orders.order_id = current_order_id
        group by
          packages.id
        order by
          packages.id desc;

      declare continue handler for not found set done = true;

      set payment_source = 'other';
      set entity_type = 'sale';

      open cursor1;
        read_loop: loop

          fetch cursor1 into
            entity_type,
            package_price,
            subscribe_price,
            package_name,
            user_id,
            payment_date;

          if done then
            leave read_loop;
          end if;

          call iva_create_mp_go_accruals(current_order_id, current_period_id, payment_date, package_price / point_price, subscribe_price / point_price, user_id, package_name, entity_type, payment_source);
          call iva_create_mp_o1l_accruals(current_order_id, current_period_id, package_price / point_price, subscribe_price / point_price, package_name, entity_type);

        end loop;
      close cursor1;
    end;
end;

