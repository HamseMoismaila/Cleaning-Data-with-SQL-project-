--- CLEANING DATA 


select * from new_project.dbo.table_1

select * from new_project.dbo.table_2

;

--STANDARIZE THE DATE FORMATE 

select saleDateconverted, convert(date, saledateconverted )
from new_project.dbo.table_2 

update 
new_project.dbo.table_2 
set saledate =  convert(date, saledate );


ALTER TABLE new_project.dbo.table_2 -- We just add adate column to make the convertion 
Add saleDateConverted Date;

update 
new_project.dbo.table_2 
set saledateConverted = convert(date, saledate)


--- Populate Property Address

select a.parcelid, a.propertyaddress,b.parcelid, b.propertyaddress,isnull(a.propertyaddress, b.propertyaddress)
from new_project.dbo.table_2 a
 join  new_project.dbo.table_2 b on 
 a.ParcelId = b.parcelid and 
 a.uniqueId <> b.uniqueid 

 where a.propertyaddress is null;


 update a
 set propertyaddress = isnull(a.propertyaddress, b.propertyaddress) 
 from new_project.dbo.table_2 a
 join  new_project.dbo.table_2 b on 
 a.ParcelId = b.parcelid and 
 a.uniqueId <> b.uniqueid 

 where a.propertyaddress is null;


 ---SPLITTING propertyAddress (Adress, city, state)


select * from new_project.dbo.table_2;


select 
SUBSTRING(propertyAddress,1, CHARINDEX(',' ,propertyAddress )-1) as Address , 

SUBSTRING(propertyAddress, CHARINDEX(',' ,propertyAddress )+1, len(propertyAddress)) as City 

from new_project.dbo.table_2;


ALTER TABLE new_project.dbo.table_2   --- Creating New_Column for Address only 
Add propertyAddressSplitted nvarchar(255);

update 
new_project.dbo.table_2 
set propertyAddressSplitted = SUBSTRING(propertyAddress,1, CHARINDEX(',' ,propertyAddress )-1) 



ALTER TABLE new_project.dbo.table_2 
Add propertyNew_City nvarchar(255);

update 
new_project.dbo.table_2 
set propertyNew_City  = SUBSTRING(propertyAddress, CHARINDEX(',' ,propertyAddress )+1, len(propertyAddress)) 






--- EASIER WAY TO SPLIT --

select 
parsename(Replace(owneraddress, ',', '.') ,3) as Address ,
parsename(Replace(owneraddress, ',', '.') ,2) As City ,
parsename(Replace(owneraddress, ',', '.') ,1) As State
from new_project.dbo.table_2;





ALTER TABLE new_project.dbo.table_2   
Add OwnerAddress_New nvarchar(255);

update 
new_project.dbo.table_2 
set OwnerAddress_New = parsename(Replace(owneraddress, ',', '.') ,3)



ALTER TABLE new_project.dbo.table_2 
Add OwnerNew_City nvarchar(255);

update 
new_project.dbo.table_2 
set OwnerNew_City  = parsename(Replace(owneraddress, ',', '.') ,2) 


ALTER TABLE new_project.dbo.table_2 
Add OwnerNew_State nvarchar(255);

update 
new_project.dbo.table_2 
set OwnerNew_State  = parsename(Replace(owneraddress, ',', '.') ,1)

------------------------






----Check for the Soldasvacant column 




Select distinct(soldasvacant), count(soldasvacant)
from  new_project.dbo.table_2 
group by soldasvacant 
order by 2

;

select soldasvacant,
case 
when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N'  then 'NO'
else soldasvacant 
end 
from  new_project.dbo.table_2 ;




update new_project.dbo.table_2
set  soldasvacant =
case 
when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N'  then 'NO'
else soldasvacant 
end 




----------------------------------------------------------------------------------------------------


--REMOVE DUPLICATES





with RowNum_cte as (

select *, Row_Number() over ( partition by landUse, parcelid, propertyaddress,saledate

order by uniqueid ) as Row_name 

from  new_project.dbo.table_2
)

Select *
from   RowNum_cte
where row_name =2 ;

------------------------------------------------------



-- TO DELETE UNUSFUL COLUMNS 





ALTER TABLE  new_project.dbo.table_2 
DROP COLUMN  propertyaddress, saledate,taxdistrict, owneraddress


select * from new_project.dbo.table_2 