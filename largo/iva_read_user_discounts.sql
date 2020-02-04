create
    definer = iva@`%` procedure iva_read_user_discounts(in current_user_id   varchar(255),
                                                        in current_period_id int)
begin
  declare current_lead_discount decimal(9, 2);
  declare previous_lead_discount decimal(9, 2);
  declare personal_discount decimal(9, 2);
  declare current_user_package_name varchar(255);

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  if iva_is_numeric(current_user_id) = false then
    set current_user_id = iva_get_user_id(current_user_id);
  end if;

  select
    ifnull( if (has_business, 'Business', (
      select
        iva_get_user_package_name(current_user_id, iva_get_period_finish(current_period_id)))
    ), 'Silver')
  into
    current_user_package_name
  from
    iva_users users
  where
    id = current_user_id;

  select
    ifnull(profits.cmb, 0) previous_lead_discount,
    ifnull(profits.kp, 0) current_lead_discount
  into
    previous_lead_discount,
    current_lead_discount
  from
    iva_profits profits
  where
    profits.period_id = current_period_id
    and profits.user_id = current_user_id;

  select
    value
  into
    personal_discount
  from
    iva_package_discounts
  where
    package_name = current_user_package_name;

  select
    current_user_id user_id,
    current_user_package_name package_name,
    ifnull(personal_discount, 0) personal_discount,
    ifnull(previous_lead_discount, 0) previous_lead_discount,
    ifnull(current_lead_discount, 0) current_lead_discount,
    cast(( 1 - (1 - personal_discount / 100) * (1 - greatest(ifnull(previous_lead_discount, 0), ifnull(current_lead_discount, 0)) / 100) ) * 100 as decimal(9, 2)) summary_discount;
end;

