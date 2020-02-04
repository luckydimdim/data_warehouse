create
    definer = iva@`%` function iva_get_period_name_by_id(period_id int) returns varchar(255)
begin
    return largo.iva_get_period_name_by_id(period_id);
end;

