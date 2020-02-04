create
    definer = iva@`%` procedure iva_create_cmb_branches_cancel()
begin

    update
      iva_user_branches
    set
      cmb_points = 0,
      cmb_money = 0,
      total_points = mp_points,
      total_money = mp_money
    where
      is_trash = false
      and cmb_money <> 0;

  end;

