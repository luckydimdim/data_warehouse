create
    definer = iva@`%` procedure iva_create_cmb_period_profits_cancel(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  update
    iva_profits
  set
    cmb_points = 0,
    cmb_money = 0,
    total_points = mp_points + extra_points,
    total_money = mp_money + extra_money
  where
    period_id = current_period_id;
end;

