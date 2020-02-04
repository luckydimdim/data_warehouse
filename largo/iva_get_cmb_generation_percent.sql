create
    definer = iva@`%` function iva_get_cmb_generation_percent(generation int) returns decimal(9, 2)
begin
    return case
      when generation = 0 then 70
      when generation = 1 then 20
      when generation = 2 then 3
      when generation = 3 then 3
      when generation = 4 then 4
      when generation > 4 then 0
    end;
  end;

