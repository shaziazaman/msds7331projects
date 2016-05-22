create database if not exists airbnb;
use airbnb;
show variables like 'sql_mode';

/* create table listing */
create table if not exists airbnb.listings
(
  id numeric(10)
  , name varchar(100) 
  , host_id numeric(10) 
  , host_name varchar(30) 
  , neighbourhool_group varchar(30) 
  , neighbourhood varchar(30) 
  , latitude double 
  , longitude double 
  , room_type varchar(40) 
  , price float 
  , minimum_nights numeric(5) 
  , reviews_count numeric(8) 
  , last_review date 
  , monthly_review_rate double 
  , calculated_host_listings_count numeric(10) 
  , availability_365 numeric(3) 
  , primary key (id)
);

/* load table listing */
load data local 
infile "C:/Users/shazia/Documents/SMU/DataMining/msds7331projects/data/airbnb/newyork/listings.csv"
into table `airbnb`.`listings`
fields terminated by ',' ENCLOSED BY '"' ESCAPED BY '\\'
lines terminated by '\n'
Ignore 1 lines
(id 
  , name 
  , host_id 
  , host_name 
  , neighbourhool_group 
  , neighbourhood 
  , latitude 
  , longitude 
  , room_type 
  , price 
  , minimum_nights 
  , reviews_count 
  , @last_review
  , monthly_review_rate 
  , calculated_host_listings_count 
  , availability_365 )
  set last_review = str_to_date(@last_review,'%Y-%m-%d')
;

commit;

/* load table calendar */
create table if not exists airbnb.calendar
(
	listing_id numeric(10)
    , calendar_date date
    , available boolean
    , price float 
    );


/* load table calendar */
load data local 
infile "C:/Users/shazia/Documents/SMU/DataMining/msds7331projects/data/airbnb/newyork/calendar.csv"
into table `airbnb`.`calendar`
fields terminated by ',' ENCLOSED BY '"' ESCAPED BY '\\'
lines terminated by '\n'
Ignore 1 lines
(listing_id 
  , @calendar_date 
  , @available 
  , price )
  set 
	calendar_date = str_to_date(@calendar_date,'%Y-%m-%d')
  , available = (@available = 't')
;

commit;

alter table airbnb.calendar add primary key (listing_id, calendar_date);
alter table airbnb.calendar add foreign key (listing_id) references airbnb.listings(id);

/* create table reviews */
create table if not exists airbnb.reviews
(
	listing_id numeric(10)
    , id numeric(10)
    , review_date date
    , reviewer_id numeric(10)
    , reviewer_name varchar(45) 
    , comments blob
);

/* load table reviews */
load data local
infile "C:/Users/shazia/Documents/SMU/DataMining/msds7331projects/data/airbnb/newyork/reviews.csv"
into table `airbnb`.`reviews`
fields terminated by ',' ENCLOSED BY '"' ESCAPED BY '\\'
lines terminated by '\n'
Ignore 1 lines
(listing_id 
  , id
  , @review_date 
  , reviewer_id
  , reviewer_name
  , comments )
  set 
	review_date = str_to_date(@review_date,'%Y-%m-%d')
 ;

commit;
alter table airbnb.reviews add primary key (id);
alter table airbnb.reviews add foreign key (listing_id) references airbnb.listings(id);


