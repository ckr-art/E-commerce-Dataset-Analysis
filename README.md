# README: E-commerce Dataset Analysis

## **Overview**
This project involves analyzing an e-commerce dataset using Python, SQL, and Power BI. The dataset includes tables for customers, orders, products, and reviews, and provides insights into revenue, customer behavior, product performance, and customer feedback. Below are the detailed steps for data cleaning, analysis, and visualization.

---

## **Dataset Description**
The dataset contains the following tables:

1. **Customers**:
   - CustomerID (Primary Key)
   - Name
   - Email
   - AddressID (Foreign Key)

2. **Orders**:
   - OrderID (Primary Key)
   - CustomerID (Foreign Key)
   - ProductID (Foreign Key)
   - OrderDate
   - Quantity
   - TotalAmount

3. **Products**:
   - ProductID (Primary Key)
   - ProductName
   - Category
   - CostPrice
   - SellingPrice

4. **Reviews**:
   - ReviewID (Primary Key)
   - CustomerID (Foreign Key)
   - ProductID (Foreign Key)
   - Rating
   - ReviewDate
   - Comments

---

## **Analysis Steps**

### **1. Data Cleaning**
#### **Python Code for Cleaning**
```python
import pandas as pd

# Load datasets
customers = pd.read_csv('customers.csv')
orders = pd.read_csv('orders.csv')
products = pd.read_csv('products.csv')
reviews = pd.read_csv('reviews.csv')

# Check for missing values
print(customers.isnull().sum())
print(orders.isnull().sum())
print(products.isnull().sum())
print(reviews.isnull().sum())

# Fill missing values or drop rows if necessary
customers.fillna({'Email': 'unknown@example.com'}, inplace=True)
orders.dropna(subset=['TotalAmount'], inplace=True)

# Merge tables for analysis
merged_data = orders.merge(customers, on='CustomerID')
merged_data = merged_data.merge(products, on='ProductID')
merged_data = merged_data.merge(reviews, on=['CustomerID', 'ProductID'], how='left')

# Save cleaned data
merged_data.to_csv('cleaned_data.csv', index=False)
```

---

### **2. SQL Queries for Analysis**
#### **Query 1: Top 3 Highest Spenders in Each Country**
```sql
SELECT 
    c.Name AS CustomerName, 
    SUM(o.TotalAmount) AS TotalSpending
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.Name
ORDER BY TotalSpending DESC
LIMIT 3;
```

#### **Query 2: Cumulative Sales for Each Product Category Over Time**
```sql
SELECT 
    p.Category, 
    DATE_FORMAT(o.OrderDate, '%Y-%m') AS OrderMonth, 
    SUM(o.TotalAmount) AS MonthlySales, 
    SUM(SUM(o.TotalAmount)) OVER (PARTITION BY p.Category ORDER BY DATE_FORMAT(o.OrderDate, '%Y-%m')) AS CumulativeSales
FROM Orders o
JOIN Products p ON o.ProductID = p.ProductID
GROUP BY p.Category, OrderMonth;
```

#### **Query 3: Average Rating for Each Product**
```sql
SELECT 
    p.ProductName, 
    AVG(r.Rating) AS AverageRating
FROM Reviews r
JOIN Products p ON r.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY AverageRating DESC;
```

---

### **3. Python Analysis**
#### **Python Code for Insights**
```python
# Import libraries
import matplotlib.pyplot as plt
import seaborn as sns

# Monthly Revenue
merged_data['OrderMonth'] = pd.to_datetime(merged_data['OrderDate']).dt.to_period('M')
monthly_revenue = merged_data.groupby('OrderMonth')['TotalAmount'].sum()

# Plot Monthly Revenue
plt.figure(figsize=(10, 6))
monthly_revenue.plot(kind='line', title='Monthly Revenue', color='blue')
plt.xlabel('Month')
plt.ylabel('Revenue')
plt.show()

# Top Products by Revenue
top_products = merged_data.groupby('ProductName')['TotalAmount'].sum().nlargest(10)

# Plot Top Products
plt.figure(figsize=(10, 6))
top_products.plot(kind='bar', title='Top 10 Products by Revenue', color='green')
plt.xlabel('Product')
plt.ylabel('Revenue')
plt.xticks(rotation=45)
plt.show()

# Average Ratings by Product
avg_ratings = merged_data.groupby('ProductName')['Rating'].mean().sort_values(ascending=False)

# Plot Average Ratings
plt.figure(figsize=(10, 6))
avg_ratings.head(10).plot(kind='bar', title='Top 10 Products by Average Rating', color='purple')
plt.xlabel('Product')
plt.ylabel('Average Rating')
plt.xticks(rotation=45)
plt.show()
```

---

### **4. Power BI Dashboard**
#### **Dashboard Features**
1. **Revenue Overview**:
   - KPI cards for Total Revenue, Total Profit, and Average Order Value.
   - Line chart showing monthly revenue trends.

2. **Customer Insights**:
   - Pie chart for customer segmentation (High, Medium, Low Spenders).
   - Table for top 10 customers by spending.

3. **Product Performance**:
   - Bar chart for top 10 products by revenue.
   - Heatmap showing revenue by category and region.

4. **Customer Feedback**:
   - Bar chart for average ratings by product.
   - Word cloud for most common review comments.

5. **Geographic Analysis**:
   - Map visual showing revenue distribution by city.

#### **Steps to Create Dashboard**
1. Import the cleaned dataset (`cleaned_data.csv`) into Power BI.
2. Transform and model the data using Power Query and relationships.
3. Create visuals as described in the features section.
4. Add interactivity with slicers and drill-through pages.
5. Publish the report to Power BI Service and schedule refresh.

---

## **Conclusion**
This project demonstrates end-to-end data analysis and visualization for an e-commerce dataset. It covers data cleaning, SQL querying, Python-based analysis, and advanced Power BI dashboard creation. Use this README as a guide to replicate or extend the analysis.

