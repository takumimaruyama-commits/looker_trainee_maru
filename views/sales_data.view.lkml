# The name of this view in Looker is "Sales Data"
view: sales_data {
  sql_table_name: "DATA_SETS"."Sales_Data" ;;

  measure: cost_of_sales {
    type: sum
    sql: ${TABLE}."Cost_of_Sales" ;;
  }

  dimension: customer_id {
    type: number
    sql: ${TABLE}."Customer_ID" ;;
  }

  measure: gross_profit {
    type: sum
    sql: ${TABLE}."Gross_Profit" ;;
  }

  dimension: order_date_key {
    type: number
    sql: ${TABLE}."Order_date_KEY" ;;
  }

  dimension: product_id {
    type: number
    sql: ${TABLE}."Product_ID" ;;
  }

  measure: quantity {
    type: sum
    sql: ${TABLE}."Quantity" ;;
  }

  measure: sales {
    type: sum
    sql: ${TABLE}."Sales" ;;
  }

  dimension: sales_date {
    type: date
    sql: TO_DATE(${TABLE}."Sales_Date", 'YYYY/M/D') ;;
  }

  measure: profit_per {
    type: number
    sql: "Gross_Profit" / "Sales" ;;
  }


}
