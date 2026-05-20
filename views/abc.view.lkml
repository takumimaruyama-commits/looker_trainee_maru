view: abc {
  derived_table: {
    sql:WITH RankedItems AS (
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
            WHEN cumulative_sales / grand_total_sales <= ({% parameter a_threshold %}/ 100) THEN 'A'
            WHEN cumulative_sales / grand_total_sales <= ({% parameter b_threshold %}/ 100) THEN 'B'
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
           ABCCategories
       ORDER BY
           total_sales DESC ;;
   }


   dimension: Product_ID {
     type: number
     sql: ${TABLE}.Product_ID ;;
   }

   dimension: total_sales {
     type: number
     sql: ${TABLE}.total_sales ;;
   }

   dimension: abc_category {
     type: string
     sql: ${TABLE}.ABC_CATEGORY ;;
   }

   # Aランク専用の売上

  measure: sales_a {
    type: sum
    label: "売上 (Aランク)"
    sql: CASE WHEN ${abc_category} = 'A' THEN ${total_sales} ELSE NULL END ;;
  }

  # Bランク専用の売上
  measure: sales_b {
    type: sum
    label: "売上 (Bランク)"
    sql: CASE WHEN ${abc_category} = 'B' THEN ${total_sales} ELSE NULL END ;;
  }

  # Cランク専用の売上
  measure: sales_c {
    type: sum
    label: "売上 (Cランク)"
    sql: CASE WHEN ${abc_category} = 'C' THEN ${total_sales} ELSE NULL END ;;
  }

  # 折れ線用に累積構成比もMeasure（単一値の抽出用）にしておくと便利です
  measure: max_cumulative_percentage {
    type: max
    label: "累積構成比"
    value_format_name: percent_1
    sql: ${cumulative_percentage} ;;
  }

  dimension: cumulative_percentage {
    type: number
    value_format_name: percent_1 # 70.0% のように表示
    sql: ${TABLE}.cumulative_percentage ;;
  }
}
