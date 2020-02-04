create
    definer = iva@`%` procedure iva_delete_mp_period_order_accruals(in current_period_id int)
begin
  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  delete from
    iva_mp_order_accruals
  where
    period_id = current_period_id;
end;

