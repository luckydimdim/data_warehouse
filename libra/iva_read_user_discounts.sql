create
    definer = iva@`%` procedure iva_read_user_discounts(in current_user_id   varchar(255),
                                                        in current_period_id int)
begin
  call largo.iva_read_user_discounts(current_user_id, current_period_id);
end;

