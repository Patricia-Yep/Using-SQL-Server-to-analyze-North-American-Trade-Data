--Trade Data for North America produced by Bureau of Transportation Data in the USA
-- Consist of data for the Month of November 2024
-- Consist 14 columns	 
		--TRDTYPE(import/export),  
		--USASTATE,
		--COMMODITY2(type of material traded),
		--MODE(how material transported)
		--MEXSTATE,
		--CANPROV,
		--COUNTRY
		--VALUE,
		--SHIPWT,
		--FREIGHT_CHARGES,
		--MADE (material to be trade was made domestically in USA or foreign made),
		--Month,
		--Year,
		--CONTCODE (shipment in container?)
-- In column TRDTYPE, Import refers to imports the US receives from Canada and Mexico.  Export refers to trade going to Canada and Mexico.
--

select*
from dbo.NA_Trade_Data

--cleaning table
--changed arbitary province code to standard Provincial abbreviations

--create province table to hold standard Provincial Abbreviations
create table Provinces (
Province varchar(50),
Code varchar(2)
);

insert into Provinces (Province, Code) 
	values
	('AB', 'XA '),
	('BC', 'XC '),
	('MB', 'XM '),
	('NB', 'XB '),
	('NFL', 'XW '),
	('NWT', 'XT '),
	('NS', 'XN '),
	('ON', 'XO '),
	('PEI', 'XP '),
	('QUE', 'XQ '),
	('SK', 'XS '),
	('NUV', 'XV '),
	('YT', 'XY '),
	('Unknown', 'OT ');

--updated dot2_1124 table with 2 letter province code using Province_Table as template
update dbo.NA_Trade_Data
set CANPROV = p.Province
from dbo.dot2_1124 as d
join Provinces as p on d.CANPROV = p.Code;

--updated numbered code for Mexico and Canada with name of country
update dbo.NA_Trade_Data
set COUNTRY = 'CAN'
WHERE COUNTRY = 1220;

update dbo.NA_Trade_Data
set COUNTRY = 'MEX'
WHERE COUNTRY = '2010';

--renamed columns to MODE and CONTAINER
EXEC sp_rename 'dbo.NA_Trade_Data.DISAGMOT', 'MODE', 'COLUMN'

EXEC sp_rename 'dbo.NA_Trade_Data.CONTCODE', 'CONTAINER', 'COLUMN'


--***Analyses***

--Total trade value by Country
--Canada and Mexico exported more to USA than the other way around
select Country, TRDTYPE, sum(Value) as valuebyCountry
from dbo.NA_Trade_Data
group by Country, TRDTYPE
order by TRDTYPE desc;

--what is the most traded products  
select Commodity2, count(*)as countCommodity
from dbo.NA_Trade_Data
group by COMMODITY2
order by countCommodity desc;

--what is the most traded products by value  
select Commodity2, sum(VALUE)as CommodityValue
from dbo.NA_Trade_Data
group by COMMODITY2
order by CommodityValue desc;

--Breakdown of commodity traded by Value
--Mexico exported the most vehicles to the USA
--Canada exported the most minerals to the USA
--USA's biggest export to Mexico is machinery at $4.4B and to Canada it is nuclear reactor boilers at $3.8B
select COMMODITY2, TRDTYPE, COUNTRY, sum(VALUE) as CommodityValue
from dbo.NA_Trade_Data
group by COMMODITY2, TRDTYPE, COUNTRY
order by CommodityValue desc;



--which province has the most trade with USA?
--Alberta exports 7.3B in mineral oil/fuel to US
--Ontario receives the highest exports from USA.  US exports 3.02B Provisions to Ontario
select commodity2, CANPROV, TRDTYPE, sum(Value) as provinceValue
from dbo.NA_Trade_Data
where Country = 'CAN'
group by COMMODITY2, CANPROV, TRDTYPE
order by provinceValue desc;

--Top export/import item and value for each province in Canada
WITH ProvinceTrade AS
(
    SELECT
        Commodity2,
        CANPROV,
        TRDTYPE,
        SUM(Value) AS ProvinceValue
    FROM dbo.NA_Trade_Data
    WHERE Country = 'CAN'
    GROUP BY
        Commodity2,
        CANPROV,
        TRDTYPE
),
RankedTrade AS
(
    SELECT
        Commodity2,
        CANPROV,
        TRDTYPE,
        ProvinceValue,
        ROW_NUMBER() OVER
        (
            PARTITION BY CANPROV, TRDTYPE
            ORDER BY ProvinceValue DESC
        ) AS rn
    FROM ProvinceTrade
)
SELECT
    Commodity2,
    CANPROV,
    TRDTYPE,
    ProvinceValue
FROM RankedTrade
WHERE rn = 1
ORDER BY CANPROV, TRDTYPE;

