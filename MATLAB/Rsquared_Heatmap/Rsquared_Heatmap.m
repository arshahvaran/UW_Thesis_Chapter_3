% ----------------------------------------------------------------------------
% Header information:
% Author: Ali Reza Shahvaran
% Filename: Rsquared_Heatmap.m
% License: CC BY 4.0
% ----------------------------------------------------------------------------
% Description: This script reads data from an Excel file and visualizes 
% the R2 values of different products for various indices. For each unique 
% combination of Satellite and Category, a heatmap is generated. The heatmap 
% shows the R2 values for each Index and Product combination. Additionally, 
% the average R2 value for each row (index) and column (product) is 
% computed and displayed.
% ----------------------------------------------------------------------------
% Dependencies: MATLAB
% ----------------------------------------------------------------------------
% Input: 
% - 'Merged4.xlsx': An Excel file containing the R2 values of various 
%   indices for different products, categorized by Satellite and Category.
% ----------------------------------------------------------------------------
% Output: 
% - Multiple heatmaps: Each heatmap represents the R2 values of different 
%   products for various indices for a specific Satellite and Category combination.
% ----------------------------------------------------------------------------
clc;
clear all
close all  % Close all previously open figure windows

% Read the new input file
T = readtable('Merged4.xlsx');

% Define the unique values for Category and Satellite
categories = {'All', 'HH', 'WLO', 'AW', 'SS', 'EH', 'OM'};
satellites = {'Landsat5', 'Landsat7', 'Landsat8', 'Sentinel2'};
products = {'Level1', 'Level2', 'ACOLITE', 'ATCOR', 'C2RCC', 'DOS1', 'FLAASH', 'iCOR', 'Polymer', 'QUAC'};

% Define the Index labels
indexLabels = strcat('I', arrayfun(@num2str, (1:27)', 'UniformOutput', false));
indexLabels{28} = 'Avg';

% Extend the products array to include the average column
products{end+1} = 'Avg';

% Loop over each unique combination of Category and Satellite to create a separate heatmap
for i = 1:length(categories)
    for j = 1:length(satellites)
        category = categories{i};
        satellite = satellites{j};
        
        % Filter the table based on the current category and satellite
        Table = T(strcmp(T.Category, category) & strcmp(T.Satellite, satellite), :);
        
        % Initialize the data matrix for the heatmap
        dataMatrix = nan(28, numel(products));
        
        % Fill the data matrix based on the filtered Table
        for k = 1:height(Table)
            rowIndex = Table.Index_Number(k);
            colIndex = find(strcmp(products, Table.Product{k}));
            dataMatrix(rowIndex, colIndex) = Table.r2(k);
        end
        
        % Compute the average for each row and column and fill the last column and last row
        dataMatrix(1:27, end) = nanmean(dataMatrix(1:27, 1:end-1), 2);
        dataMatrix(end, 1:end-1) = nanmean(dataMatrix(1:27, 1:end-1), 1);
        
        % Create a new figure for each heatmap
        figure;
        
        % Create a heatmap using the data matrix
        h = heatmap(products, indexLabels, dataMatrix, 'Colormap', turbo, 'ColorLimits', [0 1]);
        
        % Set the title of the heatmap based on the current category and satellite
        h.Title = strcat(category, ' - ', satellite);
        
        % Set the XLabel and YLabel of the heatmap
        h.XLabel = 'Product';
        h.YLabel = 'Index';
        
        % Set the CellLabelFormat of the heatmap
        h.CellLabelFormat = '%.2f';
        
        % Adjust the XDisplayLabels for Products
        h.XDisplayLabels = strrep(h.XDisplayLabels, 'Level1', 'Level 1');
        h.XDisplayLabels = strrep(h.XDisplayLabels, 'Level2', 'Level 2');
    end
end
