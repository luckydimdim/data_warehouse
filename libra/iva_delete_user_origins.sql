create
    definer = iva@`%` procedure iva_delete_user_origins(in user_id_or_email varchar(255))
begin

  declare current_user_id int;

  if iva_is_numeric(user_id_or_email) = false then
    set current_user_id = iva_get_user_id(user_id_or_email);
  else
    set current_user_id = cast (user_id_or_email as int);
  end if;

  delete from
    iva.b_user
  where
    id = current_user_id;

  delete from
    iva.b_uts_user
  where
    value_id = current_user_id;

  delete from
    libra.iva_users
  where
    user_id = current_user_id;

  delete from
    iva.b_user_group
  where
    user_id = current_user_id;

  delete
    positions,
    orders
  from
    iva.b_iblock_element_prop_s74 orders

    join iva.b_iblock_element_prop_s89 positions
    on positions.property_2208 = orders.iblock_element_id
  where
    orders.property_2015 = current_user_id;

  delete
    extra_accruals
  from
    iva.b_iblock_element_prop_s87 payment_props

    join iva.b_iblock_element_prop_s90 extra_accruals
    on extra_accruals.property_2216 = payment_props.iblock_element_id
  where
    payment_props.property_2170 = current_user_id;

  delete from
    iva.b_iblock_element_prop_s87
  where
    property_2170 = current_user_id;
end;

