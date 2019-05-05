# datax_bikeshare

Bike share optimization project as part of Data-X course @ Berkeley. The project is largely split into three tasks:

1) Clustering model to cluster the stations based on the volume of bike trips between the stations.
  2) Prediction model to predict the net trip count per station.
  3) Optimization model to find the most optimal counter-movement of bikes to keep the station network in balance, based on the predicted state.

# Directory structure

**1. big_query**: All the BigQuery queries to preprocess the datasets for modeling.
  a. *hourly_weather.txt* - Query for processing the hourly weather data.
  b. *station_status.txt* - Query for processing the station status data.
  c. *trip_summary.txt* - Query for processing the trip summary data.

**2. cloud_functions**: Has the JS code to make a hourly request to the Ford Bike website to pick up station status and store it in a BigQuery table.

**3. data**: Stores the raw and processed datasets.1
  a. *hourly_weather_<start_month>_<end_month>* - hourly weather data.
  b. *station_status_<month>* - station status data.
  c. *trip_summary_<start_month>_<end_month>* - trip summary data processed in BigQuery.

**4. exploratory**: Has all the exploratory notebooks, including all the clustering work.
  a. *clustering/* - Directory with all exploratory work for clustering (Spectral and K-means).

**5. model**: Has all the final notebooks for a) Clustering, b) Prediction, and c) Optimization.
  a. *spectral_clustering.ipynb* - Jupyter notebook for spectral clustering.
  b. *prediction_trip_count.ipynb* - Jupyter notebook for trip count prediction.
  c. *optimization/* - Directory with all optimization work.
  d. *output/* - Model outputs in .csv format.
