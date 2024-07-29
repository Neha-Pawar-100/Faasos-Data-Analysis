# Faasos-Data-Analysis

OBJECTIVE: The primary objective of this project was to analyze data of Faasos, a popular food delivery company, to gain insights into customer ordering patterns, delivery performance, and overall operational efficiency. The analysis aims to identify key metrics that can help improve service quality, optimize delivery processes, and enhance customer satisfaction.

KEY TABLES AND DATA:
1) Driver Table : Contains information about drivers and their registration date.
2) Ingredients Table : Lists various ingredients used in rolls.
3) Rolls Table : Details the types of rolls offered.
4) Rolls Recipe Table : Maps Roll IDs to ingredients used.
5) Driver Order Table : Provides data on delivery timings, distances, durations, and cancellations.
6) Customer Orders Table : Includes customer orders, roll types, special requests, and order dates.

SCOPE OF ANALYSIS:
1) Order Quantity and Uniqueness : Calculated the total number of rolls ordered and the number of unique customer orders to understand demand and customer engagement.
2) Driver Performance : Analyzed successful deliveries by each driver, average delivery times, and delivery distances to evaluate driver efficiency, and identify areas of improvement.
3) Roll Types : Determined the distribution of various roll types delivered and analyzed the proportion of veg vs non-veg rolls ordered.
4) Order Changes : Investigated orders with exclusions and extras to assess the frequency and impact of changes on order fulfillment.
5) Time and Distance Metrics : Evaluated delivery times, average speed of drivers, and the variance in delivery durations to identify operational bottlenecks.
6) Delivery Patterns : Examined the distribution of orders across different hours of the day and days of the week to identify peak times and optimize staffing.
7) Customer Repeat Rate : Computed proportion of repeat customers, which can be used to assess customer loyalty and customer retention strategies.

KEY INSIGHTS AND FINDINGS:
1) Identified peak ordering hours and days, which can help in adjusting staffing and operational strategies.
2) Revealed the average time drivers take to reach the pickup location, providing insights into potential delays and areas of process improvement.
3) Highlighted the distribution of roll types and frequency of changes requested by customers, aiding in inventory management and customer service enhancement.
4) Identified customer repeat rate which provides insights for developing targeted customer retention strategies, highlighting areas for improving customer loyalty and satisfaction.

DATA CLEANING AND DATA TRANSFORMATION:
1) Handling Null Values and Blank Spaces : Handled null values and blank spaces with "Case Statement" to ensure that the data remains consistent and complete.
2) Standardizing Data Formats : Transforming the "order_date" column into hourly buckets by concatenating the current hour with the next hour and extracting the "day of the week" from the "order_date" column by using the "dayname" function.
3) Converting Data Types : Converted data type using the "Cast" function.
4) Data Aggregation : Aggregated data by using "Count", "Sum" and "Avg" functions for meaningful insights.

SQL TECHNIQUES:
1) Advanced Queries : Used complex queries like CTEs (Common Table Expression), window functions, and conditional aggregations.
2) Query Optimization : Instead of selecting all columns, selected only the required ones for better performance and query optimization.

CONCLUSION: The insight gained from this analysis can be used to enhance operational strategies, optimize delivery routes, and improve customer service. By understanding ordering patterns and driver performance, Faasos can make data-driven decisions to improve overall efficiency and customer satisfaction.

