create
    definer = iva@`%` procedure iva_update_user_totals(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  update
    iva_users users

    join iva_profits profits
    on profits.period_id = current_period_id
      and profits.user_id = users.id
  set
    users.activation = profits.activation,
    users.go = profits.go,
    users.o1l = profits.o1l,
    users.osv = profits.osv,
    users.bo = profits.bo,
    users.ko = profits.ko,
    users.k = profits.k,
    users.qualification_name = profits.qualification_name,
    users.kp = profits.kp,
    users.ks = profits.ks,
    users.cmb = profits.cmb,
    users.lb = profits.lb,
    users.kb = profits.kb,
    users.bs = profits.bs,
    users.gb = profits.gb,
    users.sb = profits.sb,
    users.mp_points = profits.mp_points,
    users.mp_money = profits.mp_money,
    users.cmb_points = profits.cmb_points,
    users.cmb_money = profits.cmb_money,
    users.total_points = profits.total_points,
    users.total_money = profits.total_money,
    users.available_amount = profits.available_amount;
end;

