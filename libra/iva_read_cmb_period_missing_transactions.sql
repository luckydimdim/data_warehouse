create
    definer = iva@`%` procedure iva_read_cmb_period_missing_transactions(in current_period_id int)
begin
  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  select
    payment_props.iblock_element_id order_id,
    concat('call iva_create_cmb_transactions(', payment_props.iblock_element_id, ', ', current_period_id, ');') create_transaction,
    concat('call iva_update_cmb_accrual(', payment_props.iblock_element_id, ', ', current_period_id, ');') create_accrual,
    concat('call iva_update_cmb_accruals(', current_period_id, ');') create_accruals
  from
    iva.b_iblock_element_prop_s87 payment_props

    left join iva_cmb_transactions transactions
    on transactions.order_id = payment_props.iblock_element_id
  where
    payment_props.property_2198 = current_period_id
    and transactions.id is null;
end;

