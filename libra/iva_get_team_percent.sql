create
    definer = iva@`%` function iva_get_team_percent(generation    int,
                                                    qualification int) returns int
begin
    return largo.iva_get_team_percent(generation, qualification);
  end;

