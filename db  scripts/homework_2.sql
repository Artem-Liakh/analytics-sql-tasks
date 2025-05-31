

select
	fabd.ad_date,
    fabd.campaign_id,
    SUM(fabd.spend) as total_spend,
    SUM(fabd.impressions) as total_impressions,
    SUM(fabd.clicks) as total_clicks,
    SUM(fabd.value) as total_conversion_value,
-- Розрахунок CPC
case
	when SUM(fabd.clicks) > 0 then SUM(fabd.spend :: float) / SUM(fabd.clicks) 
	end as CPC,
-- Розрахунок CPM
case
	when SUM(fabd.impressions) > 0 then SUM((fabd.spend) * 1000) / SUM(fabd.impressions)
end as CPM,
-- Розрахунок CTR
case
	when SUM(fabd.impressions) > 0 then (SUM(fabd.clicks :: numeric) / SUM(fabd.impressions)) * 100
	else 0
end as CTR,
-- Розрахунок ROMI
case
	when SUM(fabd.spend) > 0 then (SUM(fabd.value :: numeric) / SUM(fabd.spend)) * 100
	else 0
end as ROMI
from public.facebook_ads_basic_daily fabd
where fabd.campaign_id is not null
group by fabd.ad_date,
         fabd.campaign_id ;
        


