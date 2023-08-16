-- DEX stat: unique users
select  count(distinct swap_user)  as unique_users, count(distinct msg_id)  from redoubt.dex_swaps

-- Dex stat: Total TVL
select sum(tvl_ton) from redoubt.dex_tvl_current

-- Dex stat: active tokens
select count(distinct address) from redoubt.jettons_market_data where build_time > now() - interval '1  month'
and market_volume_ton > 1000

-- DEX stat: unique users overall and swaps per user
select  platform, count(distinct swap_user)  as unique_users,
1.0 * count(distinct msg_id) /  count(distinct swap_user)  as swaps_per_user from redoubt.dex_swaps
group by 1

-- Dex stat: active tokens

select  platform, count(distinct swap_user)  as unique_users,
1.0 * count(distinct msg_id) /  count(distinct swap_user)  as swaps_per_user from redoubt.dex_swaps
group by 1

-- DEX stat: WAU by platforms
select  platform, date_trunc('week', swap_time::date) as month, count(distinct swap_user)  as unique_users from redoubt.dex_swaps
group by 1, 2

-- DEX stat: new users weekly
with first_engagement as (
  select  platform, swap_user, min(swap_time::date) as first_swap from redoubt.dex_swaps
  group by 1, 2
)
select platform, date_trunc('week', first_swap) as date, count(distinct swap_user) as new_users
from first_engagement
group by 1, 2


-- DEX stat: number of DEXes user by user

with users_stat as (
  select  swap_user,count(distinct platform) as platforms_count from redoubt.dex_swaps
  group by 1
)
select platforms_count, count(distinct swap_user) as users_count
from users_stat
group by 1


