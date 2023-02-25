/*

Cleaning Data in SQL Queries

*/

select * from nashvillehousing;

-------------------------------------------------------------------------------

--standardize date format

select saledateconverted,convert(date,saledate)
from nashvillehousing;
 
 update nashvillehousing
 set saledate=convert(date,saledate)

alter table nashvillehousing
add saledateconverted Date;

update nashvillehousing
 set saledateconverted=convert(date,saledate);

------------------------------------------------------------------------------

-- Populate property address data


select *
from nashvillehousing
--where propertyaddress is null
order by parcelid;

select a.parcelid,a.propertyaddress
,b.parcelid,b.propertyaddress,
isnull(a.propertyaddress,b.propertyaddress)
from nashvillehousing a
join nashvillehousing b
on a.parcelid=b.parcelid
and a.[UniqueID ]<>b.[UniqueID ]
where a.propertyaddress is null;

update a
set propertyaddress=isnull(a.propertyaddress,b.propertyaddress)
from nashvillehousing a
join nashvillehousing b
on a.parcelid=b.parcelid
and a.[UniqueID ]<>b.[UniqueID ]
where a.propertyaddress is null;

---------------------------------------------------------------------------------

-- breaking out address into individual columns(address,city,state)


select propertyaddress
from nashvillehousing
--where propertyaddress is null
--order by parcelid;

select SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1) as Address
, SUBSTRING(propertyaddress,charindex(',',propertyaddress)+1,LEN(PROPERTYADDRESS)) as Address
from nashvillehousing


alter table nashvillehousing
add propertysplitaddress nvarchar(255);

update nashvillehousing
 set propertysplitaddress=SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1);


 alter table nashvillehousing
add propertysplitcity nvarchar(255);

update nashvillehousing
 set propertysplitcity=SUBSTRING(propertyaddress
 ,charindex(',',propertyaddress)+1,LEN(PROPERTYADDRESS));

 select owneraddress from nashvillehousing;

 select
 parsename(replace(owneraddress,',','.'),3),
  parsename(replace(owneraddress,',','.'),2),
 parsename(replace(owneraddress,',','.'),1)
from nashvillehousing;


alter table nashvillehousing
add ownersplitaddress nvarchar(255);

update nashvillehousing
 set ownersplitaddress= parsename(replace(owneraddress,',','.'),3);


 alter table nashvillehousing
add ownersplitcity nvarchar(255);

update nashvillehousing
 set ownersplitcity=parsename(replace(owneraddress,',','.'),2);

 alter table nashvillehousing
add ownersplitstate nvarchar(255);

update nashvillehousing
 set ownersplitstate= parsename(replace(owneraddress,',','.'),1);

 select * from nashvillehousing;


 --change Y to yes and N to No in "sold as vacant" field

 select distinct(soldasvacant),count(soldasvacant) from nashvillehousing
 group by soldasvacant
 order by 2;


 select soldasvacant,
 case when soldasvacant='y' then 'Yes'
      when soldasvacant='N' THEN 'No'
	  else soldasvacant
	  end
 from nashvillehousing;



 update nashvillehousing
 set soldasvacant=case 
 when soldasvacant='y' then 'Yes'
      when soldasvacant='N' THEN 'No'
	  else soldasvacant
	  end;




-------------------------------------------------------------------
--Remove Duplicate

with cte as (select *,
row_number() over(
partition by parcelid,propertyaddress,saleprice,saledate,legalreference order by uniqueid)
row_num
from nashvillehousing)


SELECT * from cte where row_num>1;


---------------------------------------------------------------------------------

--DELETE UNUSED COLUMN

 select * from nashvillehousing;


 ALTER TABLE Nashvillehousing
 DROP COLUMN OWNERADDRESS,TAXDISTRICT, PROPERTYADDRESS

 

 ALTER TABLE Nashvillehousing
 DROP COLUMN SALEDATE;