create
    definer = iva@`%` procedure iva_update_collation(in collation_name varchar(255))
begin
  if collation_name is null or collation_name = '' then
    set collation_name = 'utf8_general_ci';
  end if;

  update_collation:begin

    declare done int default false;
    declare query text;

    declare cursor1 cursor for
      select
        concat('alter table ', t.table_name, ' convert to character set utf8 collate ''', collation_name, ''';')
      from
        information_schema.tables t
      where
        t.table_schema = 'datalake'
        and t.table_collation <> collation_name
        and t.table_type = 'BASE TABLE'
      group by
        t.table_name;

    declare continue handler for not found set done = true;

    open cursor1;

    read_loop: loop

      fetch cursor1 into query;

      if done then
        leave read_loop;
      end if;

      call iva_eval(query);

    end loop;

    close cursor1;

  end;
end;

