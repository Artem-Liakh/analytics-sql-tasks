with fb as (           -- перший CTE 
	select 
		 fabd.ad_date, -- дата показу реклами в Facebook
		 cam.campaign_name, -- назва кампанії в Facebook
		 ads.adset_name, --назва набору оголошень в Facebook
		 sum(fabd.spend) as spend,
		 sum(fabd.impressions) as impressions,
		 sum(fabd.reach) as reach,
		 sum(fabd.clicks) as clicks,
		 sum(fabd.leads) as leads,
		 sum(fabd.value) as value 
from public.facebook_ads_basic_daily fabd 
left join public.facebook_campaign cam on cam.campaign_id = fabd.campaign_id 
left join public.facebook_adset ads on ads.adset_id = fabd.adset_id 
group by fabd.ad_date,
	cam.campaign_name,
	ads.adset_name
)
, fbplusg as (            
select 
	'Facebook Ads' as media_source, -- додаємо колонку з назвою джерела
	fb.ad_date,
	fb.campaign_name,
	fb.adset_name,
	fb.spend,
	fb.impressions,
	fb.reach,
	fb.clicks,
	fb.leads,
	fb.value
from fb
union all       -- обʼєднуємо дані з таблиці google_ads_basic_daily та першого CTE (друге CTE)
select
	'Google Ads' as media_source,
	g.ad_date,
	g.campaign_name,
	g.adset_name,
	sum(g.spend) as spend,
    sum(g.impressions) as impressions,
	sum(g.reach) as reach,
	sum(g.clicks) as clicks,
	sum(g.leads) as leads,
	sum(g.value) as value
from public.google_ads_basic_daily g
group by media_source,
	ad_date,
	campaign_name,
	adset_name
)
select                                   -- вибірка з другого CTE
  ad_date,
  media_source,
  campaign_name,
  adset_name,
  SUM(spend) AS total_spend,             -- сумуємо витрпти
  SUM(impressions) AS total_impressions, -- сумуємо покази
  SUM(clicks) AS total_clicks,           -- сумуємо клики
  SUM(value) AS total_value              -- сумуємо конверсійну ціність
FROM fbplusg
GROUP by                                 -- фільтруємо
  ad_date,
  media_source,
  campaign_name,
  adset_name
ORDER by                                 -- сортуємо
  ad_date, campaign_name
 
  ;

 


	