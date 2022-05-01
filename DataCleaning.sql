-- Cleaning Data in SQL Queries 
Select*
From PortifolioProject..NashivilleHousing

-- Standard Date Format 
Select SaleDatedConv , CONVERT(Date, SaleDate)
From PortifolioProject..NashivilleHousing

Update NashivilleHousing
SET SaleDate = CONVERT(Date, SaleDate) 

ALTER TABLE NashivilleHousing
Add SaleDatedConv Date;

Update NashivilleHousing
SET SaleDatedConv = CONVERT(Date, SaleDate) 

-- Property Address data popotating 

select*
From PortifolioProject..NashivilleHousing
--where PropertyAddress is null
order by ParcelID


-- self join 
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortifolioProject..NashivilleHousing a
JOIN PortifolioProject..NashivilleHousing b
  On a.ParcelID = b.ParcelID
  and a.[UniqueID ]<> b.[UniqueID ] -- not same the row 
  where a.PropertyAddress is null

  Update a
  SET PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
  From PortifolioProject..NashivilleHousing a
JOIN PortifolioProject..NashivilleHousing b
  On a.ParcelID = b.ParcelID
  and a.[UniqueID ]<> b.[UniqueID ] -- not same the row 
  where a.PropertyAddress is null

  -- Address into individual columns 

  select PropertyAddress
  From PortifolioProject..NashivilleHousing

  Select 
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress)-1) as Address
  , SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress)) as Address
  From PortifolioProject..NashivilleHousing

--
ALTER TABLE NashivilleHousing
Add PropertySplitAddress nvarchar(225);

Update NashivilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress)-1) 


ALTER TABLE NashivilleHousing
Add PropertySplitCity nvarchar(225);

Update NashivilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress))

select*
From PortifolioProject..NashivilleHousing



-- owner address split, the easier way  
select OwnerAddress
From PortifolioProject..NashivilleHousing

select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From PortifolioProject..NashivilleHousing


ALTER TABLE NashivilleHousing
Add OwnerSplitAddress nvarchar(225);

Update NashivilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashivilleHousing
Add OwnerSplitCity nvarchar(225);

Update NashivilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashivilleHousing
Add OwnerSplitState nvarchar(225);

Update NashivilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


select*
From PortifolioProject..NashivilleHousing

-- change y and n to yes and no 
select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortifolioProject..NashivilleHousing
group by SoldAsVacant
order by 2


select  SoldAsVacant,
case when SoldAsVacant = 'Y' THEN 'Yes'
     when SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
From PortifolioProject..NashivilleHousing


Update NashivilleHousing
SET SoldAsVacant = case when SoldAsVacant = 'Y' THEN 'Yes'
     when SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END

	 -- remove deplicates 
WITH RowNumCTE AS(
select* ,
ROW_NUMBER() OVER(
PARTITION BY ParcelID,
             PropertyAddress, 
             SalePrice, 
			 SaleDate,
			 LegalReference
			 ORDER BY 
			 UniqueID
			 ) row_num

From PortifolioProject..NashivilleHousing
--order by ParcelID
)

select* -- delete ,  got rid of  duplicates-- used  CTE not on raw data
From RowNumCTE
Where row_num> 1
order by PropertyAddress



-- Delete unused columns 
select*
From PortifolioProject..NashivilleHousing

ALTER TABLE PortifolioProject..NashivilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortifolioProject..NashivilleHousing
DROP COLUMN SaleDate