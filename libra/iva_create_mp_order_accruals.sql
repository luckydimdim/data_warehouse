create
    definer = iva@`%` procedure iva_create_mp_order_accruals(in current_order_id  int,
                                                             in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;


    insert iva_mp_order_accruals
      (user_id,
      order_id,
      created,
      period_id,
      package_name,
      activation,
      go,
      o1l,
      osv,
      bo,
      ks,
      ko,
      kp,
      cmb,
      k,
      lb,
      kb,
      bs,
      gb,
      sb,
      points,
      money)
    select
      results.user_id,
      current_order_id,
      order_props.created,
      results.period_id,
      results.package_name,
      results.activation,
      results.go,
      results.o1l,
      results.osv,
      results.bo,
      results.ks,
      results.ko,
      results.kp,
      results.cmb,
      results.k,
      results.lb,
      results.kb,
      results.bs,
      results.gb,
      results.sb,
      results.points,
      results.points * 60
    from
      iva_mp_orders order_props

      cross join iva_mp_accruals results
    where
      results.period_id = current_period_id
      and order_props.order_id = current_order_id;

  end;

