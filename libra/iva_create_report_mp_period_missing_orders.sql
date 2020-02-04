create
    definer = iva@`%` procedure iva_create_report_mp_period_missing_orders(in current_period_id int)
begin
  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  select
    payment_props.iblock_element_id order_id,
    concat('call libra.iva_create_mp_order(', payment_props.iblock_element_id, ');') not_ready_yet,
    concat('call largo.iva_create_mp_order(', payment_props.iblock_element_id, ');') create_largo_order
  from
    iva.b_iblock_element_prop_s74 payment_props

    left join libra.iva_mp_orders o1
    on o1.order_id = payment_props.iblock_element_id
      and o1.period_id = current_period_id

    left join largo.iva_mp_orders o2
    on o2.order_id = payment_props.iblock_element_id
      and o2.period_id = current_period_id
  where
    payment_props.property_2199 = current_period_id
    and payment_props.property_2201 in ('NEW', 'COMPLETED')
    and payment_props.property_2038 in ('Операция подтверждена', 'Completed', 'OK' )
    and (o1.id is null or o2.id is null or payment_props.property_2015 <> o1.user_id)
  order by
    payment_props.property_2200;
end;

