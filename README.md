# Using-SQL-Server-to-analyze-North-American-Trade-Data
Short SQL Server project:  I highlighted some data cleaning and provided analysis of the data.

## Cleaning

The original data was North American trade data for the month of November 2024.  The data was published from the Bureau of Transportation in the USA. Much of the original table used letters or numeric notations and you had to refer to a table to find what the abbreviations represented.  I used a template table to replace the abbreviations with the actual data so it would be easier to understand.  

<img width="473" height="215" alt="image" src="https://github.com/user-attachments/assets/a7e06155-62f5-49a2-920e-a62f661ba90d" />
<img width="482" height="103" alt="image" src="https://github.com/user-attachments/assets/c8625c92-a340-48c4-8be1-77ec571e8e95" />



I also changed the column names so they better reprsent what the contents of the column.

<img width="478" height="76" alt="image" src="https://github.com/user-attachments/assets/1c07883b-1dec-416c-801a-84fcdc20264f" />


## Analysis
These are some of the questions I was trying to answer with the trade data:

What was the overall trade between the US and its neighbours?  Import represents what the US received from Canada and Mexico.  Export represents what the US sent to Canada and US.


<img width="541" height="268" alt="image" src="https://github.com/user-attachments/assets/8cdc357b-de6e-4231-a5ad-8f8b659edbf8" />


What Items has the greatest trade values?  This value included both imported and exported items.

<img width="463" height="347" alt="image" src="https://github.com/user-attachments/assets/3c8c0bb4-e6c9-40bb-9a2e-4a3714074a1f" />


What items gets traded with the US the most by value and which Province is it coming from?

<img width="548" height="410" alt="image" src="https://github.com/user-attachments/assets/8d137f7b-c531-45bf-a1ea-6df593e694f2" />


There are additional queries in the SQL file I added, like what the biggest import and export divided by province.  
Further analyses can be done by breaking down the individual commodities into bigger categories like agricultural goods, natural resources, and manufactured goods.
