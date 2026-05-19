# The name of this view in Looker is "Budget Data"
view: budget_data {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: "DATA_SETS"."Budget_Data" ;;

  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

    # Here's what a typical dimension looks like in LookML.
    # A dimension is a groupable field that can be used to filter query results.
    # This dimension will be called "Budget Amount" in Explore.

  dimension: budget_amount {
    type: number
    sql: ${TABLE}."Budget_Amount" ;;
  }

  dimension: budget_year {
    type: string
    sql: ${TABLE}."Budget_Year" ;;
  }

  dimension: store_id {
    type: string
    sql: ${TABLE}."Store_ID" ;;
  }
  measure: count {
    type: count
  }
}
