include: "/views/order_items.view"
view:+order_items {
  ## standard fields ## {
  dimension: primary_key {sql:${id};;}
  measure: count {
    label: "{%assign view_name_words = _view._name | split: '_'%}{%for word in view_name_words%}{{word | capitalize | append:' '}}{%endfor%} Count"
    filters:[primary_key: "-NULL"]
  }
  ## standard fields ## }
  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      month_num,
      day_of_year,
      day_of_month,
      day_of_week_index,
      week_of_year
    ]
  }
  ## overrides ## {

  ## to be hidden helper fields ## {
  dimension_group: now {
    type: time
    datatype: datetime
    timeframes: [raw,date,month,year,month_num,day_of_year,day_of_month,day_of_week_index,week_of_year]
    expression: now();;
  }

  ## sales date filter fields
  dimension: ytd {
    type: yesno
    expression: ${order_items.created_day_of_year}<=${order_items.now_day_of_year};;
  }
  #wouldn't work on january first
  dimension: previous_day_of_year {
    type: yesno
    expression: ${order_items.created_day_of_year}=${order_items.now_day_of_year}-1;;
  }
  #week starts on mondays not sundays
  dimension: week_to_date {
    type: yesno
    sql: ${order_items.created_week_of_year}=${order_items.now_week_of_year} and ${order_items.created_day_of_week_index}<=${order_items.now_day_of_week_index};;
  }
  dimension: month_to_date {
    type: yesno
    sql: ${order_items.created_month_num}=${order_items.now_month_num} and ${order_items.created_day_of_month}<=${order_items.now_day_of_month};;
  }

  dimension: last_year {
    type: yesno
    sql: ${order_items.created_year}=${order_items.now_year}-1 ;;
  }

  dimension: current_year {
    type: yesno
    sql: ${order_items.created_year}=${order_items.now_year} ;;
  }

  measure: test_count_distinct_days {
    type: number
    sql: count(distinct ${order_items.created_date}) ;;
  }
  measure: min_max_days {
    type: string
    sql: concat(min( ${order_items.created_date}),' to ',max(${order_items.created_date})) ;;
  }

  ## to be hidden helper fields ## }

  ## parameterized filter ## {

  parameter: special_date_filter {
    allowed_value: {value:"Year to Date"}
    allowed_value: {value:"Month to Date"}
    allowed_value: {value:"Week to Date"}
    allowed_value: {value:"Previous Day"}
    allowed_value: {value:"No Filter"}
  }

  dimension: meets_special_date_filter {
    case: {
      when: {
        sql:

{%if special_date_filter._parameter_value == "'Year to Date'"%}${ytd}
{%elsif special_date_filter._parameter_value == "'Month to Date'"%}${month_to_date}
{%elsif special_date_filter._parameter_value == "'Week to Date'"%}${week_to_date}
{%elsif special_date_filter._parameter_value == "'Previous Day'"%}${previous_day_of_year}
{%else%} true
{%endif%}
        ;;
        label: "Yes"
      }
      else: "No"
    }
  }

  ## parameterized filter ## }

  ## measures ##
  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_sale_price_current_year {
    type: sum
    sql: ${sale_price} ;;
    filters: [current_year: "Yes"]
    value_format_name: usd_0
  }
  measure: total_sale_price_last_year {
    type: sum
    sql: ${sale_price} ;;
    filters: [last_year: "Yes"]
    value_format_name: usd_0
  }
  measure: total_sale_price_percent_change {
    type: number
    sql: (${total_sale_price_current_year}-${total_sale_price_last_year})*1.0/nullif(${total_sale_price_last_year},0) ;;
    value_format_name: percent_2
  }
}
