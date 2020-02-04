create
    definer = iva@`%` procedure iva_create_user_totals_cancel()
begin
  update
    iva_users users
  set
    users.activation = false,
    users.go = 0,
    users.o1l = 0,
    users.osv = 0,
    users.bo = 0,
    users.ko = 0,
    users.k = 0,
    users.qualification_name = '',
    users.kp = 0,
    users.ks = 0,
    users.cmb = 0,
    users.lb = 0,
    users.kb = 0,
    users.bs = 0,
    users.gb = 0,
    users.sb = 0,
    users.mp_points = 0,
    users.mp_money = 0,
    users.cmb_points = 0,
    users.cmb_money = 0,
    users.total_points = 0,
    users.total_money = 0,
    users.available_amount = 0
  where
    activation = true
    or cmb <> 0
    or total_money <> 0
    or available_amount <> 0;
end;

