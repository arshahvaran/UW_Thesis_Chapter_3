# ----------------------------------------------------------------------------
# Header information:
# Author: Ali Reza Shahvaran
# Filename: Models.py
# License: CC BY 4.0
# ----------------------------------------------------------------------------
# Description: 
# This script performs the following tasks:
# - Iterates over all Excel files in a specified input directory.
# - For each file, it performs a linear regression on the first two columns.
# - Appends the modeled Y values based on the regression coefficients to the data.
# - Outputs the modified data to new Excel files in an output directory.
# - Generates a report summarizing the regression results for each file.
# ----------------------------------------------------------------------------
# Dependencies: os, pandas, scipy.stats
# ----------------------------------------------------------------------------
# Input: 
# - Multiple Excel files located in the specified input directory.
# ----------------------------------------------------------------------------
# Output: 
# - Modified Excel files with added "Modeled_Y" values in the output directory.
# - Report.xlsx: A summary report of the regression results for each input file.
# ----------------------------------------------------------------------------
# Notes:
# - Ensure the input directory path and output directory path are correctly defined before executing.
# - This script assumes that the regression should be performed on the first two columns of each input file.
# ----------------------------------------------------------------------------
import os
import pandas as pd
from scipy.stats import linregress

def perform_regression_for_file(file_path):
    # Read the data
    data = pd.read_excel(file_path)
    
    # Check if the data has at least two columns
    if len(data.columns) < 2:
        print(f"Warning: Not enough columns in file {file_path}. Skipping this file.")
        return None, None, None, None
    
    # Filter out rows with N/A values in the first two columns
    filtered_data = data.dropna(subset=data.columns[:2]).copy()  # Using the first two columns

    # Extracting X and Y values
    X = filtered_data.iloc[:, 1].values  # Second column
    Y = filtered_data.iloc[:, 0].values  # First column

    # Performing linear regression
    slope, intercept, _, _, _ = linregress(X, Y)

    # Calculating the modeled Y values using the regression coefficients
    filtered_data['Modeled_Y'] = slope * X + intercept

    return slope, intercept, len(X), filtered_data

def main():
    input_directory = "C:\\Users\\alire\\OneDrive\\Desktop\\Models\\Inputs"
    output_directory = "C:\\Users\\alire\\OneDrive\\Desktop\\Models\\Outputs"
    
    # Ensure the output directory exists
    if not os.path.exists(output_directory):
        os.makedirs(output_directory)

    # Prepare to collect results for the final report
    results = []
    
    # Iterate over all Excel files in the input directory
    for file_name in os.listdir(input_directory):
        if file_name.endswith('.xlsx'):
            file_path = os.path.join(input_directory, file_name)
            
            # Perform regression for the current file
            a, b, n, modified_data = perform_regression_for_file(file_path)
            
            # If we got valid results, save the modified data and collect results for the report
            if a is not None and b is not None and n is not None:
                # Save the modified file to the output directory
                modified_data.to_excel(os.path.join(output_directory, file_name), index=False)
                
                # Collect results for the report
                results.append({
                    "File Name": file_name,
                    "a": a,
                    "b": b,
                    "n": n
                })

    # Generate the final report and save it
    report_df = pd.DataFrame(results)
    report_df.to_excel(os.path.join(output_directory, "Report.xlsx"), index=False)

if __name__ == "__main__":
    main()
