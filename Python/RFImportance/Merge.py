# ----------------------------------------------------------------------------
# Header information:
# Author: Ali Reza Shahvaran
# Filename: Merge.py
# License: CC BY 4.0
# ----------------------------------------------------------------------------
# Description: 
# This script performs the following tasks:
# - Iterates over a specified order of Excel files in a defined directory.
# - Merges these files into a single Excel file.
# - Filters out rows in the merged file based on specific criteria.
# - Loads another Excel file and updates its rows based on matching criteria with the filtered merged file.
# - Outputs the updated file and the filtered merged file to new Excel files in the same directory.
# ----------------------------------------------------------------------------
# Dependencies: os, pandas, numpy
# ----------------------------------------------------------------------------
# Input: 
# - Multiple Excel files located in the specified directory.
# ----------------------------------------------------------------------------
# Output: 
# - Merged.xlsx: An Excel file containing the merged data from all the input files.
# - Merged2.xlsx: An Excel file containing the filtered merged data.
# - Merged4.xlsx: An Excel file containing the updated data after matching with Merged2.xlsx.
# ----------------------------------------------------------------------------
# Notes:
# - Ensure the directory path is correctly defined before executing.
# - This script assumes specific naming conventions and file structures. Ensure input files adhere to these conventions.
# ----------------------------------------------------------------------------
import os
import pandas as pd
import numpy as np

# Define the directory containing the Excel files
directory = r"C:\Users\alire\OneDrive\Desktop\RFImportance\Outputs"

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
        df = pd.read_excel(file_path)
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
    
    # Check if matched_row is not empty
    if not matched_row.empty:
        merged3_df.at[index, 'Importance Score'] = matched_row.iloc[0]['Importance Score']
        merged3_df.at[index, 'Standard Deviation'] = matched_row.iloc[0]['Standard Deviation']


# Write the updated Merged3 data frame to a new Excel file in the same directory
output_file = os.path.join(directory, "Merged4.xlsx")
merged3_df.to_excel(output_file, index=False)


