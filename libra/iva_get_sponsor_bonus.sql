create
    definer = iva@`%` function iva_get_sponsor_bonus(gold_quantity     int,
                                                     platinum_quantity int) returns int
begin
    return largo.iva_get_sponsor_bonus(gold_quantity, platinum_quantity);
  end;

