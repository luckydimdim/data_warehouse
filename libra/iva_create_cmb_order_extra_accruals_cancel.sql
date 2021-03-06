create
    definer = iva@`%` procedure iva_create_cmb_order_extra_accruals_cancel(in current_order_id  int,
                                                                           in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  update
    iva_cmb_extra_accruals
  set
    status = 'new'
  where
    order_id = current_order_id;
end;

