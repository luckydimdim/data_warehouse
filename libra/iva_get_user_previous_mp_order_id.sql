create
    definer = iva@`%` function iva_get_user_previous_mp_order_id(current_user_id  int,
                                                                 current_order_id int) returns int
begin
    return
      (select
        previous.order_id
      from
        iva_mp_transactions current

        join iva_mp_transactions previous
        on previous.period_id = current.period_id
          and previous.status = 'completed'
          and previous.target_user_id = current_user_id
          and previous.sequence = current.sequence - 1
      where
        current.order_id = current_order_id);
  end;

