create
    definer = iva@`%` procedure iva_read_periods()
begin
  call largo.iva_read_periods();
end;

