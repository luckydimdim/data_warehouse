create
    definer = iva@`%` procedure iva_update_mp_period_users(in current_period_id int)
begin
  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  call iva_create_mp_period_users(current_period_id);

  update
    libra.iva_mp_orders orders

    join iva_mp_accruals accruals
    on accruals.user_id = orders.user_id

    join iva_users users
    on users.id = accruals.user_id
  set
    accruals.user_name_and_surname = concat_ws(' ', users.name, users.surname),
    accruals.user_email = users.login,
    accruals.user_phone = ifnull(users.phone, ''),
    accruals.user_package_name = users.package_name
  where
    orders.period_id = current_period_id;

  update
    libra.iva_mp_orders orders

    join iva_cmb_accruals accruals
    on accruals.user_id = orders.user_id

    join iva_users users
    on users.id = accruals.user_id
  set
    accruals.user_name_and_surname = concat_ws(' ', users.name, users.surname),
    accruals.user_email = users.login,
    accruals.user_phone = ifnull(users.phone, ''),
    accruals.user_package_name = users.package_name
  where
    orders.period_id = current_period_id;

  update
    libra.iva_mp_orders orders

    join iva_user_branches pc
    on pc.is_trash = false
      and pc.child_id = orders.user_id

    join iva_users users
    on users.id = pc.child_id
  set
    pc.name = ifnull(users.name, ''),
    pc.surname = ifnull(users.surname, ''),
    pc.name_and_surname = concat_ws(' ', ifnull(users.name, ''), ifnull(users.surname, '')),
    pc.email = users.login,
    pc.phone = ifnull(users.phone, ''),
    pc.package_id = users.package_id,
    pc.package_name = users.package_name,
    pc.subscription_expire = users.package_expires,
    pc.is_password_expired = users.is_password_expired
  where
    orders.period_id = current_period_id;

  update
    libra.iva_mp_orders orders

    join iva_mp_customer_roots tree
    on tree.child_id = orders.user_id

    join iva_users users
    on users.id = tree.child_id
  set
    tree.child_name_and_surname = concat_ws(' ', users.name, users.surname),
    tree.child_package_name = users.package_name,
    tree.child_email = users.login
  where
    orders.period_id = current_period_id;

  update
    libra.iva_mp_orders orders

    join iva_mp_customer_roots tree
    on tree.parent_id = orders.user_id

    join iva_users users
    on users.id = tree.parent_id
  set
    tree.parent_name_and_surname = concat_ws(' ', ifnull(users.name, ''), ifnull(users.surname, '')),
    tree.parent_package_name = users.package_name,
    tree.parent_email = users.login
  where
    orders.period_id = current_period_id;
end;

