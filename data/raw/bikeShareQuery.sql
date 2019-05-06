--getting SF ONLY trip data month by month
select duration_sec, start_time, start_station_id,start_station_name,end_station_id,end_station_name, user_type, bike_share_for_all_trip
from `ieor290-datax-bikeshare.gobike_tripdata.tripdata`
where start_station_id in (select station_id from `ieor290-datax-bikeshare.gobike_tripdata.station_info` where short_name like 'SF%')
and end_station_id in (select station_id from `ieor290-datax-bikeshare.gobike_tripdata.station_info` where short_name like 'SF%' )
and start_time between timestamp('2019-01-01 00:00:00') and timestamp('2019-01-31 23:59:59');

--run analysis on monthly data to determine the usage on weekdays
select count(FORMAT_DATE('%A', DATE(start_time))) AS count,FORMAT_DATE('%A', DATE(start_time)) AS weekday_name_full
from `ieor290-datax-bikeshare.gobike_tripdata.tripdata`
where start_station_id in (select station_id from `ieor290-datax-bikeshare.gobike_tripdata.station_info` where short_name like 'SF%')
and end_station_id in (select station_id from `ieor290-datax-bikeshare.gobike_tripdata.station_info` where short_name like 'SF%' )
and start_time between timestamp('2019-01-01 00:00:00') and timestamp('2019-01-31 23:59:59')
group by FORMAT_DATE('%A', DATE(start_time));

--combine the monthly data with weather data
select *
from
(select Timestamp_TRUNC(t1.start_time, HOUR) rounded_to_hour, t1.*
from
(select duration_sec, start_time, start_station_id,start_station_name,end_station_id,end_station_name, user_type, bike_share_for_all_trip
from `ieor290-datax-bikeshare.gobike_tripdata.tripdata`
where start_station_id in (select station_id from `ieor290-datax-bikeshare.gobike_tripdata.station_info` where short_name like 'SF%')
and end_station_id in (select station_id from `ieor290-datax-bikeshare.gobike_tripdata.station_info` where short_name like 'SF%' )
and start_time between timestamp('2019-01-01 00:00:00') and timestamp('2019-01-31 23:59:59')
)t1) join
(select timestamp_TRUNC(timestamp(t2.trueDateTime), HOUR) rounded_to_hour2,t2.*
from
(SELECT
  FORMAT_TIMESTAMP(
    '%Y-%m-%d %H:%M:%S %Z',
    PARSE_TIMESTAMP('%Y-%m-%d %I:%M %p', dateTime)
  ) AS trueDateTime,temperature, wind, precip_  
FROM (
  select Concat(cast(Date as string),' ', cast(Time as string)) as dateTime,temperature, wind, precip_ from `ieor290-datax-bikeshare.gobike_tripdata.2019_Jan_Hourly_Weather`
))t2) t4 on t4.rounded_to_hour2 = rounded_to_hour


--examine activity vs. windSpeed
select count(t4.wind) as count, t4.wind as windspeed
from
(select Timestamp_TRUNC(t1.start_time, HOUR) rounded_to_hour, t1.*
from
(select duration_sec, start_time, start_station_id,start_station_name,end_station_id,end_station_name, user_type, bike_share_for_all_trip
from `ieor290-datax-bikeshare.gobike_tripdata.tripdata`
where start_station_id in (select station_id from `ieor290-datax-bikeshare.gobike_tripdata.station_info` where short_name like 'SF%')
and end_station_id in (select station_id from `ieor290-datax-bikeshare.gobike_tripdata.station_info` where short_name like 'SF%' )
and start_time between timestamp('2019-01-01 00:00:00') and timestamp('2019-01-31 23:59:59')
)t1) join
(select timestamp_TRUNC(timestamp(t2.trueDateTime), HOUR) rounded_to_hour2,t2.*
from
(SELECT
  FORMAT_TIMESTAMP(
    '%Y-%m-%d %H:%M:%S %Z',
    PARSE_TIMESTAMP('%Y-%m-%d %I:%M %p', dateTime)
  ) AS trueDateTime,temperature, wind, precip_  
FROM (
  select Concat(cast(Date as string),' ', cast(Time as string)) as dateTime,temperature, wind, precip_ from `ieor290-datax-bikeshare.gobike_tripdata.2019_Jan_Hourly_Weather`
))t2) t4 on t4.rounded_to_hour2 = rounded_to_hour
group by t4.wind;

--dry day vs. wet day count
select count(*) as WetDayCount
from
(select Timestamp_TRUNC(t1.start_time, HOUR) rounded_to_hour, t1.*
from
(select duration_sec, start_time, start_station_id,start_station_name,end_station_id,end_station_name, user_type, bike_share_for_all_trip
from `ieor290-datax-bikeshare.gobike_tripdata.tripdata`
where start_station_id in (select station_id from `ieor290-datax-bikeshare.gobike_tripdata.station_info` where short_name like 'SF%')
and end_station_id in (select station_id from `ieor290-datax-bikeshare.gobike_tripdata.station_info` where short_name like 'SF%' )
and start_time between timestamp('2019-01-01 00:00:00') and timestamp('2019-01-31 23:59:59')
)t1) join
(select timestamp_TRUNC(timestamp(t2.trueDateTime), HOUR) rounded_to_hour2,t2.*
from
(SELECT
  FORMAT_TIMESTAMP(
    '%Y-%m-%d %H:%M:%S %Z',
    PARSE_TIMESTAMP('%Y-%m-%d %I:%M %p', dateTime)
  ) AS trueDateTime,temperature, wind, precip_  
FROM (
  select Concat(cast(Date as string),' ', cast(Time as string)) as dateTime,temperature, wind, precip_ from `ieor290-datax-bikeshare.gobike_tripdata.2019_Jan_Hourly_Weather`
))t2) t4 on t4.rounded_to_hour2 = rounded_to_hour
where t4.precip_ not like '0.0%';


--merge stationInfo with stationStatus
select timestamp_seconds(status.last_updated) as lastUpdatedTime, timestamp_seconds(status.last_reported) as LastReportTime, 
status.station_id ,station.name, station.lat,station.lon,station.region_id,station.capacity,
(status.num_bikes_available+status.num_ebikes_available) as totalBikeAvailable, status.num_bikes_disabled,
status.num_docks_available, status.num_docks_disabled,status.is_installed,status.is_renting,status.is_returning,
status.eightd_has_available_keys from `ieor290-datax-bikeshare.gobike_tripdata.station_status` as status
join `ieor290-datax-bikeshare.gobike_tripdata.station_info` as station on status.station_id = station.station_id
order by status.last_updated,status.station_id;

--count of start/end station usage
select count(start_station_id),start_station_id,start_station_name 
from `ieor290-datax-bikeshare.gobike_tripdata.tripdata`
where start_station_id in (select station_id from `ieor290-datax-bikeshare.gobike_tripdata.station_info` where short_name like 'SF%')
and end_station_id in (select station_id from `ieor290-datax-bikeshare.gobike_tripdata.station_info` where short_name like 'SF%' )
and start_time between timestamp('2019-01-01 00:00:00') and timestamp('2019-01-31 23:59:59')
group by start_station_id,start_station_name
order by count(start_station_id) desc;

select count(end_station_id),end_station_id,end_station_name 
from `ieor290-datax-bikeshare.gobike_tripdata.tripdata`
where start_station_id in (select station_id from `ieor290-datax-bikeshare.gobike_tripdata.station_info` where short_name like 'SF%')
and end_station_id in (select station_id from `ieor290-datax-bikeshare.gobike_tripdata.station_info` where short_name like 'SF%' )
and start_time between timestamp('2019-01-01 00:00:00') and timestamp('2019-01-31 23:59:59')
group by end_station_id,end_station_name
order by count(end_station_id) desc;