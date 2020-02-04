create
    definer = iva@`%` procedure iva_create_cmb_order_accruals(in current_order_id  int,
                                                              in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  insert iva_cmb_accruals
    (order_id, order_number, created, order_positions, period_id, partner_id, user_id, user_name_and_surname,
     user_email, user_phone, user_generation, user_package_name, activation, base_price, price, points, money,
     status, comment, utm_source, utm_medium, utm_campaign, utm_term, utm_content)
  select
    payment_props.order_id,
    payment_props.order_number,
    bonuses.created,
    payment_props.name,
    current_period_id period,
    bonuses.target_user_id partner_id,
    users.id user_id,
    concat_ws(' ', users.name, users.surname),
    users.login user_login,
    ifnull(users.phone, ''),
    ifnull(child.depth - parent.depth + 1, 0) user_generation,
    bonuses.source_package_name user_package_name,
    ifnull(results.activation, 0) activation,
    payment_props.base_price,
    payment_props.price,
    bonuses.points points,
    bonuses.price money,
    bonuses.status,
    bonuses.comment,
    payment_props.utm_source,
    payment_props.utm_medium,
    payment_props.utm_campaign,
    payment_props.utm_term,
    payment_props.utm_content
  from
    libra.iva_cmb_transactions bonuses

    join libra.iva_cmb_orders payment_props
    on payment_props.order_id = bonuses.order_id

    join iva_users users
    on users.id = bonuses.source_user_id

    join iva_users partner_props
    on partner_props.id = bonuses.target_user_id

    left join iva_profits results
    on results.user_id = bonuses.source_user_id
      and results.period_id = current_period_id

    left join iva_user_roots parent
    on parent.child_id = bonuses.source_user_id
      and parent.parent_id = bonuses.target_user_id

    left join iva_user_roots child
    on child.child_id = bonuses.source_user_id
      and child.is_leaf = true
  where
    bonuses.period_id = current_period_id
    and bonuses.order_id = current_order_id


  on duplicate key update
    largo.iva_cmb_accruals.order_number = payment_props.order_number,
    largo.iva_cmb_accruals.created = bonuses.created,
    largo.iva_cmb_accruals.order_positions = payment_props.name,
    largo.iva_cmb_accruals.user_name_and_surname = concat_ws(' ', users.name, users.surname),
    largo.iva_cmb_accruals.user_email = users.login,
    largo.iva_cmb_accruals.user_phone = ifnull(users.phone, ''),
    largo.iva_cmb_accruals.user_generation = ifnull(child.depth - parent.depth + 1, 0),
    largo.iva_cmb_accruals.user_package_name = bonuses.source_package_name,
    largo.iva_cmb_accruals.activation = ifnull(results.activation, 0),
    largo.iva_cmb_accruals.base_price = payment_props.base_price,
    largo.iva_cmb_accruals.price = payment_props.price,
    largo.iva_cmb_accruals.points = bonuses.points,
    largo.iva_cmb_accruals.money = bonuses.price,
    largo.iva_cmb_accruals.status = bonuses.status,
    largo.iva_cmb_accruals.comment = bonuses.comment,
    largo.iva_cmb_accruals.utm_source = payment_props.utm_source,
    largo.iva_cmb_accruals.utm_medium = payment_props.utm_medium,
    largo.iva_cmb_accruals.utm_campaign = payment_props.utm_campaign,
    largo.iva_cmb_accruals.utm_term = payment_props.utm_term,
    largo.iva_cmb_accruals.utm_content = payment_props.utm_content;

end;

