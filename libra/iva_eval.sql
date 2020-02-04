create
    definer = iva@`%` procedure iva_eval(in sql_code text)
begin
    set @sql_code = sql_code;
    prepare stmt from @sql_code;
    execute stmt;
end;

