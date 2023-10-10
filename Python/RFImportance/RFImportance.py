# ----------------------------------------------------------------------------
# Header information:
# Author: Ali Reza Shahvaran
# Filename: RFImportance.py
# License: CC BY 4.0
# ----------------------------------------------------------------------------
# Description: 
# This script performs the following tasks:
# - Iterates over Excel files in a specified directory.
# - For each file, it extracts feature columns based on certain criteria.
# - Imputes missing values in these feature columns using the mean strategy.
# - Trains a Random Forest Regressor using the imputed features.
# - Extracts and computes the feature importance scores and standard deviations.
# - Stores the extracted information along with derived data into a new Excel file.
# ----------------------------------------------------------------------------
# Dependencies: pandas, numpy, os, sklearn
# ----------------------------------------------------------------------------
# Input: 
# - Multiple Excel files located in the specified input directory.
# ----------------------------------------------------------------------------
# Output: 
# - An Excel file for each input file, containing feature importance scores and other derived columns.
# ----------------------------------------------------------------------------
# Notes:
# - Ensure the directory paths are correctly defined before executing.
# - This script assumes specific naming conventions and file structures. Ensure input files adhere to these conventions.
# ----------------------------------------------------------------------------
import pandas as pd
import numpy as np
import os
from sklearn.ensemble import RandomForestRegressor
from sklearn.impute import SimpleImputer

# Function to derive "Product", "Index", and "Index_Number" from the feature name
def get_product_index_and_number(feature_name):
    # Find the position of the first "_"
    underscore_pos = feature_name.find("_")
    
    # The substring before the first "_" is "Product"
    product = feature_name[:underscore_pos]
    
    # The substring after "_I" is "Index"
    index = feature_name[feature_name.rfind("_") + 1:]  # Extracts everything after the last "_"

    # "Index_Number" is "Index" with the first character "I" removed
    index_number = index.lstrip("I")  # Removes "I" from the beginning of the index
    
    return product, index, index_number

# Specify the input and output directories
input_directory = "C:\\Users\\alire\\OneDrive\\Desktop\\RFImportance\\Inputs"
output_directory = "C:\\Users\\alire\\OneDrive\\Desktop\\RFImportance\\Outputs"

# List all .xlsx files in the input directory
input_files = [f for f in os.listdir(input_directory) if f.endswith('.xlsx')]

# Loop through each .xlsx file in the input directory
for file_name in input_files:
    input_file_path = os.path.join(input_directory, file_name)

    # Load the data from the Excel file
    data = pd.read_excel(input_file_path)

    # Specify the base column index (0-indexed) and the response variable
    base_column_index = 7
    response_variable = data.iloc[:, base_column_index]

    # Select feature columns based on the condition (contains "_I" and from 17th to last column)
    feature_columns = [col for col in data.columns[16:] if "_I" in col]

    # Check if any feature columns are selected
    if not feature_columns:
        print(f"Skipping {file_name} due to no selected feature columns.")
        continue

    # Select feature columns and response variable column
    selected_columns = feature_columns + [response_variable.name]

    # Drop columns that have all NaN values
    valid_data = data[selected_columns].dropna(axis=1, how='all')

    # Update feature_columns to only include columns that haven't been dropped
    feature_columns = valid_data.columns.tolist()
    feature_columns.remove(response_variable.name)

    # Initialize the SimpleImputer with the strategy to impute missing values
    imputer = SimpleImputer(strategy='mean')

    # Apply the imputer to the selected columns
    imputed_data = pd.DataFrame(imputer.fit_transform(valid_data), columns=valid_data.columns)

    # Separate the imputed features and response variable
    imputed_features = imputed_data[feature_columns]
    imputed_response_variable = imputed_data[response_variable.name]

    # Initialize the Random Forest Regressor
    rf = RandomForestRegressor(n_estimators=100, random_state=42)

    # Fit the model to the imputed data using all selected features
    rf.fit(imputed_features, imputed_response_variable)

    # Get the feature importance scores and standard deviations
    importance_scores = dict(zip(feature_columns, rf.feature_importances_))
    std_devs = dict(zip(feature_columns, np.std([tree.feature_importances_ for tree in rf.estimators_], axis=0)))

    # Derive additional columns
    file_names = [file_name] * len(feature_columns)
    satellites = ["Landsat5" if file_name.startswith("Landsat5") else "Landsat7" if file_name.startswith("Landsat7") else "Landsat8" if file_name.startswith("Landsat8") else "Sentinel2" for _ in feature_columns]
    categories = [file_name.split("_")[-1].replace(".xlsx", "") for _ in feature_columns]
    products, indices, index_numbers = zip(*[get_product_index_and_number(feature) for feature in feature_columns])

    # Create a DataFrame to store the results
    results_df = pd.DataFrame({
        'File Name': file_names,
        'Satellite': satellites,
        'Category': categories,
        'Header': feature_columns,
        'Product': products,
        'Index': indices,
        'Index_Number': index_numbers,
        'Importance Score': list(importance_scores.values()),
        'Standard Deviation': list(std_devs.values())
    })

    # Reorder the columns
    results_df = results_df[['File Name', 'Satellite', 'Category', 'Header', 'Product', 'Index', 'Index_Number', 'Importance Score', 'Standard Deviation']]

    # Save the results DataFrame to an Excel file in the output directory
    output_file_path = os.path.join(output_directory, file_name)
    results_df.to_excel(output_file_path, index=False)
    
    print(f"Feature importance analysis completed for {file_name}.")

print("Feature importance analysis completed for all files.")
