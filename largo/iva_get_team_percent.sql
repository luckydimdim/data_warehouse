create
    definer = iva@`%` function iva_get_team_percent(generation    int,
                                                    qualification int) returns int
begin
    return case
            when generation > 7 then
              0
            when generation = 7 then
              if (qualification >= 9, 4, 0)
            when generation = 6 then
              if (qualification >= 7, 4, 0)
            when generation = 5 then
              7
            when generation = 4 then
              7
            when generation = 3 then
              8
            when generation = 2 then
              10
            when generation = 1 then
              15
          end;
  end;

