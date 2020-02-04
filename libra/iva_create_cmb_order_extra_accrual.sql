create
    definer = iva@`%` procedure iva_create_cmb_order_extra_accrual(in current_order_id  int,
                                                                   in current_user_id   int,
                                                                   in accrual_type      varchar(255),
                                                                   in current_period_id int,
                                                                   in current_value     decimal(9, 2))
begin
  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  if current_value is null then
    set current_value = 0;
  end if;

  if accrual_type = 'first_hand' then
    insert iva_cmb_transactions
      (order_id, created, source_user_id, source_package_name,
       target_user_id, target_package_name, price, points, comment, period_id)
    select
      bonus.order_id,
      payment_props.created,
      bonus.source_user_id,
      bonus.source_package_name,
      bonus.target_user_id,
      bonus.target_package_name,
      payment_props.price * 0.05 * -1 price,
      payment_props.price * 0.05 / 60 * -1 points,
      'Отчисление в отдел сопровождения и проверки',
      current_period_id
    from
      iva_cmb_orders payment_props

      join iva_cmb_transactions bonus
      on bonus.order_id = payment_props.order_id
        and bonus.is_leaf = true
    where
      payment_props.period_id = current_period_id
      and payment_props.order_id = current_order_id;

    insert iva_cmb_transactions
      (order_id, created, source_user_id, source_package_name,
       target_user_id, target_package_name, price, points, comment, period_id)
    select
      bonus.order_id,
      payment_props.created,
      bonus.source_user_id,
      bonus.source_package_name,
      676703,
      'Silver',
      payment_props.price * 0.05 price,
      payment_props.price * 0.05 / 60 points,
      'Отчисление в отдел сопровождения и проверки',
      current_period_id
    from
      iva_cmb_orders payment_props

      join iva_cmb_transactions bonus
      on bonus.order_id = payment_props.order_id
        and bonus.is_leaf = true
    where
      payment_props.period_id = current_period_id
      and payment_props.order_id = current_order_id
    limit 1;
  end if;

  if accrual_type = 'club_lead' then
    insert iva_cmb_transactions
      (order_id, created, source_user_id, source_package_name,
       target_user_id, target_package_name, price, points, comment, period_id)
    select
      bonus.order_id,
      payment_props.created,
      bonus.source_user_id,
      bonus.source_package_name,
      current_user_id,
      iva_get_user_package_name(current_user_id, payment_props.created),
      payment_props.price * 0.2 price,
      payment_props.price * 0.2 / 60 points,
      'Начислено руководителю Женского клуба',
      current_period_id
    from
      iva_cmb_orders payment_props

      join iva_cmb_transactions bonus
      on bonus.order_id = payment_props.order_id
        and bonus.is_leaf = true
    where
      payment_props.period_id = current_period_id
      and payment_props.order_id = current_order_id
    limit 1;
  end if;


  if accrual_type = 'change_price' then
    update
      iva_cmb_orders
    set
      price = price + current_value
    where
      period_id = current_period_id
      and order_id = current_order_id;

    call iva_delete_cmb_order_transactions(current_order_id, current_period_id);
    call iva_create_cmb_order_transactions(current_order_id, current_period_id);

    update
      iva_cmb_transactions
    set
      comment = concat( abs(current_value), ' р ', if (current_value < 0, 'удержано', 'начислено'), ' на кофе-брейк' )
    where
      period_id = current_period_id
      and order_id = current_order_id;

    call largo.iva_update_cmb_order(current_order_id);
  end if;

  call iva_delete_cmb_order_accruals(current_order_id, current_period_id);
  call iva_create_cmb_order_accruals(current_order_id, current_period_id);


  call largo.iva_delete_cmb_order_accruals(current_order_id, current_period_id);
  call largo.iva_create_cmb_order_accruals(current_order_id, current_period_id);
  call largo.iva_update_cmb_order_profits(current_order_id, current_period_id);
  call largo.iva_update_user_totals(current_period_id);
  call largo.iva_update_cmb_user_branches(current_period_id);
end;

