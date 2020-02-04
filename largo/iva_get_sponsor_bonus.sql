create
    definer = iva@`%` function iva_get_sponsor_bonus(gold_quantity     int,
                                                     platinum_quantity int) returns int
begin
    set @total_quantity = gold_quantity div 4 + platinum_quantity;

    return case
              when @total_quantity < 3 or @total_quantity is null then 0
              when @total_quantity >= 3 and @total_quantity < 5 then 200
              when @total_quantity >= 5 and @total_quantity < 10 then 300
              when @total_quantity >= 10 and @total_quantity < 15 then 500
              when @total_quantity >= 15 and @total_quantity < 20 then 650
              when @total_quantity >= 20 and @total_quantity < 25 then 800
              when @total_quantity >= 25 and @total_quantity < 30 then 1000
              when @total_quantity >= 30 and @total_quantity < 40 then 1150
              when @total_quantity >= 40 and @total_quantity < 1000 then 1600
            end;
  end;

