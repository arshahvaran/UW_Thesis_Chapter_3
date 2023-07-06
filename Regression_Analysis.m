% ----------------------------------------------------------------------------
% Header information:
% Filename: Regression_Analysis.m
% ----------------------------------------------------------------------------
% Description: This script performs linear regression analysis on an Excel file containing predictor and response variables. The script iterates through the predictor columns, fits a linear model, and calculates the root mean square error (RMSE) for each model. Results are saved to a MAT file and exported as a CSV file.
% ----------------------------------------------------------------------------
% Dependencies: MATLAB R2022b
% ----------------------------------------------------------------------------
% Input: Excel file ('OrganizedData.xlsx') containing predictor and response variables.
% ----------------------------------------------------------------------------
% Output: MAT file ('regressionResults.mat') and CSV file ('regressionResults.csv') containing the predictor names, modeled response, coefficients (intercept and slope), and RMSE for each model.
% ----------------------------------------------------------------------------
% Load the necessary packages for working with Excel files and regression models
addpath('path/to/your/dependencies'); % ← [IMPORTANT] Replace with the path to your MATLAB add-ons, if necessary

% Read the first sheet of the Excel file named "Data"
filename = 'OrganizedData.xlsx';
sheet = 1;
dataTable = readtable(filename, 'Sheet', sheet);

% Set the validation scheme to cross-validation and the number of folds
validationScheme = 'KFold';
numFolds = 5;

% Set the response column name
responseName = 'ChlA_Uncorrected_µg_L';

% Initialize the results storage
numCols = width(dataTable);
results = cell(numCols - 17 + 1, 4);

% Iterate through predictor columns, starting from the 17th column
for i = 17:numCols
    % Select the current predictor column
    predictorName = dataTable.Properties.VariableNames{i};
    
    % Create a table with the current predictor and response variables
    currentData = dataTable(:, {predictorName, responseName});
    
    % Create a linear regression model using the selected predictor and response
    linearModel = fitlm(currentData, 'ResponseVar', responseName, 'PredictorVars', predictorName, ...
        'CategoricalVars', [], 'Validation', validationScheme, 'KFold', numFolds);
    
    % Compute the RMSE for the model
    rmse = kfoldLoss(linearModel, 'LossFun', 'mse');
    rmse = sqrt(rmse);
    
    % Extract the model coefficients (intercept and slope)
    coeffs = linearModel.Coefficients.Estimate;
    intercept = coeffs(1);
    slope = coeffs(2);
    
    % Store the column header, modeled response, slope, intercept, and RMSE for the current iteration
    results{i - 16, 1} = predictorName;
    results{i - 16, 2} = linearModel.fitted;
    results{i - 16, 3} = [intercept, slope];
    results{i - 16, 4} = rmse;
end

% Save the results to a MAT file
save('regressionResults.mat', 'results');

% Convert the results cell array to a table
resultsTable = cell2table(results, 'VariableNames', {'Header', 'ModeledResponse', 'Coefficients', 'RMSE'});

% Export the results to a CSV file
writetable(resultsTable, 'regressionResults.csv'); % ← [IMPORTANT] You can choose the name of the file, but keep it consisitent with other scripts
