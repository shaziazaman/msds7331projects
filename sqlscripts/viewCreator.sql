use airbnb;

create or replace view airbnb.listings_v as select * from airbnb.listings where price <= 2000;

commit;