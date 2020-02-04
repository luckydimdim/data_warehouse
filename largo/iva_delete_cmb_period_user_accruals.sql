create
    definer = iva@`%` procedure iva_delete_cmb_period_user_accruals(in current_user_id   int,
                                                                    in current_period_id int)
begin
  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  delete from
    iva_cmb_accruals
  where
    period_id = current_period_id
    and user_id = current_user_id;
end;

