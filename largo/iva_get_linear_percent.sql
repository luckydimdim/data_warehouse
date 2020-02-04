create
    definer = iva@`%` function iva_get_linear_percent(generation    int,
                                                      qualification int) returns int
begin

    return
      case
        when generation > 7 then
          0
        when generation = 7 then
          if (qualification >= 9, 1, 0)
        when generation = 6 then
          if (qualification >= 7, 1, 0)
        when generation = 5 then
          2
        when generation = 4 then
          2
        when generation = 3 then
          3
        when generation = 2 then
          3
        when generation = 1 then
          4
      end;

  end;

