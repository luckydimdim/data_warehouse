create
    definer = iva@`%` procedure iva_update_cmb_order_accruals(in current_order_id  int,
                                                              in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  call iva_create_cmb_order_accruals(current_order_id, current_period_id);

end;

