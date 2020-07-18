view: products {
  sql_table_name: "PUBLIC"."PRODUCTS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}."BRAND" ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}."CATEGORY" ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}."COST" ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}."DEPARTMENT" ;;
  }

  dimension: distribution_center_id {
    type: number
    sql: ${TABLE}."DISTRIBUTION_CENTER_ID" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}."RETAIL_PRICE" ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}."SKU" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}

view: +products {
  dimension: brand {
    link: {
      url: "https://profservices.dev.looker.com/embed/looks/635?&f[order_items.special_date_filter]={{_filters['order_items.special_date_filter']}}&f[users.us_region]={{row['users.us_region']}}&f[users.traffic_source]={{row['users.traffic_source']}}&f[products.brand]={{row['users.products.brand']}}&toggle=det"
      label: "{%if users.us_region_is_selected %}{%else%}{{row['users.us_region']}}{{row['users.traffic_source']}}{{row['products.brand']}} by Region{%endif%}"
    }
    #traffic source drill down
    link: {
      url: "https://profservices.dev.looker.com/embed/looks/633?&f[order_items.special_date_filter]={{_filters['order_items.special_date_filter']}}&f[users.us_region]={{row['users.us_region']}}&f[users.traffic_source]={{row['users.traffic_source']}}&f[products.brand]={{row['users.products.brand']}}&toggle=det"
      label: "{%if users.traffic_source._is_selected %}{%else%}{{row['users.us_region']}}{{row['users.traffic_source']}}{{row['products.brand']}} by Traffic Source{%endif%}"
    }
    #brand drill down
#     link: {
#       url: "https://profservices.dev.looker.com/embed/looks/634?&f[order_items.special_date_filter]={{_filters['order_items.special_date_filter']}}&f[users.us_region]={{row['users.us_region']}}&f[users.traffic_source]={{row['users.traffic_source']}}&f[products.brand]={{row['users.products.brand']}}&toggle=det"
#       label: "{%if products.brand._is_selected %}{%else%}{{row['users.us_region']}}{{row['users.traffic_source']}}{{row['products.brand']}} by Brand{%endif%}"
#     }
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
}
