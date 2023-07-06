% ----------------------------------------------------------------------------
% Header information:
% Author: Ali Reza Shahvaran
% Filename: Correlation_Analysis
% License: CC BY 4.0
% ----------------------------------------------------------------------------
% Description: This script performs Pearson and Spearman correlation analyses between a response variable (Chl-A concentration) and multiple predictor variables from the Excel file.
% ----------------------------------------------------------------------------
% Dependencies: MATLAB R2022b
% ----------------------------------------------------------------------------
% Input: OrganizedData.xlsx, containing Chl-A concentration and predictor variables in columns starting from the 17th column
% ----------------------------------------------------------------------------
% Output: correlationResults.mat (MAT file) and correlationResults.csv (CSV file)
% containing Pearson's correlation coefficients and Spearman's rank correlation coefficients for each predictor variable
% ----------------------------------------------------------------------------
% Load the necessary packages for working with Excel files 
addpath('path/to/your/dependencies'); % ← [IMPORTANT] Replace with the path to your MATLAB add-ons, if necessary

% Read the first sheet of the Excel file named "Data"
filename = 'OrganizedData.xlsx';
sheet = 1;
dataTable = readtable(filename, 'Sheet', sheet);

% Set the response column name
responseName = 'ChlA_Uncorrected_µg_L';
response = dataTable{:, responseName};

% Initialize the results storage
numCols = width(dataTable);
pearsonCoeffs = zeros(numCols - 17 + 1, 1);
spearmanCoeffs = zeros(numCols - 17 + 1, 1);
headers = cell(numCols - 17 + 1, 1);

% Iterate through predictor columns, starting from the 17th column
for i = 17:numCols
    % Select the current predictor column
    predictorName = dataTable.Properties.VariableNames{i};
    predictor = dataTable{:, predictorName};
    
    % Store the column header
    headers{i - 16} = predictorName;

    % Compute Pearson's correlation coefficient (r)
    [r, ~] = corr(response, predictor, 'Type', 'Pearson');
    pearsonCoeffs(i - 16) = r;
    
    % Compute Spearman's rank correlation coefficient (rho)
    [rho, ~] = corr(response, predictor, 'Type', 'Spearman');
    spearmanCoeffs(i - 16) = rho;
end

% Combine the headers, Pearson's correlation coefficients, and Spearman's rank correlation coefficients into a table
resultsTable = table(headers, pearsonCoeffs, spearmanCoeffs, 'VariableNames', {'Header', 'Pearson_r', 'Spearman_rho'});

% Save the results to a MAT file
save('correlationResults.mat', 'resultsTable');

% Export the results to a CSV file
writetable(resultsTable, 'correlationResults.csv');