create
    definer = iva@`%` procedure iva_update_period_prop_hidden(in current_period_id int)
begin

  declare current_value bool;

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  set current_value = (
    select
      is_hidden
    from
      largo.iva_periods
    where
      id = current_period_id);

  update
    largo.iva_periods
  set
    is_hidden = !current_value
  where
    id = current_period_id;

end;

