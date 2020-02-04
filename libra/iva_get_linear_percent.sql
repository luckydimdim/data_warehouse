create
    definer = iva@`%` function iva_get_linear_percent(generation    int,
                                                      qualification int) returns int
begin

    return largo.iva_get_linear_percent(generation, qualification);

  end;

