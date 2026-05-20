view: abc {
  derived_table: {
    sql: WITH RankedItems AS (
    SELECT
        Product_ID,
        SUM(Sales) AS total_sales,
        SUM(SUM(Sales)) OVER () AS grand_total_sales,
        SUM(SUM(Sales)) OVER (ORDER BY SUM(Sales) DESC ROWS UNBOUNDED PRECEDING) AS cumulative_sales
    FROM "DATA_SETS"."Sales_Data"
    GROUP BY Product_ID
    ),
    ABCCategories AS (
    SELECT
        Product_ID,
        total_sales,
        cumulative_sales,
        grand_total_sales,
        cumulative_sales / grand_total_sales AS cumulative_percentage,
        CASE
            WHEN cumulative_sales / grand_total_sales <= {% parameter a_threshold %} THEN 'A'
            WHEN cumulative_sales / grand_total_sales <= {% parameter b_threshold %} THEN 'B'
            ELSE 'C'
        END AS abc_category
    FROM
        RankedItems
    )
       SELECT
           Product_id,
           total_sales,
           abc_category
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
     sql: ${TABLE}.abc_category ;;
   }

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
}
