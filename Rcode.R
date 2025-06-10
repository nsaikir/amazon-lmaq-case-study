# R code for a Business Analyst, Last Mile Analytics & Quality position at Amazon

# Load required libraries
library(DBI)
library(RPostgres)      # Assume Redshift/Postgres database
library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)
library(data.table)
library(readr)

# ---- 1. Connect to Amazon Redshift/Postgres ----
con <- dbConnect(
  RPostgres::Postgres(),
  dbname = 'lastmile_db',
  host = 'your-redshift-cluster-url.amazonaws.com',
  port = 5439,
  user = 'your_username',
  password = 'your_password'
)

# ---- 2. Query Large-Scale Navigation/Map Data ----
# Example: extract delivery route performance data for the last month
delivery_data <- dbGetQuery(con, "
  SELECT 
    driver_id,
    route_id,
    delivery_date,
    on_time_deliveries,
    total_deliveries,
    route_distance_km,
    route_duration_min,
    region
  FROM delivery_routes
  WHERE delivery_date >= DATE_TRUNC('month', CURRENT_DATE) - INTERVAL '1 month'
")

# ---- 3. Data Quality Checks & Validation ----
# Example: Check for missing values and outliers
summary(delivery_data)
sum(is.na(delivery_data))

# Outlier detection for route_duration_min
outliers <- delivery_data %>%
  filter(route_duration_min > quantile(route_duration_min, 0.99) |
         route_duration_min < quantile(route_duration_min, 0.01))

# ---- 4. KPI Calculation ----
# On-time delivery rate by region
kpi_region <- delivery_data %>%
  group_by(region) %>%
  summarise(
    total_deliveries = sum(total_deliveries),
    on_time = sum(on_time_deliveries),
    on_time_rate = on_time / total_deliveries
  )

# ---- 5. Data Visualization (Dashboards/Reports) ----
# Visualize on-time delivery rates by region
ggplot(kpi_region, aes(x = region, y = on_time_rate)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "On-Time Delivery Rate by Region", y = "On-Time Rate", x = "Region") +
  theme_minimal()

# ---- 6. Predictive Modeling ----
# Example: Predict likelihood of on-time delivery
delivery_data$on_time_flag <- as.factor(ifelse(delivery_data$on_time_deliveries > 0, 1, 0))

# Simple logistic regression model
model <- glm(on_time_flag ~ route_distance_km + route_duration_min + region, data = delivery_data, family = "binomial")
summary(model)

# Make predictions
delivery_data$predicted_prob <- predict(model, type = "response")

# ---- 7. Automate ETL Job Example ----
# Save cleaned and validated data for downstream processing
write_csv(delivery_data, "cleaned_delivery_data.csv")

# ---- 8. Present Findings ----
# Example: Summary table for leadership
summary_table <- kpi_region %>%
  arrange(desc(on_time_rate))
print(summary_table)

# ---- 9. Disconnect from DB ----
dbDisconnect(con)
