select *
from public.facebook_ads_basic_daily fabd ;

select *
from public.facebook_adset fa ;

select *
from public.facebook_campaign cam ;

select *
from public.google_ads_basic_daily gabd ;

DROP FUNCTION IF EXISTS tmp_url_decode(text);


-- Создаем новую функцию с измененным параметром
CREATE OR REPLACE FUNCTION tmp_url_decode(input text) RETURNS text
LANGUAGE plpgsql IMMUTABLE STRICT AS $$
DECLARE
 bin bytea = '';
 byte text;
BEGIN
 FOR byte IN (select (regexp_matches(input, '(%..|.)', 'g'))[1]) LOOP
   IF length(byte) = 3 THEN
     bin = bin || decode(substring(byte, 2, 2), 'hex');
   ELSE
     bin = bin || byte::bytea;
   END IF;
 END LOOP;
 RETURN convert_from(bin, 'utf8');
END
$$;

WITH unionoffour as (            
	select 
		 coalesce(fabd.ad_date, gabd.ad_date) as ad_date, 
		 coalesce(fabd.url_parameters, gabd.url_parameters) as url_parameters, 
		 coalesce(fabd.spend, 0) as spend,
		 coalesce(fabd.impressions, 0) as impressions,
		 coalesce(fabd.reach, 0) as reach,
		 coalesce(fabd.clicks, 0) as clicks,
		 coalesce(fabd.leads, 0) as leads,
		 coalesce(fabd.value, 0) as value 
from 
    public.facebook_ads_basic_daily fabd 
left join public.facebook_campaign cam on cam.campaign_id = fabd.campaign_id 
left join public.facebook_adset ads on ads.adset_id = fabd.adset_id 
full join  public.google_ads_basic_daily gabd on fabd.ad_date = gabd.ad_date
),
 campaign_data AS (    -- Робимо вибірку зі створеного CTE
    select 
        unionoffour.ad_date,
        LOWER(
            CASE 
                WHEN regexp_match(tmp_url_decode(url_parameters), 'utm_campaign=([^&]+)')::text[] IS NULL THEN NULL
                WHEN regexp_match(tmp_url_decode(url_parameters), 'utm_campaign=([^&]+)')::text[] = ARRAY['nan'] THEN NULL
                ELSE (regexp_match(tmp_url_decode(url_parameters), 'utm_campaign=([^&]+)'))[1]
            END
        ) AS utm_campaign,
        unionoffour.spend,
        unionoffour.impressions,
        unionoffour.clicks,
        unionoffour.value
    FROM unionoffour
)
SELECT 
    campaign_data.ad_date,
    campaign_data.utm_campaign,
    SUM(campaign_data.spend) AS total_spend,
    SUM(campaign_data.impressions) AS total_impressions,
    SUM(campaign_data.clicks) AS total_clicks,
    SUM(campaign_data.value) AS total_value,
    CASE 
        WHEN SUM(campaign_data.impressions) = 0 THEN 0
        ELSE (SUM(campaign_data.clicks :: float ) / SUM(campaign_data.impressions)) * 100
    END AS CTR,
    CASE 
        WHEN SUM(campaign_data.clicks) = 0 THEN 0
        ELSE SUM(campaign_data.spend) / SUM(campaign_data.clicks)
    END AS CPC,
    CASE 
        WHEN SUM(campaign_data.impressions) = 0 THEN 0
        ELSE SUM(campaign_data.spend :: float ) / SUM(campaign_data.impressions) * 1000
    END AS CPM,
    CASE 
        WHEN SUM(campaign_data.spend) = 0 THEN 0
        ELSE (SUM(campaign_data.value) - SUM(campaign_data.spend :: numeric)) / SUM(campaign_data.spend) * 100
    END AS ROMI
FROM 
    campaign_data
GROUP BY 
    ad_date, utm_campaign ;
