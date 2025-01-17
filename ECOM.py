#!/usr/bin/env python
# coding: utf-8

# In[2]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

customers=pd.read_csv('customers.csv')
orders=pd.read_csv('orders.csv')
products=pd.read_csv('products.csv')
reviews=pd.read_csv('reviews.csv')


print(customers.head())
print(orders.head())
print(products.head())
print(reviews.head())


# In[3]:


print(customers.info())
print(orders.info())
print(products.info())
print(reviews.info())


# In[4]:


print(customers.describe())
print(orders.describe())
print(products.describe())
print(reviews.describe())


# In[5]:


print("The null in customer")
print(customers.isnull().sum())
print("The null in order")
print(orders.isnull().sum())
print("The null in review")
print(reviews.isnull().sum())
print("The null in product")
print(products.isnull().sum())


# In[6]:


products.isnull().sum()
products['ProductName'].fillna(method='ffill', inplace=True)


# In[7]:


print("The Duplicate records in customer")
print(customers.duplicated().sum())
print("The Duplicate records in order")
print(orders.duplicated().sum())
print("The Duplicate records in review")
print(reviews.duplicated().sum())
print("The Duplicate records in product")
print(products.duplicated().sum())


# In[34]:


Totalsale_product=orders.groupby('ProductID') ['TotalAmount'].sum().sort_values(ascending=False)
print(Totalsale_product)

Totalsale_product.head(10).plot(kind='bar',color='green',figsize=(3,3))
plt.title('Total Sale By Product')
plt.grid()
plt.show()


# In[9]:


merged_saleproduct = pd.merge(Totalsale_product,products, on='ProductID',how='left')
merged_saleproduct.head(10)


# In[36]:


Category_totalsale=merged_saleproduct.groupby('Category') ['TotalAmount'].sum().sort_values(ascending=False)
print(Category_totalsale)
Category_totalsale.plot(kind='pie',title='Category Wise Total Sale', autopct='%1.2f%%', figsize=(3,3))
plt.ylabel("")
plt.show()


# In[11]:


Merge_customerorder=pd.merge(customers,orders,on='CustomerID', how='inner')
print(Merge_customerorder)


# In[12]:


order_product=pd.merge(orders,products,on='ProductID',how='left')
order_product.head()


# In[13]:


merged=pd.merge(order_product,customers,on='CustomerID',how='left')
merged.head()


# In[14]:


pivot=Merge_customerorder.pivot_table(index='Country', values='TotalAmount',columns='PaymentMethod', aggfunc='sum')
pivot.head(10)


# In[18]:


pivot2=merged.pivot_table(index=['Country','ProductName'],values='TotalAmount',columns= 'Category',aggfunc='sum')
pivot2.head(20)


# In[32]:


Country_Totalsale=Merge_customerorder.groupby('Country') ['TotalAmount'].sum().sort_values(ascending=False)
Country_Totalsale.head(10)
Country_Totalsale.head(10).plot(kind='bar',color='blue',figsize=(4,4))
plt.title('Country Wise Total Sale')
plt.show()


# In[29]:


Customer_Spend=Merge_customerorder.groupby('CustomerID') ['TotalAmount'].sum().sort_values(ascending=False)
Customer_Spend.head(10)
Customer_Spend.head(10).plot(kind='line',color='blue', figsize=(3,3))
plt.title('Top 10 Customer by Total Spend')
plt.grid()
plt.show()


# In[25]:


Gender_Spend=Merge_customerorder.groupby('Gender') ['TotalAmount'].sum().sort_values(ascending=False)
Gender_Spend.head()
Gender_Spend.plot(kind='bar',color='green',figsize=(3,3))
plt.title('Gender wise Total Spend')
plt.grid()
plt.show()


# In[29]:


Avg_Ratting=reviews.groupby('ProductID') ['Rating'].mean()
print(Avg_Ratting)


# In[32]:


product_performance=orders.merge(Avg_Ratting, on='ProductID',how='left')
product_performance.head()


# In[27]:


order_count=orders["Status"].value_counts()
print(order_count)

order_count.plot(kind='bar' , figsize = (3,3))
plt.title('Order Status Counts')
plt.grid()
plt.show()


# In[35]:


Payment_count=orders['PaymentMethod'].value_counts()
print(Payment_count)

Payment_count.plot(kind='pie',autopct='%1.2f%%', figsize=(3,3))
plt.title('Payment Mode Counts')
plt.ylabel('')
plt.show()


# In[ ]:




