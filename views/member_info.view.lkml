# The name of this view in Looker is "Member Info"
view: member_info {
  derived_table: {
    sql:
    SELECT * FROM "DATA_SET"."Member_Info"
    WHERE {%condition filter_birthday %} TO_DATE("Birthday", 'YYYY/MM/DD') {% endcondition %}
    ;;
  }

  dimension: birthday {
    type: string
    sql: ${TABLE}."Birthday" ;;
  }
  filter: filter_birthday {
    type: date
    suggest_dimension: birthday
  }

  dimension: customer_city {
    type: string
    sql: ${TABLE}."Customer_City" ;;
  }

  dimension: customer_id {
    type: number
    sql: ${TABLE}."Customer_ID" ;;
  }

  dimension: customer_prefecture {
    type: string
    sql: ${TABLE}."Customer_Prefecture" ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}."Gender" ;;
  }

  dimension: member_registration_date {
    type: string
    sql: ${TABLE}."Member_Registration_Date" ;;
  }

  dimension: number_of_members {
    type: number
    sql: ${TABLE}."Number_of_Members" ;;
  }
  measure: count {
    type: count
  }

  measure:  member_amont {
    type:  sum
    label: "会計会員数"
    sql:  abs(${TABLE}."Number_of_Menbers") ;;
  }

  measure:  male_members{
    type:  sum
    label: "男性会員数"
    sql:  CASE WHEN ${TABLE}."GENDER" = "男性" THEN ${TABLE}."NUMBER_of_Members" ELSE 0 END ;;
  }

  measure:  female_members{
    type:  sum
    label: "女性会員数"
    sql:  CASE WHEN ${TABLE}."GENDER" = "女性" THEN ${TABLE}."NUMBER_of_Members" ELSE 0 END ;;
  }
}
