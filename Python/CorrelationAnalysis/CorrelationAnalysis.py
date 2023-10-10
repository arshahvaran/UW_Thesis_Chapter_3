# ----------------------------------------------------------------------------
# Header information:
# Author: Ali Reza Shahvaran
# Filename: CorrelationAnalysis.py
# License: [Your License]
# ----------------------------------------------------------------------------
# Description: This script processes data from Excel files located in a specified 
# input directory. For each input file, it computes the correlation between specified 
# columns, calculating Pearson and Spearman correlation coefficients, R^2 values, and 
# the count of available pairwise data points. The script then generates an output 
# Excel file for each input file, containing the calculated metrics along with 
# additional information such as Satellite, Category, Product, and Index.
# ----------------------------------------------------------------------------
# Dependencies: pandas, numpy, os
# ----------------------------------------------------------------------------
# Input: 
# - Multiple Excel files located in the specified input directory, each containing 
#   data columns that will be correlated against a specified base column.
# ----------------------------------------------------------------------------
# Output: 
# - Multiple Excel files saved in the specified output directory. Each output file 
#   contains calculated correlation metrics and additional information for the 
#   columns of the corresponding input file.
# ----------------------------------------------------------------------------

import pandas as pd
import numpy as np
import os

# Specify the input and output directories
input_directory = "C:\\Users\\PHYS3009\\Desktop\\CorrelationAnalysis\\Inputs\\"
output_directory = "C:\\Users\\PHYS3009\\Desktop\\CorrelationAnalysis\\Outputs\\"

# List all .xlsx files in the input directory
input_files = [f for f in os.listdir(input_directory) if f.endswith('.xlsx')]

# Define the prefixes and suffixes
satellite_prefixes = ["Landsat5", "Landsat7", "Landsat8", "Sentinel2"]
category_suffixes = ["All.xlsx", "HH.xlsx", "WLO.xlsx", "AW.xlsx", "SS.xlsx", "EH.xlsx", "OM.xlsx"]
product_prefixes = ["ACOLITE", "ATCOR", "C2RCC", "DOS1", "FLAASH", "iCOR", "Level1", "Level2", "Polymer", "QUAC"]

# Loop through each .xlsx file in the input directory
for file_name in input_files:
    input_file_path = os.path.join(input_directory, file_name)

    # Load the data from the Excel file
    data = pd.read_excel(input_file_path)

    # Specify the base column index (0-indexed) and the target columns range (0-indexed)
    base_column_index = 7
    target_columns_range = range(16, len(data.columns))

    # Initialize dictionaries to store the correlation coefficients, R^2, and count of available pairwise data points
    r_values = {}
    rho_values = {}
    r2_values = {}
    n_r_values = {}
    n_rho_values = {}
    
    # Determine Satellite and Category based on file_name
    satellite = next((prefix for prefix in satellite_prefixes if file_name.startswith(prefix)), None)
    category = next((suffix[:-5] for suffix in category_suffixes if file_name.endswith(suffix)), None)

    
    # Extract the base column
    base_column = data.iloc[:, base_column_index]
    
    # Initialize lists to store Product, Index, and Index_Number
    product_list = []
    index_list = []
    index_number_list = []

    # Calculate the correlation coefficients, R^2, and count of available pairwise data points for each target column
    for i in target_columns_range:
        column = data.columns[i]
        
        # Drop rows where either the base column or the target column contains NaN values
        valid_data = data[[base_column.name, column]].dropna()
        valid_base_column = valid_data[base_column.name]
        valid_target_column = valid_data[column]
        
        # Calculate Pearson correlation coefficient and count of available pairwise data points
        r = valid_base_column.corr(valid_target_column, method='pearson')
        r_values[column] = r
        n_r_values[column] = len(valid_base_column)
        
        # Calculate R^2
        r2 = r ** 2
        r2_values[column] = r2
        
        # Calculate Spearman rank correlation coefficient and count of available pairwise data points
        rho = valid_base_column.corr(valid_target_column, method='spearman')
        rho_values[column] = rho
        n_rho_values[column] = len(valid_base_column)
        
        # Determine Product, Index, and Index_Number based on column header
        product = next((prefix for prefix in product_prefixes if column.startswith(prefix)), None)
        index = column.split('_')[-1] if '_' in column else None
        index_number = index.lstrip('I') if index and index.startswith('I') and index[1:].isdigit() else None
        
        # Append to lists
        product_list.append(product)
        index_list.append(index)
        index_number_list.append(index_number)
    
    # Create output DataFrame with the calculated values and additional columns
    output_data = pd.DataFrame({
        'File Name': [file_name] + [file_name] * len(data.columns[target_columns_range]),
        'Satellite': [satellite] + [satellite] * len(data.columns[target_columns_range]),
        'Category': [category] + [category] * len(data.columns[target_columns_range]),
        'Header': [base_column.name] + list(data.columns[target_columns_range]),
        'Product': [None] + product_list,
        'Index': [None] + index_list,
        'Index_Number': [None] + index_number_list,
        'r': [r_values.get(base_column.name, None)] + [r_values.get(col, None) for col in data.columns[target_columns_range]],
        'rho': [rho_values.get(base_column.name, None)] + [rho_values.get(col, None) for col in data.columns[target_columns_range]],
        'r2': [r2_values.get(base_column.name, None)] + [r2_values.get(col, None) for col in data.columns[target_columns_range]],
        'n': [n_rho_values.get(base_column.name, None)] + [n_rho_values.get(col, None) for col in data.columns[target_columns_range]],
    })

    # Save the output DataFrame to an Excel file in the output directory
    output_file_path = os.path.join(output_directory, file_name)
    output_data.to_excel(output_file_path, header=True, index=False)
