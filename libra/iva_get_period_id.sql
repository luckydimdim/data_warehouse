create
    definer = iva@`%` function iva_get_period_id(datetime datetime) returns int
begin
    return largo.iva_get_period_id(datetime);
end;

