create
    definer = iva@`%` procedure iva_update_mp_period_transactions_sequences(in current_period_id int)
begin

  if current_period_id is null then
    set current_period_id = iva_get_period_id(null);
  end if;

  update
    iva_mp_transactions bonuses

    join (
      with sequence (order_id, user_id, value, temp_user_id, temp_order_id) as (
        select
          bonuses.order_id,
          bonuses.target_user_id,

          case
            when bonuses.target_user_id = @currentUserId
              and bonuses.order_id <> @currentOrderId then
              @currentRow := @currentRow + 1
            else
              @currentRow := if (bonuses.order_id = @currentOrderId, @currentRow, 0)
          end number,

          @currentUserId := bonuses.target_user_id,
          @currentOrderId := bonuses.order_id
        from
          iva_mp_transactions bonuses

          join (
            select
              @currentRow := -1,
              @currentUserId := 0,
              @currentOrderId := 0) r
        where
          bonuses.period_id = current_period_id
        order by
          bonuses.target_user_id asc,
          bonuses.created asc)

      select * from sequence) sequence
    on sequence.order_id = bonuses.order_id
      and sequence.user_id = bonuses.target_user_id
  set
    bonuses.sequence = sequence.value
  where
    bonuses.period_id = current_period_id;
end;

