create
    definer = iva@`%` function iva_get_last_mp_order_id() returns int
begin
    declare current_period_id int;
    set current_period_id = iva_get_period_id(null);

    return (
      select
        order_id
      from
        libra.iva_mp_orders
      where
        status in ('new', 'completed')
        and period_id = current_period_id
        and sequence = (
          select
            max(sequence)
          from
            libra.iva_mp_orders
          where
            status in ('new', 'completed')
            and period_id = current_period_id));
  end;

