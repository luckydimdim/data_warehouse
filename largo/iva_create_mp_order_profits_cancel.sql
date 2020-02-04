create
    definer = iva@`%` procedure iva_create_mp_order_profits_cancel(in current_order_id  int,
                                                                   in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  update
    iva_profits profits

    join libra.iva_mp_transactions bonuses
    on bonuses.period_id = current_period_id
        and bonuses.order_id = current_order_id
        and bonuses.target_user_id = profits.user_id
  set
    profits.activation = false,
    profits.go = 0,
    profits.o1l = 0,
    profits.osv = 0,
    profits.bo = 0,
    profits.ko = 0,
    profits.k = 0,
    profits.qualification_name = iva_get_qualification_name(0),
    profits.kp = 0,
    profits.ks = 0,
    profits.cmb = 0,
    profits.lb = 0,
    profits.kb = 0,
    profits.bs = 0,
    profits.gb = 0,
    profits.sb = 0,
    profits.mp_points = 0,
    profits.mp_money = 0,
    profits.total_points = cmb_points + extra_points,
    profits.total_money = cmb_money + extra_money,
    profits.available_amount = 0
  where
    profits.period_id = current_period_id;

end;

