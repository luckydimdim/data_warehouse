create
    definer = iva@`%` procedure iva_delete_mp_order_root(in current_order_id  int,
                                                         in current_period_id int)
begin
  declare current_user_id int;

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  select
    user_id
  into
    current_user_id
  from
    libra.iva_mp_orders
  where
    period_id = current_period_id
    and order_id = current_order_id;

  delete
  from
    iva_mp_customer_roots
  where
    period_id = current_period_id
    and child_id = current_user_id;
end;

