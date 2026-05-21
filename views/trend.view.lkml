view: trend {
  sql_table_name: "DATA_SETS"."Sales_Data" ;;

  dimension_group: order {
    type: time
    timeframes: [
      date,
      month,
      year
    ]
    sql: TO_DATE(TO_CHAR(${TABLE}."Order_date_KEY"), 'YYYYMMDD') ;;
  }

  dimension: sales_amount {
    type: number
    sql: ${TABLE}.sales ;;
    hidden: yes
  }

  dimension: profit_amount {
    type: number
    sql: ${TABLE}.profit ;;
    hidden: yes
  }


  measure: total_sales {
    type: sum
    sql: ${sales_amount} ;;
    label: "売上"
  }

  measure: total_profit {
    type: sum
    sql: ${profit_amount} ;;
    label: "利益"
  }

  measure: profit_rate {
    type: number
    sql: 1.0 * ${total_profit} / NULLIF(${total_sales}, 0) ;;
    value_format_name: percent_1
    label: "利益率"
  }
}
