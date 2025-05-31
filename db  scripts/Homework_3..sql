select *
from public.google_ads_basic_daily gabd ;

select *
from public.facebook_ads_basic_daily fabd ;

select *
from facebook_adset

select *
from facebook_campaign

with ads_data as (
	select 
		fabd.ad_date,
		'Facebook Ads' as media_source,
		fabd.spend,
		fabd.impressions,
		fabd.reach,
		fabd.clicks,
		fabd.leads,
		fabd.value 
from public.facebook_ads_basic_daily fabd -- дані з таблиці facebook 
union                                     -- об'єднуємо
	select                                -- з даними таблиці google
		gabd.ad_date,
		'Google Ads' as media_source,
		gabd.spend,
		gabd.impressions,
		gabd.reach,
		gabd.clicks,
		gabd.leads,
		gabd.value 
from public.google_ads_basic_daily gabd 
)
SELECT                                    -- агрегуємо та додаємо метрики
	ad_date, 
	media_source,
	SUM(adsd.spend) as  total_spend,               -- загальна сума витрат 
	SUM(adsd.impressions) as total_impressions,    -- кількість показів
	SUM(adsd.clicks) as total_clicks,              -- кількість кліків
	SUM(adsd.leads)  as total_leads,               -- кількість лідів
	Sum(adsd.value) as total_value,                -- загальний Value конверсій
	-- метрики рекламних стратегій
	ROUND((SUM(adsd.spend :: float ) / NULLIF(SUM(adsd.impressions), 0) * 1000) :: numeric, 2) || ' $' as CPM,
	ROUND(((SUM(adsd.clicks :: float ) / NULLIF(SUM(adsd.impressions), 0)) * 100) :: numeric, 2) || ' %' as CTR,
	(SUM(adsd.spend) / NULLIF(SUM(adsd.clicks), 0)) || ' $' as CPC,
	(SUM(adsd.spend) / NULLIF(SUM(adsd.leads), 0)) || ' $' as CPL,
	-- метрики ефективності
    ROUND(((SUM(adsd.value::numeric) - SUM(adsd.spend::numeric)) / NULLIF(SUM(adsd.spend::numeric), 0)) * 100, 1) || ' %'AS ROI,
    -- ROAS представлений нижче як кратне значення, тобто скільки повертається на кожний витрачений долар 
    (SUM(adsd.value::float) / NULLIF(SUM(adsd.spend::numeric), 0)) as  ROAS,
    -- а ROMI показано у відсотках
    ROUND(((SUM(adsd.value) - SUM(adsd.spend::numeric)) / NULLIF(SUM(adsd.spend), 0)) * 100, 1) || ' %' AS ROMI
from ads_data adsd
group by ad_date, media_source 
order  by ad_date, media_source ;



		
		
		
