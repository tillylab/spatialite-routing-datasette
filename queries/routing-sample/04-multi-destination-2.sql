SELECT
    Transform (Geometry, 4326) AS geometry,
    "#000" AS stroke,
    4 AS "stroke-width",
    0.4 AS "stroke-opacity",
    NULL AS "marker-color",
    *
FROM
    byfoot
WHERE
    NodeFrom = 178731
    AND NodeTo = '183286,290458,181999,184030,124622,183882,178754'
UNION ALL
SELECT
    StartPoint (Transform (Geometry, 4326)) AS geometry,
    "#000" AS stroke,
    NULL AS "stroke-width",
    NULL AS "stroke-opacity",
    "#3a33" AS "marker-color",
    *
FROM
    byfoot2
WHERE
    NodeFrom = 178731
    AND NodeTo = '183286,290458,181999,184030,124622,183882,178754'
UNION ALL
SELECT
    EndPoint (Transform (Geometry, 4326)) AS geometry,
    "#0006" AS stroke,
    NULL AS "stroke-width",
    NULL AS "stroke-opacity",
    "#a338" AS "marker-color",
    *
FROM
    byfoot3
WHERE
    NodeFrom = 178731
    AND NodeTo = '183286,290458,181999,184030,124622,183882,178754'