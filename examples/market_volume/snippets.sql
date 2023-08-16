-- Market Volume Platforms Overview

SELECT build_time,
       platform,
       sum(market_volume_ton) as volume
FROM redoubt.platforms_market_volume
WHERE build_time > now() - interval '{{ interval }}'
GROUP BY build_time,
         platform
ORDER BY build_time DESC;


-- Market Volume Platforms Distribution

select build_time, platform, sum(market_volume_ton) as volume
from
  ( select build_time, platform, market_volume_ton,
           rank() over (partition by platform
                        order by build_time desc) as rnk
    from redoubt.platforms_market_volume
  ) as t
where rnk = 1
GROUP BY platform, build_time;

-- Market Volume Native Jettons

SELECT build_time,
       symbol,
       active_owners_24,
       total_holders,
       market_volume_ton
FROM redoubt.jettons_market_data
WHERE market_volume_ton>300
  AND symbol NOT LIKE 'o%'
  AND symbol NOT IN ('WTON',
                     'pTON',
                     'jTON',
                     'JTON',
                     'TON')
  AND build_time > now() - interval '{{ interval }}'
ORDER BY build_time DESC,
         symbol ASC;

-- Market Volume Orbit Bridge Jettons

SELECT build_time,
       symbol,
       active_owners_24,
       total_holders,
       market_volume_ton
FROM redoubt.jettons_market_data
WHERE market_volume_ton>300
  AND symbol LIKE 'o%'
  AND build_time > now() - interval '{{ interval }}'
ORDER BY build_time DESC,
         symbol ASC;


