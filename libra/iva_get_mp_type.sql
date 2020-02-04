create
    definer = iva@`%` function iva_get_mp_type(period_id int) returns int
begin
    return largo.iva_get_mp_type(period_id);
end;

