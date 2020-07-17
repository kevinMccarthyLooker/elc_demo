view: order_summary_for_user {
  derived_table: {
    explore_source: order_items {
      column: user_id {}
      column: order_id {}
      column: items_in_order {field:order_items.count}
      derived_column: order_sequence_for_user {sql:rank() over(partition by user_id order by order_id asc);;}
      derived_column: primary_key {sql:rank() over(order by order_id);;}
    }
    sql_trigger_value: select cast(CURRENT_TIMESTAMP() as date) ;;
    cluster_keys: ["order_id"]
  }
  dimension: primary_key {primary_key:yes sql:${order_id};; hidden:yes}
  dimension: user_id {}
  dimension: order_id {}
  dimension: order_sequence_for_user {type: number}
  dimension: items_in_order {}
  dimension: is_user_first_order {
    type:yesno
    sql:${order_sequence_for_user}=1;;
  }
  #alternate labelling
  dimension: is_user_first_order_label {
    case: {
      when: {sql:${order_sequence_for_user}=1;;label:"New Buyer"}
      else: "Repeat Buyer"
    }
  }
}
