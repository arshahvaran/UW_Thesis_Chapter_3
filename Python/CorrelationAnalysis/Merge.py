# ----------------------------------------------------------------------------
# Header information:
# Author: Ali Reza Shahvaran
# Filename: Merge.py
# License: CC BY 4.0
# ----------------------------------------------------------------------------
# Description: 
# This script performs the following tasks:
# - Reads multiple Excel files from a specified directory in a predefined order.
# - Merges the Excel files into a single data frame.
# - Filters out rows from the merged data based on certain criteria.
# - Updates values in one Excel file (Merged3.xlsx) using data from another 
#   Excel file (Merged2.xlsx) if specific conditions are met.
# - Outputs the merged and updated data to new Excel files in the same directory.
# ----------------------------------------------------------------------------
# Dependencies: os, pandas, numpy
# ----------------------------------------------------------------------------
# Input: 
# - Multiple Excel files located in the specified directory.
# ----------------------------------------------------------------------------
# Output: 
# - Merged.xlsx: Excel file containing data merged from all input Excel files.
# - Merged2.xlsx: Excel file containing merged data after filtering specific rows.
# - Merged4.xlsx: Updated version of Merged3.xlsx based on data from Merged2.xlsx.
# ----------------------------------------------------------------------------
# Notes:
# - Ensure the directory path and file order are correctly defined before executing.
# ----------------------------------------------------------------------------
import os
import pandas as pd
import numpy as np

# Define the directory containing the Excel files
directory = r"C:\Users\PHYS3009\Desktop\CorrelationAnalysis\Outputs"

# Define the order of the files to be read and merged
file_order = [
    "Landsat5_All.xlsx",
    "Landsat7_All.xlsx",
    "Landsat8_All.xlsx",
    "Sentinel2_All.xlsx",
    "Landsat5_HH.xlsx",
    "Landsat7_HH.xlsx",
    "Landsat8_HH.xlsx",
    "Sentinel2_HH.xlsx",
    "Landsat5_WLO.xlsx",
    "Landsat7_WLO.xlsx",
    "Landsat8_WLO.xlsx",
    "Sentinel2_WLO.xlsx",
    "Landsat5_AW.xlsx",
    "Landsat7_AW.xlsx",
    "Landsat8_AW.xlsx",
    "Sentinel2_AW.xlsx",
    "Landsat5_SS.xlsx",
    "Landsat7_SS.xlsx",
    "Landsat8_SS.xlsx",
    "Sentinel2_SS.xlsx",
    "Landsat5_EH.xlsx",
    "Landsat7_EH.xlsx",
    "Landsat8_EH.xlsx",
    "Sentinel2_EH.xlsx",
    "Landsat5_OM.xlsx",
    "Landsat7_OM.xlsx",
    "Landsat8_OM.xlsx",
    "Sentinel2_OM.xlsx"
]

# Initialize an empty list to hold the data frames
dfs = []

# Loop over each file in the specified order
for file_name in file_order:
    file_path = os.path.join(directory, file_name)
    
    # Check if the file exists
    if os.path.exists(file_path):
        # Read the Excel file, skipping the second row (index 1)
        df = pd.read_excel(file_path, skiprows=[1])
        dfs.append(df)
    else:
        print(f"{file_name} does not exist in the directory.")

# Concatenate all the data frames into a single data frame
merged_df = pd.concat(dfs, ignore_index=True)

# Write the merged data frame to a new Excel file in the same directory
output_file = os.path.join(directory, "Merged.xlsx")
merged_df.to_excel(output_file, index=False)

# Read the original merged file
merged_df = pd.read_excel(os.path.join(directory, "Merged.xlsx"))

# Filter out the rows where the "Index" column starts with 'B'
filtered_df = merged_df[~merged_df['Index'].astype(str).str.startswith('B')]

# Write the filtered data frame to a new Excel file in the same directory
output_file = os.path.join(directory, "Merged2.xlsx")
filtered_df.to_excel(output_file, index=False)

# Load the Merged2.xlsx file
merged2_file_path = os.path.join(directory, "Merged2.xlsx")
merged2_df = pd.read_excel(merged2_file_path)

# Load the Merged3.xlsx file
merged3_file_path = os.path.join(directory, "Merged3.xlsx")
merged3_df = pd.read_excel(merged3_file_path)

# Define the columns on which to merge
merge_columns = ["Satellite", "Category", "Product", "Index", "Index_Number"]

# Iterate over each row in Merged3.xlsx
for index, row in merged3_df.iterrows():
    # Find the corresponding row in Merged2.xlsx
    matched_row = merged2_df[(merged2_df[merge_columns] == row[merge_columns]).all(axis=1)]
    
    # If a matching row is found and the value of "n" is greater than 10, update the columns in Merged3.xlsx
    if not matched_row.empty and matched_row.iloc[0]['n'] > 10:
        merged3_df.at[index, 'r'] = matched_row.iloc[0]['r']
        merged3_df.at[index, 'rho'] = matched_row.iloc[0]['rho']
        merged3_df.at[index, 'r2'] = matched_row.iloc[0]['r2']
        merged3_df.at[index, 'n'] = matched_row.iloc[0]['n']

# Write the updated Merged3 data frame to a new Excel file in the same directory
output_file = os.path.join(directory, "Merged4.xlsx")
merged3_df.to_excel(output_file, index=False)


