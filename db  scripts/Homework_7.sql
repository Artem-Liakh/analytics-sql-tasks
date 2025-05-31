
CREATE OR REPLACE FUNCTION tmp_url_decode(input text) 
RETURNS text LANGUAGE plpgsql IMMUTABLE STRICT AS $$
DECLARE
    bin bytea = '';
    byte text;
BEGIN
    FOR byte IN (SELECT (regexp_matches(input, '(%..|.)', 'g'))[1]) LOOP
        IF length(byte) = 3 THEN
            bin = bin || decode(substring(byte, 2, 2), 'hex');
        ELSE
            bin = bin || byte::bytea;
        END IF;
    END LOOP;
    RETURN convert_from(bin, 'utf8');
END
$$;

WITH unionoffour AS (
    SELECT 
        COALESCE(fabd.ad_date, gabd.ad_date) AS ad_date, 
        COALESCE(fabd.spend, 0) AS spend,
        COALESCE(fabd.impressions, 0) AS impressions,
        COALESCE(fabd.reach, 0) AS reach,
        COALESCE(fabd.clicks, 0) AS clicks,
        COALESCE(fabd.leads, 0) AS leads,
        COALESCE(fabd.value, 0) AS value,
        tmp_url_decode(COALESCE(fabd.url_parameters, gabd.url_parameters)) AS decoded_url_parameters
    FROM 
        public.facebook_ads_basic_daily fabd 
        LEFT JOIN public.facebook_campaign cam ON cam.campaign_id = fabd.campaign_id 
        LEFT JOIN public.facebook_adset ads ON ads.adset_id = fabd.adset_id 
        FULL JOIN public.google_ads_basic_daily gabd ON fabd.ad_date = gabd.ad_date
),
campaign_data AS (
    SELECT 
        ad_date,
        LOWER(
            CASE 
                WHEN regexp_match(decoded_url_parameters, 'utm_campaign=([^&]+)')::text[] IS NULL THEN NULL
                WHEN regexp_match(decoded_url_parameters, 'utm_campaign=([^&]+)')::text[] = ARRAY['nan'] THEN NULL
                ELSE (regexp_match(decoded_url_parameters, 'utm_campaign=([^&]+)'))[1]
            END
        ) AS utm_campaign,
        spend,
        impressions,
        clicks,
        value,
        CASE 
            WHEN impressions = 0 THEN 0
            ELSE (clicks::float / impressions) * 100
        END AS CTR,
        CASE 
            WHEN clicks = 0 THEN 0
            ELSE spend / clicks
        END AS CPC,
        CASE 
            WHEN impressions = 0 THEN 0
            ELSE spend::float / impressions * 1000
        END AS CPM,
        CASE 
            WHEN spend = 0 THEN 0
            ELSE (value - spend::numeric) / spend * 100
        END AS ROMI
    FROM unionoffour
),
monthly_data AS (
    SELECT
        DATE_TRUNC('month', ad_date) AS ad_month,
        utm_campaign,
        SUM(spend) AS total_spend,
        SUM(impressions) AS total_impressions,
        SUM(clicks) AS total_clicks,
        SUM(value) AS total_value,
        CASE 
            WHEN SUM(impressions) = 0 THEN 0
            ELSE (SUM(clicks)::float / SUM(impressions)) * 100
        END AS CTR,
        CASE 
            WHEN SUM(clicks) = 0 THEN 0
            ELSE SUM(spend) / SUM(clicks)
        END AS CPC,
        CASE 
            WHEN SUM(impressions) = 0 THEN 0
            ELSE SUM(spend)::float / SUM(impressions) * 1000
        END AS CPM,
        CASE 
            WHEN SUM(spend) = 0 THEN 0
            ELSE (SUM(value) - SUM(spend)::numeric) / SUM(spend) * 100
        END AS ROMI
    FROM campaign_data
    GROUP BY DATE_TRUNC('month', ad_date), utm_campaign
),
monthly_comparison AS (
    SELECT
        ad_month,
        utm_campaign,
        total_spend,
        total_impressions,
        total_clicks,
        total_value,
        CTR,
        CPC,
        CPM,
        ROMI,
        CASE
            WHEN LAG(CPM) OVER (PARTITION BY utm_campaign ORDER BY ad_month) = 0 OR LAG(CPM) OVER (PARTITION BY utm_campaign ORDER BY ad_month) IS NULL THEN 0
            ELSE ROUND(((CPM - LAG(CPM) OVER (PARTITION BY utm_campaign ORDER BY ad_month)) / LAG(CPM) OVER (PARTITION BY utm_campaign ORDER BY ad_month))::numeric * 100, 2)
        END AS CPM_change,
        CASE
            WHEN LAG(CTR) OVER (PARTITION BY utm_campaign ORDER BY ad_month) = 0 OR LAG(CTR) OVER (PARTITION BY utm_campaign ORDER BY ad_month) IS NULL THEN 0
            ELSE ROUND(((CTR - LAG(CTR) OVER (PARTITION BY utm_campaign ORDER BY ad_month)) / LAG(CTR) OVER (PARTITION BY utm_campaign ORDER BY ad_month))::numeric * 100, 2)
        END AS CTR_change,
        CASE
            WHEN LAG(ROMI) OVER (PARTITION BY utm_campaign ORDER BY ad_month) = 0 OR LAG(ROMI) OVER (PARTITION BY ad_month) IS NULL THEN 0
            ELSE ROUND(((ROMI - LAG(ROMI) OVER (PARTITION BY utm_campaign ORDER BY ad_month)) / LAG(ROMI) OVER (PARTITION BY utm_campaign ORDER BY ad_month))::numeric * 100, 2)
        END AS ROMI_change
    FROM monthly_data
)
SELECT
    ad_month,
    utm_campaign,
    total_spend,
    total_impressions,
    total_clicks,
    total_value,
    CTR,
    CPC,
    CPM,
    ROMI,
    CPM_change,
    CTR_change,
    ROMI_change
FROM monthly_comparison
ORDER BY utm_campaign, ad_month;