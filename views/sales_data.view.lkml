# The name of this view in Looker is "Sales Data"
view: sales_data {
  derived_table: {
    sql:
    SELECT * FROM "DATASETS"."Sales_Master"
    WHERE "Store_Area" = {% parameter parameter_area %};;
  }

  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Cost of Sales" in Explore.

  dimension: cost_of_sales {
    type: string
    sql: ${TABLE}."Cost_of_Sales" ;;
  }

  dimension: customer_id {
    type: number
    sql: ${TABLE}."Customer_ID" ;;
  }

  dimension: gross_profit {
    type: string
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

  dimension: quantity {
    type: string
    sql: ${TABLE}."Quantity" ;;
  }

  dimension: sales {
    type: string
    sql: ${TABLE}."Sales" ;;
  }

  dimension: sales_date {
    type: string
    sql: ${TABLE}."Sales_Date" ;;
  }

  dimension: store_id {
    type: number
    sql: ${TABLE}."Store_ID" ;;
  }

  dimension: voucher_number {
    type: string
    sql: ${TABLE}."Voucher_Number" ;;
  }
  measure: count {
    type: count
  }

  dimension: sales_comparison {
    type: yesno
    sql: ${TABLE}."SALES" >= 500 ;;
  }

  measure: average_sales {
    type: average
    label: "平均売上金額"
    value_format: "\"￥\"#,##0"
    sql: abs(${TABLE."Sales") ;;
  }
}
