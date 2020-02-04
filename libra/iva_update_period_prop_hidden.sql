create
    definer = iva@`%` procedure iva_update_period_prop_hidden(in current_period_id int)
begin

  call largo.iva_update_period_prop_hidden(current_period_id);

end;

