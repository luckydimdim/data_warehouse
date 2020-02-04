create
    definer = iva@`%` procedure iva_create_mp_branches_cancel()
begin

    update
      iva_user_branches
    set
      activation = false,
      go = 0,
      o1l = 0,
      osv = 0,
      bo = 0,
      ko = 0,
      k = 0,
      qualification_name = iva_get_qualification_name(0),
      kp = 0,
      ks = 0,
      cmb = 0,
      lb = 0,
      kb = 0,
      bs = 0,
      gb = 0,
      sb = 0,
      mp_points = 0,
      mp_money = 0,
      total_points = cmb_points,
      total_money = cmb_money
    where
      is_trash = false
      and mp_money <> 0;

  end;

