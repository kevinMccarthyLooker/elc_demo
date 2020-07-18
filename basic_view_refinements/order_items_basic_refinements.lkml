include: "/views/order_items.view"
view:+order_items {
  drill_fields: []
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

  dimension: week_and_day_of_year {
    sql: concat(${created_week_of_year},'-',${created_day_of_week_index}) ;;
    order_by_field: week_and_day_of_year_sort
  }
  dimension: week_and_day_of_year_sort {
    sql: concat(${created_week_of_year}*10 + ${created_day_of_week_index}) ;;

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
    link: {
        url: "{{drill_holder._link}}"
        label: "drill to details"
    }

  }

  measure: drill_holder {
    type: number
    drill_fields: [order_items.order_id,order_items.id,order_items.sale_price,order_items.created_date,users.first_name,users.last_name,order_summary_for_user.is_user_first_order,order_summary_for_user.items_in_order,order_items.total_sale_price]
    sql: max(1) ;;
  }


  measure: total_sale_price_current_year_thousands_format {
    type: sum
    sql: ${sale_price} ;;
    filters: [current_year: "Yes"]
    value_format: "$#.0,k;-$#.0,k"
    drill_fields: []
    #links moved to dimensions for consistency and clarity - i.e. window always appears in same location
#     link: {
#       url: "https://profservices.dev.looker.com/embed/looks/635?&f[order_items.special_date_filter]={{_filters['order_items.special_date_filter']}}&f[users.us_region]={{row['users.us_region']}}&f[users.traffic_source]={{row['users.traffic_source']}}&f[products.brand]={{row['users.products.brand']}}&toggle=det"
#       label: "{%if users.us_region_is_selected %}{%else%}{{row['users.us_region']}}{{row['users.traffic_source']}}{{row['products.brand']}} by Region{%endif%}"
#     }
#     link: {
#       url: "https://profservices.dev.looker.com/embed/looks/633?&f[order_items.special_date_filter]={{_filters['order_items.special_date_filter']}}&f[users.us_region]={{row['users.us_region']}}&f[users.traffic_source]={{row['users.traffic_source']}}&f[products.brand]={{row['users.products.brand']}}&toggle=det"
#       label: "{%if users.traffic_source._is_selected %}{%else%}{{row['users.us_region']}}{{row['users.traffic_source']}}{{row['products.brand']}} by Traffic Source{%endif%}"
#     }
#     link: {
#       url: "https://profservices.dev.looker.com/embed/looks/634?&f[order_items.special_date_filter]={{_filters['order_items.special_date_filter']}}&f[users.us_region]={{row['users.us_region']}}&f[users.traffic_source]={{row['users.traffic_source']}}&f[products.brand]={{row['users.products.brand']}}&toggle=det"
#       label: "{%if products.brand._is_selected %}{%else%}{{row['users.us_region']}}{{row['users.traffic_source']}}{{row['products.brand']}} by Brand{%endif%}"
#     }
#     #map
#     link: {
#       url: "https://profservices.dev.looker.com/embed/looks/636?&f[order_items.special_date_filter]={{_filters['order_items.special_date_filter']}}&f[users.us_region]={{row['users.us_region']}}&f[users.traffic_source]={{row['users.traffic_source']}}&f[products.brand]={{row['users.products.brand']}}&toggle=det"
#       label: "{{row['users.us_region']}}{{row['users.traffic_source']}}{{row['products.brand']}} Total Sales by State (Map)"
#     }
  }
  measure: total_sale_price_last_year {
    type: sum
    sql: ${sale_price} ;;
    filters: [last_year: "Yes"]
    value_format_name: usd_0
  }
  measure: total_sale_price_percent_change {
    label: "%∆"
    type: number
    sql: (${total_sale_price_current_year}-${total_sale_price_last_year})*1.0/nullif(${total_sale_price_last_year},0) ;;
    value_format_name: percent_0
  }
  dimension: total {
    sql: 'Total' ;;
    link: {
      url: "https://profservices.dev.looker.com/embed/looks/635?&f[order_items.special_date_filter]={{_filters['order_items.special_date_filter']}}&f[users.us_region]={{row['users.us_region']}}&f[users.traffic_source]={{row['users.traffic_source']}}&f[products.brand]={{row['users.products.brand']}}&toggle=det"
      label: "{%if users.us_region_is_selected %}{%else%}{{row['users.us_region']}}{{row['users.traffic_source']}}{{row['products.brand']}} by Region{%endif%}"
    }
    #traffic source drill down
#     link: {
#       url: "https://profservices.dev.looker.com/embed/looks/633?&f[order_items.special_date_filter]={{_filters['order_items.special_date_filter']}}&f[users.us_region]={{row['users.us_region']}}&f[users.traffic_source]={{row['users.traffic_source']}}&f[products.brand]={{row['users.products.brand']}}&toggle=det"
#       label: "{%if users.traffic_source._is_selected %}{%else%}{{row['users.us_region']}}{{row['users.traffic_source']}}{{row['products.brand']}} by Traffic Source{%endif%}"
#     }
    #brand drill down
    link: {
      url: "https://profservices.dev.looker.com/embed/looks/634?&f[order_items.special_date_filter]={{_filters['order_items.special_date_filter']}}&f[users.us_region]={{row['users.us_region']}}&f[users.traffic_source]={{row['users.traffic_source']}}&f[products.brand]={{row['users.products.brand']}}&toggle=det"
      label: "{%if products.brand._is_selected %}{%else%}{{row['users.us_region']}}{{row['users.traffic_source']}}{{row['products.brand']}} by Brand{%endif%}"
    }
    #dill to map
    link: {
      url: "https://profservices.dev.looker.com/embed/looks/636?&f[order_items.special_date_filter]={{_filters['order_items.special_date_filter']}}&f[users.us_region]={{row['users.us_region']}}&f[users.traffic_source]={{row['users.traffic_source']}}&f[products.brand]={{row['users.products.brand']}}&toggle=det"
      label: "{{row['users.us_region']}}{{row['users.traffic_source']}}{{row['products.brand']}} Total Sales by State (Map)"
    }
    #dill to week of year
    link: {
      url: "https://profservices.dev.looker.com/embed/looks/637?&f[order_items.special_date_filter]={{_filters['order_items.special_date_filter']}}&f[users.us_region]={{row['users.us_region']}}&f[users.traffic_source]={{row['users.traffic_source']}}&f[products.brand]={{row['users.products.brand']}}&f[order_summary_for_user.is_user_first_order_label]={{row['order_summary_for_user.is_user_first_order_label']}}&toggle=det"
      label: "{{row['users.us_region']}}{{row['users.traffic_source']}}{{row['products.brand']}} by Week of Year"
    }
  }
  measure: total_measure {
    type: string
    sql: max('Total') ;;
    html: {{rendered_value}} (∆{{total_sale_price_percent_change._rendered_value}});;
  }
}
