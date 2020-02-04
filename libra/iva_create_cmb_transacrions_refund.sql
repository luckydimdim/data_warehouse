create
    definer = iva@`%` procedure iva_create_cmb_transacrions_refund(in current_order_id int,
                                                                   in current_comment  varchar(255))
begin

    insert iva_cmb_transactions
      (order_id, created, period_id, source_user_id, source_package_name, target_user_id, target_package_name, price, points, comment, status)
    select
      bonus.order_id,
      bonus.created,
      iva_get_period_id(bonus.created),
      bonus.source_user_id,
      bonus.source_package_name,
      bonus.target_user_id,
      bonus.target_package_name,
      bonus.price * -1,
      bonus.points * -1,
      current_comment,
      if (bonus.status = 'completed', 'refund', bonus.status)
    from
      iva_cmb_transactions bonus
    where
      bonus.order_id = current_order_id;

end;

