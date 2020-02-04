create
    definer = iva@`%` procedure iva_create_report_cmb_period_wrong_accruals(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  select
    orders.order_id,
    concat('call iva_delete_cmb_order_operations(', orders.order_id, ', ', current_period_id, '); call iva_create_cmb_accruals(', orders.order_id, ', ', current_period_id, ');') repair
  from
    largo.iva_user_branches branches

    join iva_cmb_orders orders
    on orders.period_id = current_period_id
      and orders.user_id = branches.child_id
      and orders.partial_payment_status <> 'completed'

    left join iva_cmb_transactions transactions
    on transactions.period_id = current_period_id
      and transactions.order_id = orders.order_id
      and transactions.source_user_id = orders.user_id
      and transactions.target_user_id = branches.parent_id
  where
    branches.is_trash = false
    and branches.generation <= 5
    and transactions.id is null
    and iva_get_user_package_name(branches.parent_id, orders.created) <> 'Silver'
  group by
    orders.order_id;
end;

