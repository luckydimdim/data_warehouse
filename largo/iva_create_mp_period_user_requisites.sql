create
    definer = iva@`%` procedure iva_create_mp_period_user_requisites(in current_period_id int)
begin

    if current_period_id is null then
      set current_period_id = iva_get_period_id(null);
    end if;

    insert iva_user_requisites (
      user_id,
      face_type,
      card_bik,
      card_number,
      card_account,
      user_name,
      company_name,
      bank_bik,
      inn,
      rs,
      available_amount)
    with period_users (user_id) as (
      select distinct
        user_id
      from
        libra.iva_mp_orders
      where
        period_id = current_period_id)
    select
      user_props.value_id,
      user_props.uf_money_get_type,
      user_props.uf_card_beak,
      user_props.uf_card_number,
      user_props.uf_card_account_num,
      user_props.uf_fio_passport,
      user_props.uf_type_full_name,
      user_props.uf_bank_beak,
      user_props.uf_inn,
      user_props.uf_rs,
      0
    from
      period_users

      join iva.b_user users
      on users.id = period_users.user_id

      join iva.b_uts_user user_props
      on user_props.value_id = users.id
    where
      users.active = 'Y'

    on duplicate key update
      iva_user_requisites.face_type = user_props.uf_money_get_type,
      iva_user_requisites.card_bik = user_props.uf_card_beak,
      iva_user_requisites.card_number = user_props.uf_card_number,
      iva_user_requisites.card_account = user_props.uf_card_account_num,
      iva_user_requisites.user_name = user_props.uf_fio_passport,
      iva_user_requisites.company_name = user_props.uf_type_full_name,
      iva_user_requisites.bank_bik = user_props.uf_bank_beak,
      iva_user_requisites.inn = user_props.uf_inn,
      iva_user_requisites.rs = user_props.uf_rs,
      iva_user_requisites.available_amount = iva_get_available_balance(user_props.value_id);
end;

