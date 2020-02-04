create
    definer = iva@`%` procedure iva_create_user_root(in current_user_id int)
proc:begin

  declare done int default false;
  declare current_child_id int;

  declare cursor1 cursor for
    select
      linkid
    from
      iva_users_graph
    where
      latch = 'breadth_first'
      and origid = current_user_id;

  declare continue handler for not found set done = true;

  delete
    tree
  from
    iva_users_graph graph

    join iva_user_roots tree
    on tree.child_id = graph.linkid
  where
    graph.latch = 'breadth_first'
    and graph.origid = current_user_id;

  open cursor1;

  read_loop: loop
    fetch cursor1 into current_child_id;

    if done then
      leave read_loop;
    end if;

    set @counter = -1;
    insert iva_user_roots
      (child_id, parent_id, depth)
    select
      graph.destid child_id,
      graph.linkid,
      @counter := @counter + 1
    from
      iva_users_graph graph
    where
      graph.latch = 'breadth_first'
      and graph.destid = current_child_id
      and graph.linkid <> graph.destid
      and graph.linkid <> 0;

    update
      iva_user_roots tree

      join iva_users user_props
      on user_props.parent_id = tree.parent_id
        and user_props.id = tree.child_id
    set
      tree.is_leaf = true
    where
      tree.child_id = current_child_id;
  end loop;
end;

