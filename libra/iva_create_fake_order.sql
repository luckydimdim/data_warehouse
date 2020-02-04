create
    definer = iva@`%` procedure iva_create_fake_order(in current_user_id                       int,
                                                      in current_package_id                    int,
                                                      in current_activation_duration_in_months int)
proc:begin
  declare current_order_name varchar(255);
  declare current_package_name varchar(255);
  declare current_order_id int;
  declare current_position_id int;
  declare current_period_id int;
  declare current_tariff_id int;
  declare current_position_price decimal(12, 4);

  if current_user_id is null or current_package_id is null then
    leave proc;
  end if;

  set current_period_id = iva_get_period_id(null);
  set current_package_name = iva_get_package_name(current_package_id);
  set current_order_name = concat('Fake ', current_package_name, ' order for ', current_user_id);

  if current_package_name = 'Gold' then
    set current_tariff_id = 1726522;
    set current_position_price = 7800;
  else
    set current_tariff_id = 1807562;
    set current_position_price = 27000;
  end if;

  insert iva.b_iblock_element
    (TIMESTAMP_X, MODIFIED_BY, DATE_CREATE, CREATED_BY, IBLOCK_ID, ACTIVE, NAME)
  values
    (now(), 3, now(), 3, 74, 'Y', current_order_name);

  set current_order_id = (
    select
      id
    from
      iva.b_iblock_element
    where
      name = current_order_name
      and IBLOCK_ID = 74);

  if current_order_id is null then
    leave proc;
  end if;

  insert iva.b_iblock_element_prop_s74
    (IBLOCK_ELEMENT_ID, PROPERTY_2015, PROPERTY_2016, PROPERTY_2017, PROPERTY_2018, PROPERTY_2037, PROPERTY_2038, PROPERTY_2183, PROPERTY_2190, PROPERTY_2191, PROPERTY_2199, PROPERTY_2200, PROPERTY_2201, PROPERTY_2207)
  values
    (current_order_id, current_user_id, current_position_price, 4143, current_tariff_id, 'Без взаимодействия с банком', 'OK', current_order_name, 'Y', 'IVA', current_period_id, now(), 'COMPLETED', current_tariff_id);

  insert iva.b_iblock_element
    (TIMESTAMP_X, MODIFIED_BY, DATE_CREATE, CREATED_BY, IBLOCK_ID, ACTIVE, NAME)
  values
    (now(), 3, now(), 3, 89, 'Y', current_order_name);

  set current_position_id = (
    select
      id
    from
      iva.b_iblock_element
    where
      name = current_order_name
      and IBLOCK_ID = 89);

  if current_position_id is null then
    leave proc;
  end if;

  insert iva.b_iblock_element_prop_s89
    (IBLOCK_ELEMENT_ID, PROPERTY_2208, PROPERTY_2209, PROPERTY_2210, PROPERTY_2211, PROPERTY_2212, PROPERTY_2213, PROPERTY_2214, PROPERTY_2223)
  values
    (current_position_id, current_order_id, current_tariff_id, current_order_name, 1, current_position_price, current_position_price, 'rub', current_period_id);

  update
    iva.b_uts_user
  set
    UF_HAS_ACTIVATION = true,
    UF_ACTIVATION_TILL = concat(last_day(date_add(now(), interval +current_activation_duration_in_months-1 month)), ' 23:59:59')
  where
    value_id = current_user_id;

  call iva_create_mp_order(current_order_id);
  call iva_create_mp_accruals(current_order_id, current_period_id);
end;

