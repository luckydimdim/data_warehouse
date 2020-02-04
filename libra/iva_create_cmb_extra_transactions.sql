create
    definer = iva@`%` procedure iva_create_cmb_extra_transactions(in current_order_id  int,
                                                                  in current_period_id int)
proc:begin
  declare accrual_user_id int;
  declare accrual_id int default null;
  declare accrual_value decimal(9, 2) default 0;
  declare accrual_created datetime;
  declare current_comment varchar(255);

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  select
    id,
    user_id,
    value
  into
    accrual_id,
    accrual_user_id,
    accrual_value
  from
    iva_cmb_extra_accruals
  where
    status = 'new'
    and type = 'partial_payment'
    and order_id = current_order_id;

  if accrual_id is not null then
    call iva_create_cmb_transactions_cancel(current_order_id, current_period_id, 'Частичная оплата');

    update
      iva_cmb_transactions
    set
      status = 'partial_payment'
    where
      period_id = current_period_id
      and order_id = current_order_id;

    update
      iva_cmb_extra_accruals
    set
      status = 'completed'
    where
      id = accrual_id;

    update
      iva.b_iblock_element_prop_s90
    set
      property_2221 = 'completed'
    where
      property_2217 = 'partial_payment'
      and property_2216 = current_order_id;

    set accrual_id = null;
  end if;

  select
    id,
    user_id,
    value,
    created
  into
    accrual_id,
    accrual_user_id,
    accrual_value,
    accrual_created
  from
    iva_cmb_extra_accruals
  where
    status = 'new'
    and type = 'complete_payment'
    and order_id = current_order_id;

  if accrual_id is not null then
    call iva_delete_cmb_order_transactions(current_order_id, current_period_id);
    call iva_update_cmb_period_accruals(current_period_id);

    call largo.iva_delete_cmb_order_accruals(current_order_id, current_period_id);
    call largo.iva_update_cmb_period_profits(current_period_id);
    call largo.iva_update_user_totals(current_period_id);
    call largo.iva_update_cmb_user_branches(current_period_id);

    call iva_update_cmb_order(current_order_id);
    call iva_create_cmb_order_transactions(current_order_id, current_period_id);

    update
      iva_cmb_transactions
    set
      status = 'complete_payment'
    where
      period_id = current_period_id
      and order_id = current_order_id;

    update
      iva_cmb_extra_accruals
    set
      status = 'completed'
    where
      id = accrual_id;

    update
      iva.b_iblock_element_prop_s90
    set
      property_2221 = 'completed'
    where
      property_2217 = 'complete_payment'
      and property_2216 = current_order_id;

    set accrual_id = null;
  end if;

  select
    id,
    user_id,
    value,
    comment
  into
    accrual_id,
    accrual_user_id,
    accrual_value,
    current_comment
  from
    iva_cmb_extra_accruals
  where
    status = 'new'
    and type = 'change_price'
    and order_id = current_order_id;

  if accrual_id is not null then
    update
      iva_cmb_orders
    set
      price = price + accrual_value
    where
      period_id = current_period_id
      and order_id = current_order_id;

    call iva_delete_cmb_order_transactions(current_order_id, current_period_id);
    call iva_create_cmb_order_transactions(current_order_id, current_period_id);

    update
      iva_cmb_transactions
    set
      comment = ifnull( current_comment, concat( abs(accrual_value), ' р ', if (accrual_value < 0, 'удержано', 'начислено') ) )
    where
      period_id = current_period_id
      and order_id = current_order_id;

    call largo.iva_update_cmb_order(current_order_id);

    update
      iva_cmb_extra_accruals
    set
      status = 'completed'
    where
      id = accrual_id;

    update
      iva.b_iblock_element_prop_s90
    set
      property_2221 = 'completed'
    where
      property_2217 = 'change_price'
      and property_2216 = current_order_id;

    set accrual_id = null;
  end if;

  select
    id
  into
    accrual_id
  from
    iva_cmb_extra_accruals
  where
    status = 'new'
    and type = 'first_hand'
    and order_id = current_order_id;

  if accrual_id is not null then
    insert iva_cmb_transactions
      (order_id, created, source_user_id, source_package_name, target_user_id,
       target_package_name, price, points, comment, period_id, status)
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
      current_period_id,
      'first_hand'
    from
      iva_cmb_orders payment_props

      join iva_cmb_transactions bonus
      on bonus.period_id = current_period_id
        and bonus.order_id = payment_props.order_id
        and bonus.is_leaf = true
    where
      payment_props.period_id = current_period_id
      and payment_props.order_id = current_order_id;

    insert iva_cmb_transactions
      (order_id, created, source_user_id, source_package_name, target_user_id,
       target_package_name, price, points, comment, period_id, status)
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
      current_period_id,
      'first_hand'
    from
      iva_cmb_orders payment_props

      join iva_cmb_transactions bonus
      on bonus.period_id = current_period_id
        and bonus.order_id = payment_props.order_id
        and bonus.is_leaf = true
    where
      payment_props.period_id = current_period_id
      and payment_props.order_id = current_order_id
    limit 1;

    update
      iva_cmb_extra_accruals
    set
      status = 'completed'
    where
      id = accrual_id;

    update
      iva.b_iblock_element_prop_s90
    set
      property_2221 = 'completed'
    where
      property_2217 = 'first_hand'
      and property_2216 = current_order_id;

    set accrual_id = null;
  end if;

  select
    id,
    user_id
  into
    accrual_id,
    accrual_user_id
  from
    iva_cmb_extra_accruals
  where
    status = 'new'
    and type = 'club_lead'
    and order_id = current_order_id;

  if accrual_id is not null then
    insert iva_cmb_transactions
      (order_id, created, source_user_id, source_package_name, target_user_id,
       target_package_name, price, points, comment, period_id, status)
    select
      bonus.order_id,
      payment_props.created,
      bonus.source_user_id,
      bonus.source_package_name,
      accrual_user_id,
      iva_get_user_package_name(accrual_user_id, payment_props.created),
      payment_props.price * 0.2 price,
      payment_props.price * 0.2 / 60 points,
      'Начислено руководителю Женского клуба',
      current_period_id,
      'club_lead'
    from
      iva_cmb_orders payment_props

      join iva_cmb_transactions bonus
      on bonus.period_id = current_period_id
        and bonus.order_id = payment_props.order_id
        and bonus.is_leaf = true
    where
      payment_props.period_id = current_period_id
      and payment_props.order_id = current_order_id
    limit 1;

    update
      iva_cmb_extra_accruals
    set
      status = 'completed'
    where
      id = accrual_id;

    update
      iva.b_iblock_element_prop_s90
    set
      property_2221 = 'completed'
    where
      property_2217 = 'club_lead'
      and property_2216 = current_order_id;

    set accrual_id = null;
  end if;

end;

