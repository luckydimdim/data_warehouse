create
    definer = iva@`%` procedure iva_create_cmb_transactions_cancel(in current_order_id  int,
                                                                   in current_period_id int,
                                                                   in current_comment   varchar(255))
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  update
    iva_cmb_transactions
  set
    price = 0,
    points = 0,
    comment = current_comment
  where
    period_id = current_period_id
    and order_id = current_order_id;

  update
    iva_cmb_transactions
  set
    status = 'canceled'
  where
    period_id = current_period_id
    and order_id = current_order_id
    and status = 'completed';
end;

