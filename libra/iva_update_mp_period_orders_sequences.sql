create
    definer = iva@`%` procedure iva_update_mp_period_orders_sequences(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  set @sequence = -1;
  update
    (select
      order_id
    from
      iva_mp_orders
    where
      period_id = current_period_id
      and status in ('new', 'completed')
    order by
      created asc) sequented_orders

    join iva_mp_orders orders
    on orders.order_id = sequented_orders.order_id
  set
    orders.sequence = @sequence := @sequence + 1
  where
    orders.period_id = current_period_id
    and orders.status in ('new', 'completed');

end;

