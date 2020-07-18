view: users {
  sql_table_name: PUBLIC.USERS
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.AGE ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.CITY ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.COUNTRY ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.CREATED_AT ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.EMAIL ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.FIRST_NAME ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.GENDER ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.LAST_NAME ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.LATITUDE ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.LONGITUDE ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.STATE ;;
    map_layer_name: us_states
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.TRAFFIC_SOURCE ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.ZIP ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, order_items.count]
  }
}


view: +users {
  dimension: us_region {
case: {
  when: {sql:${state} in ('Connecticut','Maine','Massachusetts','New Hampshire',
             'Rhode Island','Vermont','New Jersey','New York',
             'Pennsylvania');;label:"Northeast"}
  when: {sql:${state} in ('Indiana','Illinois','Michigan','Ohio','Wisconsin',
              'Iowa','Kansas','Minnesota','Missouri','Nebraska',
              'North Dakota','South Dakota');;label:"Midwest"}
  when: {sql:${state} in ('Delaware','District of Columbia','Florida','Georgia',
             'Maryland','North Carolina','South Carolina','Virginia',
             'West Virginia','Alabama','Kentucky','Mississippi',
             'Tennessee','Arkansas','Louisiana','Oklahoma','Texas');;label:"South"}
  when: {sql:${state} in ('Arizona','Colorado','Idaho','New Mexico','Montana',
             'Utah','Nevada','Wyoming','Alaska','California',
             'Hawaii','Oregon','Washington');;label:"West"}
else: "Global"
      }

    #region drill down
#     link: {
#       url: "https://profservices.dev.looker.com/embed/looks/635?&f[order_items.special_date_filter]={{_filters['order_items.special_date_filter']}}&f[users.us_region]={{row['users.us_region']}}&f[users.traffic_source]={{row['users.traffic_source']}}&f[products.brand]={{row['users.products.brand']}}&toggle=det"
#       label: "{%if users.us_region_is_selected %}{%else%}{{row['users.us_region']}}{{row['users.traffic_source']}}{{row['products.brand']}} by Region{%endif%}"
#     }
    #traffic source drill down
    link: {
      url: "https://profservices.dev.looker.com/embed/looks/633?&f[order_items.special_date_filter]={{_filters['order_items.special_date_filter']}}&f[users.us_region]={{row['users.us_region']}}&f[users.traffic_source]={{row['users.traffic_source']}}&f[products.brand]={{row['users.products.brand']}}&toggle=det"
      label: "{%if users.traffic_source._is_selected %}{%else%}{{row['users.us_region']}}{{row['users.traffic_source']}}{{row['products.brand']}} by Traffic Source{%endif%}"
    }
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
      url: "https://profservices.dev.looker.com/embed/looks/637?&f[order_items.special_date_filter]={{_filters['order_items.special_date_filter']}}&f[users.us_region]={{row['users.us_region']}}&f[users.traffic_source]={{row['users.traffic_source']}}&f[products.brand]={{row['users.products.brand']}}&toggle=det"
      label: "{{row['users.us_region']}}{{row['users.traffic_source']}}{{row['products.brand']}} by Week of Year"
    }
}
 dimension: traffic_source {
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
  #order_summary_for_user.is_user_first_order_label
  }
}
