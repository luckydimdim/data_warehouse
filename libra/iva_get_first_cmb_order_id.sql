create
    definer = iva@`%` function iva_get_first_cmb_order_id(current_period_id int) returns int
begin
    if current_period_id is null then
      set current_period_id = iva_get_period_id(null);
    end if;

    return
      ( select
        min(order_props.order_id)
      from
        iva_cmb_orders order_props
      where
        order_props.period_id = current_period_id
        and order_props.status = 'completed' );
  end;

