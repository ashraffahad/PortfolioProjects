select *
from ProjectPortfolio..NashvilleHousing

-------------------------------------
--standardize date format
Select SaleDateConverted, CONVERT(Date,SaleDate)
from ProjectPortfolio..NashvilleHousing


update NashvilleHousing
set SaleDate=convert(Date,SaleDate) 

Alter Table NashvilleHousing
add SaleDateConverted Date;
update NashvilleHousing
set SaleDateConverted=convert(Date,SaleDate) 


select SaleDateConverted
from ProjectPortfolio..NashvilleHousing

--Populate Property Address Data
select *
from ProjectPortfolio..NashvilleHousing
where PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from ProjectPortfolio..NashvilleHousing as a
Join ProjectPortfolio..NashvilleHousing as b
   on a.ParcelID=b.ParcelID
   and a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from ProjectPortfolio..NashvilleHousing as a
Join ProjectPortfolio..NashvilleHousing as b
   on a.ParcelID=b.ParcelID
   and a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null

--Breaking Address into Address, City and State
select PropertyAddress
from ProjectPortfolio..NashvilleHousing
--where PropertyAddress is null

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress)) as City
from ProjectPortfolio..NashvilleHousing

Alter Table NashvilleHousing
add PropertyAdress nvarchar(250);

update NashvilleHousing
set PropertyAdress=SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) 


Alter Table NashvilleHousing
add PropertyCity nvarchar(250);

update NashvilleHousing
set PropertyCity=SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress))

select OwnerAddress
from ProjectPortfolio..NashvilleHousing


select 
PARSENAME(replace(OwnerAddress,',', '.'), 3), 
PARSENAME(replace(OwnerAddress,',', '.'), 2), 
PARSENAME(replace(OwnerAddress,',', '.'), 1)
from ProjectPortfolio..NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From ProjectPortfolio.dbo.NashvilleHousing

--------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field
select distinct(SoldAsVacant), count(SoldAsVacant)
From ProjectPortfolio.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


select SoldAsVacant
, case When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From ProjectPortfolio.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From ProjectPortfolio.dbo.NashvilleHousing
--order by ParcelID
)
delete 
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From ProjectPortfolio.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


Select *
From PortfolioProject.dbo.NashvilleHousing



-- Delete Unused Columns


Select *
From ProjectPortfolio.dbo.NashvilleHousing


ALTER TABLE ProjectPortfolio.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate