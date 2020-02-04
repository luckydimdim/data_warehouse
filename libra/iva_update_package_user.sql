create
    definer = iva@`%` procedure iva_update_package_user(in from_user_id int,
                                                        in to_user_id   int)
begin
  declare from_package_id int;
  declare from_subscribe_expires date;
  declare package_order_id int;
  declare to_package_id int;
  declare to_subscribe_expires date;


  select
    package_id,
    package_expires
  into
    from_package_id,
    from_subscribe_expires
  from
    largo.iva_users
  where
    id = from_user_id;

  select
    package_id,
    package_expires
  into
    to_package_id,
    to_subscribe_expires
  from
    largo.iva_users
  where
    id = to_user_id;


  if from_package_id <> 1697716 and to_package_id = 1697716  then
    select
      order_id
    into
      package_order_id
    from
      largo.iva_user_packages
    where
      user_id = from_user_id
      and new_package_id = from_package_id;

    update
      largo.iva_user_packages
    set
      user_id = to_user_id
    where
      order_id = package_order_id;


    update
      iva.b_uts_user
    set
      uf_package_new = from_package_id,
      uf_active_date = from_subscribe_expires
    where
      value_id = to_user_id;

    update
      iva.b_uts_user
    set
      uf_package_new = iva_get_package_id('Silver'),
      uf_active_date = null
    where
      value_id = from_user_id;

    update
      largo.iva_user_packages
    set
      user_id = to_user_id
    where
      user_id = to_user_id;

    update
      iva.b_iblock_element_prop_s74
    set
      property_2015 = to_user_id,
      property_2183 = concat('Перенос пакета от пользователя ', from_user_id)
    where
      property_2015 = from_user_id;

    update
      iva.b_iblock_element_prop_s87
    set
      property_2170 = to_user_id
    where
      property_2170 = from_user_id;

    update
      iva_cmb_orders
    set
      user_id = to_user_id
    where
      user_id = from_user_id;

    update
      iva_mp_orders
    set
      user_id = to_user_id
    where
      user_id = from_user_id;


    update
      iva_mp_transactions
    set
      source_user_id = to_user_id
    where
      source_user_id = from_user_id;

    update
      iva_mp_user_roots
    set
      child_id = to_user_id
    where
      child_id = from_user_id;

    update
      iva_mp_user_roots
    set
      parent_id = to_user_id
    where
      parent_id = from_user_id;

    update
      iva_mp_user_branches
    set
      child_id = to_user_id
    where
      child_id = from_user_id;

    update
      iva_mp_accruals
    set
      user_id = to_user_id
    where
      user_id = from_user_id;

    update
      iva_cmb_transactions
    set
      source_user_id = to_user_id
    where
      source_user_id = from_user_id;


    update
      largo.iva_profits
    set
      user_id = to_user_id
    where
      user_id = from_user_id;

    update
      largo.iva_mp_customer_roots
    set
      parent_id = to_user_id
    where
      parent_id = from_user_id;

    update
      largo.iva_mp_customer_roots
    set
      child_id = to_user_id
    where
      child_id = from_user_id;

    update
      largo.iva_mp_accruals
    set
      user_id = to_user_id
    where
      user_id = from_user_id;

    update
      largo.iva_mp_accruals
    set
      partner_id = to_user_id
    where
      partner_id = from_user_id;

    update
      largo.iva_cmb_accruals
    set
      user_id = to_user_id
    where
      user_id = from_user_id;

    update
      largo.iva_cmb_accruals
    set
      partner_id = to_user_id
    where
      partner_id = from_user_id;

    update
      largo.iva_user_branches
    set
      parent_id = to_user_id
    where
      parent_id = from_user_id;

    update
      largo.iva_user_branches
    set
      partner_id = to_user_id
    where
      partner_id = from_user_id;

    update
      largo.iva_user_branches
    set
      child_id = to_user_id,
      subscription_expire = null,
      is_subscription_expired = true
    where
      is_trash = false
      and child_id = from_user_id;

    update
      largo.iva_user_groups
    set
      user_id = to_user_id
    where
      user_id = from_user_id;

    call largo.iva_update_user(to_user_id);

  end if;

end;

