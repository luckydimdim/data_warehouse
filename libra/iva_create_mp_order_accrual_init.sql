create
    definer = iva@`%` procedure iva_create_mp_order_accrual_init(in current_order_id  int,
                                                                 in current_period_id int)
begin

  declare current_order_created datetime;

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  set current_order_created = (
    select
      created
    from
      iva_mp_orders
    where
      order_id = current_order_id);

  insert iva_mp_accruals
    (created, period_id, user_id, go, o1l, ks, package_name)

  with accruals (datetime, period_id, user_id, go, o1l, ks, package_name) as (
    with results (datetime, period_id, user_id, go, o1l, ks, package_name) as (
      select
        iva_get_period_finish(current_period_id),
        current_period_id,
        bonus.target_user_id,
        sum(bonus.go_package + bonus.go_subscribe),
        sum(bonus.o1l_package + bonus.o1l_subscribe),
        iva_get_package_ratio(users.package_id),
        users.package_name
      from
        iva_mp_transactions bonus

        join iva_users users
        on users.user_id = bonus.target_user_id
      where
        bonus.target_user_id in (
          select
            target_user_id
          from
            iva_mp_transactions
          where
            order_id = current_order_id)
        and bonus.period_id = current_period_id
      group by
        bonus.target_user_id),

    bonus_o1l (user_id, value) as (
      with sale_o1l (user_id, value) as (
        select
          bonus.target_user_id user_id,
          sum(bonus.o1l_package + bonus.o1l_subscribe) value
        from
          iva_mp_transactions bonus
        where
          bonus.target_user_id in (
            select
              target_user_id
            from
              iva_mp_transactions
            where
              order_id = current_order_id)
          and bonus.period_id = current_period_id
        group by
          bonus.target_user_id)

      select
        users.target_user_id user_id,
        ifnull(sale_o1l.value, 0) o1l
      from
        iva_mp_transactions users

        left join sale_o1l
        on sale_o1l.user_id = users.target_user_id
      where
        users.order_id = current_order_id)

    select
      results.datetime, results.period_id, results.user_id, results.go,
      ifnull(bonus_o1l.value, 0), results.ks, results.package_name
    from
      results

      left join bonus_o1l
      on bonus_o1l.user_id = results.user_id
    group by
      results.user_id)

  select datetime, period_id, user_id, go, o1l, ks, package_name from accruals

  on duplicate key update
    iva_mp_accruals.created = accruals.datetime,
    iva_mp_accruals.go = accruals.go,
    iva_mp_accruals.o1l = accruals.o1l,
    iva_mp_accruals.ks = accruals.ks,
    iva_mp_accruals.package_name = accruals.package_name;

end;

