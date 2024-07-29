SELECT
    Transform (Geometry, 4326) as geometry,
    *
FROM
    bycar
WHERE
    NodeFrom = 178731
    AND NodeTo = 183286