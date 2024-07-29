SELECT
    Transform (Geometry, 4326) as geometry,
    "by car" as title,
    "#33a" as stroke,
    8 as "stroke-width",
    0.4 as "stroke-opacity",
    *
FROM
    bycar
WHERE
    NodeFrom = 178731
    AND NodeTo = 183286
UNION ALL
SELECT
    Transform (Geometry, 4326) as geometry,
    "by car (reverse)" as title,
    "#a33" as stroke,
    8 as "stroke-width",
    0.4 as "stroke-opacity",
    *
FROM
    bycar2
WHERE
    NodeFrom = 183286
    AND NodeTo = 178731
UNION ALL
SELECT
    Transform (Geometry, 4326) as geometry,
    "by foot" as title,
    "black" as stroke,
    2 as "stroke-width",
    0.6 as "stroke-opacity",
    *
FROM
    byfoot
WHERE
    NodeFrom = 178731
    AND NodeTo = 183286