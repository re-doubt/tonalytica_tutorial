-- TVL Platforms Overview
select build_time, platform, sum(tvl_ton) as TVL from redoubt.dex_tvl_history
WHERE build_time > now() - interval '{{ interval }}'
GROUP BY build_time, platform
ORDER BY build_time DESC;

-- TVL Platforms Distribution

select build_time, platform, sum(tvl_ton) as TVL
from
  ( select build_time, platform, tvl_ton,
           rank() over (partition by platform
                        order by build_time desc) as rnk
    from redoubt.dex_tvl_history
  ) as t
where rnk = 1
GROUP BY platform, build_time;


-- TVL Orbit Bridge Jettons, top-10
SELECT jetton,
       sum(tvl_ton)/2 AS tvl
FROM redoubt.dex_tvl_current
CROSS JOIN unnest(array[jetton_a, jetton_b]) AS t(jetton)
WHERE jetton LIKE 'o%'
GROUP BY jetton
HAVING sum(tvl_ton)/2>1000
ORDER BY tvl DESC,
         jetton DESC
LIMIT 10;

-- TVL Native Jettons, top-10

SELECT
  jetton,
  sum(tvl_ton) / 2 AS tvl
FROM
  redoubt.dex_tvl_current
  CROSS JOIN unnest(array [jetton_a, jetton_b]) AS t(jetton)
WHERE
  jetton not LIKE 'o%'
  and jetton not LIKE 'j%'
  and jetton not in ('WTON', 'pTON', 'jTON', 'JTON', 'TON')
GROUP BY
  jetton
HAVING
  sum(tvl_ton) / 2 > 1000
ORDER BY
  tvl DESC,
  jetton DESC
LIMIT
  10;


