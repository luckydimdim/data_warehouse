create
    definer = iva@`%` procedure iva_update_mp_period_user_activations(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  update
    largo.iva_users users

    join libra.iva_mp_accruals accruals
    on accruals.period_id = current_period_id
      and accruals.user_id = users.id
  set
    users.activation = accruals.activation;

  update
    largo.iva_user_branches branches

    join libra.iva_mp_accruals accruals
    on accruals.period_id = current_period_id
      and accruals.user_id = branches.child_id
  set
    branches.activation = accruals.activation;

  update
    largo.iva_profits profits

    join libra.iva_mp_accruals accruals
    on accruals.period_id = current_period_id
      and accruals.user_id = profits.user_id
  set
    profits.activation = accruals.activation
  where
    profits.period_id = current_period_id;

end;

