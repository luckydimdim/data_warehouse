create
    definer = iva@`%` function iva_is_numeric(sin varchar(1024)) returns tinyint
    RETURN sIn REGEXP '^(-|\\+){0,1}([0-9]+\\.[0-9]*|[0-9]*\\.[0-9]+|[0-9]+)$';

