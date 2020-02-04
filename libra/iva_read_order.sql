create
    definer = iva@`%` procedure iva_read_order(in current_order_id int)
begin

  set @is_cmb_order = if ((
    select
      order_id
    from
      iva_cmb_orders payment_props
    where
      payment_props.order_id = current_order_id
      or payment_props.order_number = current_order_id) is not null, true, false);

  if @is_cmb_order = false then
    select
      payment_props.order_id,
      payment_props.total_id tl_order_id,
      users.id user_id,
      users.name user_name,
      users.surname user_surname,
      users.email user_email,
      users.package_name package_name,
      iva_format_date(users.package_expires, true) package_till,
      iva_format_date(payment_props.created, false) pay_date,
      group_concat(concat(positions.name, ' x ', positions.quantity, ' (', positions.amount, ' р.)') separator ' | ') positions,
      positions.quantity positions_quantity,
      payment_props.price,
      payment_props.status,
      payment_props.period_id
    from
      iva_mp_orders payment_props

      join largo.iva_users users
      on users.id = payment_props.user_id

      left join iva_mp_order_positions positions
      on positions.order_id = payment_props.order_id

      left join largo.iva_mp_position_packages packages
      on packages.total_position_id = positions.total_id
    where
      payment_props.order_id = current_order_id;
  else
    select
      payment_props.order_id,
      payment_props.order_number gc_order_id,
      users.id user_id,
      users.name user_name,
      users.surname user_surname,
      users.email user_email,
      users.package_name package_name,
      iva_format_date(users.package_expires, true) package_till,
      iva_format_date(payment_props.created, false) pay_date,
      payment_props.name order_name,
      payment_props.base_price,
      payment_props.price,
      payment_props.partial_payment_status partial,
      payment_props.status,
      payment_props.period_id
    from
      iva_cmb_orders payment_props

      join largo.iva_users users
      on users.id = payment_props.user_id
    where
      payment_props.order_id = current_order_id
      or payment_props.order_number = current_order_id;
  end if;
end;

