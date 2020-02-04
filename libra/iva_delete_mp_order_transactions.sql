create
    definer = iva@`%` procedure iva_delete_mp_order_transactions(in current_order_id  int,
                                                                 in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  delete from
    iva_mp_transactions
  where
    period_id = current_period_id
    and order_id = current_order_id;

end;

