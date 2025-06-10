-- 1. Analyze delivery time performance by region
SELECT 
    region,
    AVG(actual_delivery_time - estimated_delivery_time) AS avg_delivery_delay_minutes,
    COUNT(*) AS total_deliveries
FROM 
    deliveries
WHERE 
    delivery_date BETWEEN DATEADD(day, -30, CURRENT_DATE) AND CURRENT_DATE
GROUP BY 
    region
ORDER BY 
    avg_delivery_delay_minutes DESC;

-- 2. ETL: Merge new mapping data into master navigation dataset (example upsert)
MERGE INTO navigation_master AS target
USING navigation_staging AS source
ON target.segment_id = source.segment_id
WHEN MATCHED THEN
    UPDATE SET
        target.road_name = source.road_name,
        target.speed_limit = source.speed_limit,
        target.last_updated = source.last_updated
WHEN NOT MATCHED THEN
    INSERT (segment_id, road_name, speed_limit, last_updated)
    VALUES (source.segment_id, source.road_name, source.speed_limit, source.last_updated);

-- 3. Data Quality Check: Detect null or suspicious values in key mapping attributes
SELECT 
    segment_id,
    road_name,
    speed_limit
FROM 
    navigation_master
WHERE 
    road_name IS NULL
    OR speed_limit IS NULL
    OR speed_limit <= 0;

-- 4. Generate weekly dashboard data for delivery success rate
SELECT
    DATE_TRUNC('week', delivery_date) AS week_start,
    COUNT(*) AS total_deliveries,
    SUM(CASE WHEN delivery_status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_count,
    ROUND(100.0 * SUM(CASE WHEN delivery_status = 'Delivered' THEN 1 ELSE 0 END) / COUNT(*), 2) AS delivered_pct
FROM
    deliveries
GROUP BY
    DATE_TRUNC('week', delivery_date)
ORDER BY
    week_start DESC;

-- 5. Predictive model input: Aggregate features for delivery delays
SELECT
    d.driver_id,
    COUNT(*) AS num_deliveries,
    AVG(actual_delivery_time - estimated_delivery_time) AS avg_delay,
    AVG(distance_km) AS avg_distance
FROM
    deliveries d
JOIN
    drivers dr ON d.driver_id = dr.driver_id
WHERE
    d.delivery_date >= DATEADD(month, -3, CURRENT_DATE)
GROUP BY
    d.driver_id;

-- 6. Example: Tableau/PowerBI-friendly summary for last mile performance by city
SELECT
    city,
    COUNT(*) AS total_deliveries,
    AVG(actual_delivery_time - estimated_delivery_time) AS avg_delay_minutes,
    ROUND(100.0 * SUM(CASE WHEN delivery_status = 'Delivered' THEN 1 ELSE 0 END) / COUNT(*), 2) AS delivered_pct
FROM
    deliveries
GROUP BY
    city
ORDER BY
    avg_delay_minutes DESC;

-- 7. Identify top 10 problematic map segments (by number of routing errors)
SELECT
    segment_id,
    road_name,
    COUNT(*) AS routing_error_count
FROM
    routing_errors
GROUP BY
    segment_id, road_name
ORDER BY
    routing_error_count DESC
LIMIT 10;
