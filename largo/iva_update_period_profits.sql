create
    definer = iva@`%` procedure iva_update_period_profits(in current_period_id int)
begin
  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  call iva_create_period_profits(current_period_id);
end;

