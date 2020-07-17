connection: "snowlooker"
include: "/basic_view_refinements/order_items_basic_refinements"
include: "/**/order_items_with_user_order_sequence.view"

week_start_day: monday

explore: order_items {

  join: order_summary_for_user {
    sql_on: ${order_items.order_id}=${order_summary_for_user.order_id} ;;
    type: left_outer
    relationship: many_to_one
  }
  sql_always_where: ${order_items.meets_special_date_filter}='Yes' ;;#parameterized filter defined in order_items refinement
}
