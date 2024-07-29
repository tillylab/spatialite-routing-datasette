-- extract start node position from the road containing it
WITH
    start_node AS (
        SELECT
            Transform (
                CASE
                    WHEN node_from = Cast(:node_id AS INTEGER) THEN ST_StartPoint (roads.geom)
                    ELSE ST_EndPoint (roads.geom)
                END,
                4326
            ) AS geometry,
            :node_id as title,
            "#a33a" AS "marker-color",
            "" AS stroke,
            0 AS distance,
            0 AS Cost
        FROM
            roads
        WHERE
            node_from = Cast(:node_id AS INTEGER)
            OR node_to = Cast(:node_id AS INTEGER)
        LIMIT
            1
    ), 
    -- target nodes are all nodes that are less than the walking cost away
    target_nodes AS (
        SELECT
            NodeTo,
            NodeFrom,
            Cost
        FROM
            byfoot
        WHERE
            NodeFrom = Cast(:node_id AS INTEGER)
            AND Cost <= Cast(:distance AS REAL)
    ),
    -- find all roads that belong to the target nodes, and compute their euclidean distance
    roads_to_targets AS (
        SELECT
            Transform (roads.geom, 4326) AS geometry,
            roads.node_from || " - " || roads.node_to AS title,
            "" AS "marker-color",
            -- alternate colors every 1000 meters
            colorbrewer (
                "Dark2",
                5,
                CAST(Mod(target_nodes.Cost / 1000.0, 5) AS INT)
            ) AS stroke,
            -- get the distance of the road end that is further away
            Max(
                ST_Distance (
                    Transform (ST_EndPoint (roads.geom), 4326),
                    start_node.geometry,
                    1
                ),
                ST_Distance (
                    Transform (ST_StartPoint (roads.geom), 4326),
                    start_node.geometry,
                    1
                )
            ) AS distance,
            target_nodes.Cost AS cost
        FROM
            -- make sure the roads are indexed by node_to and node_from !
            roads
            JOIN target_nodes ON (
                roads.node_to = target_nodes.NodeTo
                OR roads.node_from = target_nodes.NodeTo
            ),
            start_node
    ) 
-- now get the start node
SELECT
    *
FROM
    start_node
UNION ALL
-- and the 1000 roads with the highest cost
SELECT
    *
FROM
    roads_to_targets
ORDER BY
    cost DESC
LIMIT
    1000