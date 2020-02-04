create
    definer = iva@`%` procedure iva_update_tables()
begin
  declare done int default false;
  declare query text;

  declare cursor1 cursor for
    select
      concat('alter table ', table_name, ' engine=\'InnoDB\';')
    from
      information_schema.tables
    where
      table_schema = 'largo'
      and table_type = 'BASE TABLE'
      and engine = 'InnoDB'
    order by
      data_length desc;

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

