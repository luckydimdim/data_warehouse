create
    definer = iva@`%` procedure iva_update_user_profit(in current_user_id   int,
                                                       in current_period_id int)
begin
  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  call iva_create_user_profit(current_user_id, current_period_id);
end;

