view: abc{
  derived_table: {
    sql:
    WITH product_sales AS (
    SELECT
    "Product_ID" AS PRODUCT_ID,
    SUM("Sales") AS total_sales,
    SUM("Gross_Profit") AS profit
    FROM
    "DATA_SETS"."Sales_Data"
    GROUP BY
    1
    ),
    ordered_sales AS (
    SELECT
    PRODUCT_ID,
    total_sales,
    profit,
    -- 売上の高い順に累積売上を計算
    SUM(total_sales) OVER (ORDER BY total_sales DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_sales,
    -- 全体の総売上を計算
    SUM(total_sales) OVER () AS grand_total_sales
    FROM
    product_sales
    )
    SELECT
    product_id,
    profit,
    total_sales,
    cumulative_sales,
    -- 累積売上比率を計算 (0.0 〜 1.0)
    CASE
      WHEN grand_total_sales = 0 THEN 0
      ELSE cumulative_sales / grand_total_sales
    END AS cumulative_sales_ratio,
    "Product_Name" AS product_name
    FROM
    ordered_sales
    INNER JOIN "DATA_SETS"."Product_Master"
      ON product_id = "DATA_SETS"."Product_master"."Product_ID"
    ;;
  }

  measure: profit {
    type: sum
    label: "利益"
    sql: ${TABLE}.profit ;;
  }

  dimension: Product_id {
    type: string
    primary_key: yes
    sql: ${TABLE}.product_id ;;
  }

  measure: total_sales_amount {
    type: sum
    label: "製品別総売上"
    sql: ${TABLE}.total_sales ;;
  }

  measure: cumulative_sales_ratio {
    type: sum
    label: "累積売上比率"
    value_format_name: percent_2
    sql: ${TABLE}.cumulative_sales_ratio ;;
  }

  dimension: abc_class {
    type: string
    label: "ABC区分"
    description: "A: 上位70%, B: 70-90%, C: 90-100%"
    sql:
    CASE
    WHEN ${TABLE}.cumulative_sales_ratio <= 0.20 THEN 'A'
    WHEN ${TABLE}.cumulative_sales_ratio <= 0.40 THEN 'B'
    ELSE 'C'
    END
    ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }
}
