/* 
    Cleaning Data using SQL
*/


-- Before we begin, let's take a look at the data and make sure it was imported correctly. 
Select *
From PortfolioProjects.dbo.NashvilleHousing



-- 1. Populate Poperty Address Data
Select *
From PortfolioProjects.dbo.NashvilleHousing
Order by ParcelID

/* After taking a look at the data, we can see that there are some addresses with null values.
However, we can locate the missing addresses with the ParcelID since they never change.
We will also add a new column with the addresses substituted in for the null values.*/

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
    ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProjects.dbo.NashvilleHousing a
JOIN PortfolioProjects.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

/* Now lets update our table so we no longer have any NULL addresses. */ 

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProjects.dbo.NashvilleHousing a
JOIN PortfolioProjects.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




-- 2. Splitting up PropertyAddress into Individual Columns (Address, City)
Select PropertyAddress
From PortfolioProjects.dbo.NashvilleHousing

/* We can see that in the PropertyAddress column we have a street address and the name of the city
separated by a comma. Below we will use SUBSTRING to "break up" the column where the comma is. */

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
From PortfolioProjects.dbo.NashvilleHousing

/* Now we will update our table with the two new columns. */

ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
Add PropertyStreetAddress Nvarchar(255);

Update PortfolioProjects.dbo.NashvilleHousing
SET PropertyStreetAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
Add PropertyCity Nvarchar(255);

Update PortfolioProjects.dbo.NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




-- 3. Splitting up OwnerAddress into Individual Columns (Address, City, State)

/* In order to split up the OwnerAddress column we can also use PARSENAME. However, PARSENAME looks
for periods, and we have commas, so we also used REPLACE to have it split at the commas.
We will then add the new columns to our table. */

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProjects.dbo.NashvilleHousing

ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
Add OwnerStreetAddress Nvarchar(255),
    OwnerCity Nvarchar(255),
    OwnerState Nvarchar(255);

Update PortfolioProjects.dbo.NashvilleHousing
SET OwnerStreetAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
    OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
    OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)




-- 4. Change Y and N to Yes and No in SoldAsVacant column 

/* First we will take a look and see how many time each entry (Y, N, Yes, No) occurs. 
We will then use a CASE statement to change Y to Yes and N to No. 
Then we will update the SoldAsVacant column in our table. */ 

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProjects.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProjects.dbo.NashvilleHousing

Update PortfolioProjects.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



-- 5. Removing duplicates using CTE 

/* We will remove the duplicate entries by using ROW_NUMBER and partioning by the columns that would be the same if there
are any duplicates. We will also use a CTE and then delete those rows that are duplicates. */
WITH DuplicatesCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
		     PropertyAddress,
		     SalePrice,
		     SaleDate,
		     LegalReference
		ORDER BY
		     UniqueID
		     ) AS Count
From PortfolioProjects.dbo.NashvilleHousing
)
DELETE
From DuplicatesCTE
Where Count > 1



-- 6. Removing unused columns

/* Now let's remove the columns we no longer need. */ 

ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict 




