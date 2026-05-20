view: plot {

  derived_table: {
    sql:WITH product_sales AS (
        SELECT
          Product_ID AS PRODUCT_ID,
          "Sales" AS SALES,
          SUM("Sales") AS total_sales,
          "Gross_Profit" AS PROFIT
        FROM "DATA_SETS"."Sales_Data""
        GROUP BY
          1
      ),
      -- 売上降順
      cumulative_sales AS (
        SELECT
          product_id,
          SALES,
          PROFIT,
          total_sales,
          SUM(total_sales) OVER (ORDER BY total_sales DESC) AS running_total_sales,
          SUM(total_sales) OVER () AS grand_total_sales
        FROM
          product_sales
      )
      -- 累積構成比
      SELECT
        product_id,
        SALES,
        PROFIT,
        total_sales,
        (running_total_sales / grand_total_sales) AS cumulative_ratio
        CASE
          WHEN (running_total_sales / grand_total_sales) <= 0.70 THEN 'Aクラス (累積~70%)'
          WHEN (running_total_sales / grand_total_sales) <= 0.90 THEN 'Bクラス (累積70~90%)'
          ELSE 'Cクラス (累積90%~)'
        END AS abc_rank
      FROM
        cumulative_sales
    ;;
  }

  dimension: Product_id {
    type: string
    primary_key: yes
    sql: ${TABLE}.Product_ID ;;
  }

  measure:  Sales{
    type: number
    sql: ${TABLE}.Sales ;;
  }

  measure:  Profit{
    type: number
    sql: ${TABLE}.Gross_Profit ;;
  }

  dimension: abc_rank {
    label: "ABC分析ランク（累積）"
    type: string
    sql: ${TABLE}.abc_rank ;;
  }

  dimension: cumulative_ratio {
    label: "累積構成比"
    type: number
    value_format_name: percent_2
    sql: ${TABLE}.cumulative_ratio ;;
  }
}
