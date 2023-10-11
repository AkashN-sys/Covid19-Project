/*

Cleaning Data in SQL Queries

*/

/*

Skills used: Data type conversion, Null value treatment, Joins, Window functions, Aggregate functions, CTE etc.

*/

SELECT * FROM portfolio_project.nashville_housing_data;

-- Standardize date format ('January 01,2020' STR.datatype to '01-01-2020' DATE.datatype)
SELECT 
    saleDate
FROM
    nashville_housing_data;

ALTER TABLE nashville_housing_data
ADD COLUMN newSaleDate DATE;

UPDATE nashville_housing_data 
SET 
    newSaleDate = STR_TO_DATE(saleDate, '%M %d, %Y');

ALTER TABLE nashville_housing_data
DROP COLUMN saleDate;

ALTER TABLE nashville_housing_data
CHANGE COLUMN newSaleDate saleDate DATE;

-- Populate the property addresss data
SELECT 
    *
FROM
    nashville_housing_data
WHERE
    propertyAddress = '';

SELECT 
    *
FROM
    nashville_housing_data
ORDER BY parcelID;

SELECT 
    nt.parcelID,
    nt.propertyAddress,
    nt.uniqueID,
    nh.parcelID,
    nh.UniqueID,
    IFNULL(nt.propertyAddress, nh.propertyAddress)
FROM
    nashville_housing_data nt
        JOIN
    nashville_housing_data nh ON nt.ParcelID = nh.ParcelID
        AND nt.uniqueID = nh.uniqueID
WHERE
    nt.propertyAddress = '';

SELECT 
    nt.parcelID,
    CASE
        WHEN
            nt.propertyAddress IS NULL
                OR nt.propertyAddress = ''
        THEN
            nh.propertyAddress
        ELSE nt.propertyAddress
    END alteredaddress,
    nt.uniqueID,
    nh.parcelID,
    nh.UniqueID
FROM
    nashville_housing_data nt
        JOIN
    nashville_housing_data nh ON nt.ParcelID = nh.ParcelID
        AND nt.uniqueID = nh.uniqueID;

UPDATE nashville_housing_data nt
        JOIN
    nashville_housing_data nh ON nt.ParcelID = nh.ParcelID
        AND nt.uniqueID = nh.uniqueID 
SET 
    nt.propertyAddress = CASE
        WHEN
            nt.propertyAddress IS NULL
                OR nt.propertyAddress = ''
        THEN
            nh.propertyAddress
        ELSE nt.propertyAddress
    END;
    
-- breaking out address into individual columns (Address,City,state)
SELECT 
    SUBSTRING_INDEX(PropertyAddress, ',', 1) AS Address,
    SUBSTRING(PropertyAddress,
        LOCATE(',', PropertyAddress) + 2) AS Address2
FROM
    nashville_housing_data;

ALTER TABLE nashville_housing_data 
ADD COLUMN Propertysplitaddress VARCHAR(255);

UPDATE nashville_housing_data 
SET 
    Propertysplitaddress = SUBSTRING_INDEX(PropertyAddress, ',', 1);

ALTER TABLE nashville_housing_data 
ADD COLUMN Propertysplitcity VARCHAR(255);

UPDATE nashville_housing_data 
SET 
    Propertysplitcity = SUBSTRING(PropertyAddress,
        LOCATE(',', PropertyAddress) + 2);

-- breaking out owners address into individual columns (Address,City,state)
  SELECT 
    SUBSTRING_INDEX(OwnerAddress, ',', 1) AS ad1,
    SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2),
            ',',
            - 1) AS ad2,
    SUBSTRING_INDEX(OwnerAddress, ',', - 1) AS ad3
FROM
    nashville_housing_data;

ALTER TABLE nashville_housing_data 
ADD COLUMN owneraddresssplit VARCHAR(255);

UPDATE nashville_housing_data 
SET 
    owneraddresssplit = SUBSTRING_INDEX(OwnerAddress, ',', 1);

ALTER TABLE nashville_housing_data 
ADD COLUMN ownercity VARCHAR(255);

UPDATE nashville_housing_data 
SET 
    ownercity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2),
            ',',
            - 1);

ALTER TABLE nashville_housing_data 
ADD COLUMN ownercountry VARCHAR(255);

UPDATE nashville_housing_data 
SET 
    ownercountry = SUBSTRING_INDEX(OwnerAddress, ',', - 1);


-- changing the 'Y' and 'N' to "Yes" and "No" in the sold as vacant column

SELECT DISTINCT
    SoldAsVacant, COUNT(SoldAsVacant)
FROM
    nashville_housing_data
GROUP BY SoldAsVacant;

SELECT 
    CASE
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END
FROM
    nashville_housing_data;

UPDATE nashville_housing_data 
SET 
    SoldAsVacant = CASE
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        WHEN SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
    END;

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

From  nashville_housing_data
-- order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress;



SELECT 
    *
FROM
    nashville_housing_data;

-- Delete Unused columns
SELECT 
    *
FROM
    nashville_housing_data;

ALTER TABLE nashville_housing_data
DROP COLUMN OwnerAddress;

ALTER TABLE nashville_housing_data
DROP COLUMN TaxDistrict;

ALTER TABLE nashville_housing_data
DROP COLUMN SaleDate;