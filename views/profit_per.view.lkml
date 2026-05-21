view: profit_per {
  derived_table: {
    sql:
    SELECT
        "Sales" as sales
        "Gross_Profit" as profit
        "Gross_profit" / "Sales" AS profit_per
        TO_DATE(TO_VARCHAR("Order_date_KEY")) AS sales_date
    FROM "DATA_SETS"."Sales_Data"
    ;;
  }

  dimension: sales_date {
    type: date
    sql: ${TABLE}.sales_date ;;
  }

  measure:  Sales{
    type: sum
    sql: ${TABLE}.sales ;;
  }

  measure: profit {
    type: sum
    sql: ${TABLE}.profit ;;
  }

  measure: profit_per {
    type: number
    value_format: "0.00%"
    sql: ${TABLE}.profit_per;;
  }

}
