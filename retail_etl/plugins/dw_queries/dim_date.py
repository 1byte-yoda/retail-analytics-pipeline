def get_upsert_query():
    return """
    INSERT INTO dim_date(
        d_id,
        d_date,
        d_dayofweek,
        d_month,
        d_year,
        d_monthname,
        d_yearweek,
        d_yearmonth,
        d_quarter,
        d_yearquarter
    )
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
    ON CONFLICT (d_id)
    DO UPDATE SET
        (
            d_date,
            d_dayofweek,
            d_month,
            d_year,
            d_monthname,
            d_yearweek,
            d_yearmonth,
            d_quarter,
            d_yearquarter
        )
        = (
            EXCLUDED.d_date,
            EXCLUDED.d_dayofweek,
            EXCLUDED.d_month,
            EXCLUDED.d_year,
            EXCLUDED.d_monthname,
            EXCLUDED.d_yearweek,
            EXCLUDED.d_yearmonth,
            EXCLUDED.d_quarter,
            EXCLUDED.d_yearquarter
        );
    """


def get_select_query_for_insert():
    return """
        SELECT
             DATE_FORMAT(o.o_orderdate, "%Y%m%d") AS d_id,
             o.o_orderdate AS d_date,
             DAYOFWEEK(o.o_orderdate) AS d_dayofweek,
             MONTH(o.o_orderdate) AS d_month,
             YEAR(o.o_orderdate) AS d_year,
             MONTHNAME(o.o_orderdate) AS d_monthname,
             YEARWEEK(o.o_orderdate) AS d_yearweek,
             DATE_FORMAT(o.o_orderdate, '%Y-%m') AS d_yearmonth,
             CONCAT('Q', QUARTER(o.o_orderdate)) AS d_quarter,
             CONCAT(YEAR(o.o_orderdate), '-Q', QUARTER(o.o_orderdate)) AS d_yearquarter
        FROM orders AS o
        JOIN lineitem AS l ON l.l_orderkey = o.o_orderkey
        GROUP BY d_date

        UNION

        SELECT
             DATE_FORMAT(l.l_commitdate, "%Y%m%d") AS d_id,
             l.l_commitdate AS d_date,
             DAYOFWEEK(l.l_commitdate) AS d_dayofweek,
             MONTH(l.l_commitdate) AS d_month,
             YEAR(l.l_commitdate) AS d_year,
             MONTHNAME(l.l_commitdate) AS d_monthname,
             YEARWEEK(l.l_commitdate) AS d_yearweek,
             DATE_FORMAT(l.l_commitdate, '%Y-%m') AS d_yearmonth,
             CONCAT('Q', QUARTER(l.l_commitdate)) AS d_quarter,
             CONCAT(YEAR(l.l_commitdate), '-Q', QUARTER(l.l_commitdate)) AS d_yearquarter
        FROM orders AS o
        JOIN lineitem AS l ON l.l_orderkey = o.o_orderkey
        GROUP BY d_date

        UNION

        SELECT
             DATE_FORMAT(l.l_receiptdate, "%Y%m%d") AS d_id,
             l.l_receiptdate AS d_date,
             DAYOFWEEK(l.l_receiptdate) AS d_dayofweek,
             MONTH(l.l_receiptdate) AS d_month,
             YEAR(l.l_receiptdate) AS d_year,
             MONTHNAME(l.l_receiptdate) AS d_monthname,
             YEARWEEK(l.l_receiptdate) AS d_yearweek,
             DATE_FORMAT(l.l_receiptdate, '%Y-%m') AS d_yearmonth,
             CONCAT('Q', QUARTER(l.l_receiptdate)) AS d_quarter,
             CONCAT(YEAR(l.l_receiptdate), '-Q', QUARTER(l.l_receiptdate)) AS d_yearquarter
        FROM orders AS o
        JOIN lineitem AS l ON l.l_orderkey = o.o_orderkey
        GROUP BY d_date
    """
