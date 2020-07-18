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

    drill_fields: [state]

}

# NE.name <- c('Connecticut','Maine','Massachusetts','New Hampshire',
#              'Rhode Island','Vermont','New Jersey','New York',
#              'Pennsylvania')
# NE.abrv <- c('CT','ME','MA','NH','RI','VT','NJ','NY','PA')
# NE.ref <- c(NE.name,NE.abrv)
#
# MW.name <- c('Indiana','Illinois','Michigan','Ohio','Wisconsin',
#              'Iowa','Kansas','Minnesota','Missouri','Nebraska',
#              'North Dakota','South Dakota')
# MW.abrv <- c('IN','IL','MI','OH','WI','IA','KS','MN','MO','NE',
#              'ND','SD')
# MW.ref <- c(MW.name,MW.abrv)
#
# S.name <- c('Delaware','District of Columbia','Florida','Georgia',
#             'Maryland','North Carolina','South Carolina','Virginia',
#             'West Virginia','Alabama','Kentucky','Mississippi',
#             'Tennessee','Arkansas','Louisiana','Oklahoma','Texas')
# S.abrv <- c('DE','DC','FL','GA','MD','NC','SC','VA','WV','AL',
#             'KY','MS','TN','AR','LA','OK','TX')
# S.ref <- c(S.name,S.abrv)
#
# W.name <- c('Arizona','Colorado','Idaho','New Mexico','Montana',
#             'Utah','Nevada','Wyoming','Alaska','California',
#             'Hawaii','Oregon','Washington')
# W.abrv <- c('AZ','CO','ID','NM','MT','UT','NV','WY','AK','CA',
#             'HI','OR','WA')
# W.ref <- c(W.name,W.abrv)

#   }


}
