create
    definer = iva@`%` procedure iva_delete_mp_order_user_roots(in current_order_id  int,
                                                               in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  delete from
    iva_mp_user_roots
  where
    period_id = current_period_id
    and order_id = current_order_id;

end;

