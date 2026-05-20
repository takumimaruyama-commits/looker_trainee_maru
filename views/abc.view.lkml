view: abc {
  derived_table: {
    sql: WITH RankedItems AS (
          SELECT
              "Product_ID" AS PRODUCT_ID,
              SUM("Sales") AS total_sales,
              SUM(SUM("Sales")) OVER () AS grand_total_sales,
              SUM(SUM("Sales")) OVER (ORDER BY SUM("Sales") DESC ROWS UNBOUNDED PRECEDING) AS cumulative_sales
          FROM "DATA_SETS"."Sales_Data"
          GROUP BY PRODUCT_ID
          ),
          ABCCategories AS (
          SELECT
              PRODUCT_ID,
              total_sales,
              cumulative_sales,
              grand_total_sales,
              cumulative_sales / grand_total_sales AS cumulative_percentage,
              CASE
                  WHEN cumulative_sales / grand_total_sales <= ({% parameter a_threshold %} / 100.0) THEN 'A'
                  WHEN cumulative_sales / grand_total_sales <= ({% parameter b_threshold %} / 100.0) THEN 'B'
                  ELSE 'C'
              END AS ABC_CATEGORY
          FROM
              RankedItems
          )
             SELECT
                 PRODUCT_ID,
                 total_sales,
                 abc_category,
                 cumulative_percentage
             FROM
                 ABCCategories ;;
  }

  # --- パラメータ設定 ---
  parameter: a_threshold {
    type: number
    default_value: "70"
    label: "Aランク閾値 (%)"
    description: "上位何%をAランクとするかの閾値"
  }

  parameter: b_threshold {
    type: number
    default_value: "90"
    label: "Bランク閾値 (%)"
    description: "上位何%をBランクとするかの閾値"
  }

  # --- ディメンション設定 ---
  dimension: product_id {
    type: number
    primary_key: yes # ← 【修正①】行の一意性を保証し、並び順を安定させます
    sql: ${TABLE}.PRODUCT_ID ;;
  }

  dimension: total_sales {
    type: number
    hidden: yes # Exploreで直接選ばせない（下のMeasureを使わせるため）
    sql: ${TABLE}.total_sales ;;
  }

  dimension: abc_category {
    type: string
    sql: ${TABLE}.ABC_CATEGORY ;;
  }

  dimension: cumulative_percentage {
    type: number
    hidden: yes # Exploreで直接選ばせない（下のMeasureを使わせるため）
    sql: ${TABLE}.cumulative_percentage ;;
  }

  # --- メジャー設定（可視化用） ---
  # 【修正②】集計テーブルに対して再SUMすると数値が狂うため、type: sum から type: number に変更
  measure: sales_a {
    type: number
    label: "売上 (Aランク)"
    value_format_name: usd_0 # 必要に応じて jpy_0 などに変更してください
    sql: SUM(CASE WHEN ${abc_category} = 'A' THEN ${total_sales} ELSE NULL END) ;;
  }

  measure: sales_b {
    type: number
    label: "売上 (Bランク)"
    value_format_name: usd_0
    sql: SUM(CASE WHEN ${abc_category} = 'B' THEN ${total_sales} ELSE NULL END) ;;
  }

  measure: sales_c {
    type: number
    label: "売上 (Cランク)"
    value_format_name: usd_0
    sql: SUM(CASE WHEN ${abc_category} = 'C' THEN ${total_sales} ELSE NULL END) ;;
  }

  measure: max_cumulative_percentage {
    type: number
    label: "累積構成比"
    value_format_name: percent_1
    sql: MAX(${cumulative_percentage}) ;;
  }
}
