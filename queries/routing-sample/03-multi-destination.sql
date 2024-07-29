WITH
    route_data AS (
        SELECT
            Transform (Geometry, 4326) AS geom_route,
            StartPoint (Transform (Geometry, 4326)) AS geom_start,
            EndPoint (Transform (Geometry, 4326)) AS geom_end,
            *
        FROM
            byfoot
        WHERE
            NodeFrom = 178731
            AND NodeTo = '183286,290458,181999,184030,124622,183882,178754'
    )
SELECT
    ST_Collect (ST_Collect (geom_route, geom_start), geom_end) AS geometry,
    *
FROM
    route_data