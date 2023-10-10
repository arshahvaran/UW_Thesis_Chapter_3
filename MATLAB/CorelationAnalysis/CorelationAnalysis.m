% ----------------------------------------------------------------------------
% Header information:
% Author: Ali Reza Shahvaran
% Filename: CorrelationAnalysis.m
% License: CC BY 4.0
% ----------------------------------------------------------------------------
% Description: This script generates scatter plots for different categories 
% based on the given Excel data. The plots are color-coded based on the 
% product and are shaped by the satellite data source. Two main sets of plots 
% are generated: a tiled layout with sub-plots for each category and 
% individual plots for each category.
% ----------------------------------------------------------------------------
% Dependencies: MATLAB
% ----------------------------------------------------------------------------
% Input: 
% - 'Merged4.xlsx': A table containing data for different categories, products, 
%   satellites, indices, and other related metrics.
% ----------------------------------------------------------------------------
% Output: 
% - Multiple scatter plots: Each plot visualizes data points based on the 
%   product and satellite, for a specific category and metric ('r' or 'rho').
% ----------------------------------------------------------------------------
clc;
clear all;
close all;

% Read data from the new Excel file
T = readtable('Merged4.xlsx');

% Define marker shapes
mkr = {"^", "v", "<", ">", "^", "v", "<", ">", "^", "v", "<", ">", "^", "v", "<", ">", "^", "v", "<", ">", "^", "v", "<", ">", "^", "v", "<", ">"};

% Define categories
categories = {"All", "HH", "WLO", "AW", "SS", "EH", "OM"};

% Set up the tiled layout with 2 columns and 7 rows
t = tiledlayout(7, 2);

% Adjust TileSpacing and Padding to reduce the gaps between subplots
t.TileSpacing = 'compact';
t.Padding = 'compact';

% Loop through each category to generate sub-plots
for j = 1:length(categories)
    category = categories{j};
    
    % Filter data for the current category
    categoryData = T(strcmp(T.Category, category), :);
    
    % Sub-plot for "r"
    nexttile;
    createScatterPlot(categoryData, 'r', mkr);
    
    % Sub-plot for "rho"
    nexttile;
    createScatterPlot(categoryData, 'rho', mkr);
end

% Loop through each category again to create individual plots
for j = 1:length(categories)
    category = categories{j};
    
    % Filter data for the current category
    categoryData = T(strcmp(T.Category, category), :);
    
    % Individual plot for "r"
    f_r = figure('Units', 'centimeters', 'Name', ['r_', char(matlab.lang.makeValidName(category))]);
    createScatterPlot(categoryData, 'r', mkr);
    set(gca, 'PlotBoxAspectRatio', [13.23, 6.61, 1]);
    
    % Similar adjustments for "rho"
    f_rho = figure('Units', 'centimeters', 'Name', ['rho_', char(matlab.lang.makeValidName(category))]);
    createScatterPlot(categoryData, 'rho', mkr);
    set(gca, 'PlotBoxAspectRatio', [13.23, 6.61, 1]);
end


function createScatterPlot(data, yVar, mkr)
    % Set up the plot properties
    xlim([0 28]);
    xticks(0:1:27);
    xticklabels({'', data.Index{:}, ''});
    patch([0 max(xlim) max(xlim) 0], [1 1 0.5 0.5], 'r', 'EdgeColor', [0.5 0.5 0.5], 'FaceColor', 'none');
    patch([0 max(xlim) max(xlim) 0], [-0.5 -0.5 -1 -1], 'r', 'EdgeColor', [0.5 0.5 0.5], 'FaceColor', 'none');
    hold on;
    
    % Define color mapping based on the provided color codes for each product
    colorMap = containers.Map({'Level1', 'Level2', 'ACOLITE', 'ATCOR', 'C2RCC', 'DOS1', 'FLAASH', 'iCOR', 'Polymer', 'QUAC'}, ...
                              {'#30123b', '#4662d7', '#35aaf9', '#1ae4b6', '#72fe5e', '#c8ef34', '#faba39', '#f66b19', '#ca2a04', '#7a0403'});
    
    % Loop through the unique satellites to plot data points with different markers
    satellites = unique(data.Satellite);
    for i = 1:length(satellites)
        satelliteData = data(strcmp(data.Satellite, satellites{i}), :);
        
        % Loop through unique products and assign colors
        for product = colorMap.keys()
            productData = satelliteData(strcmp(satelliteData.Product, product{1}), :);
            colorHex = colorMap(product{1});
            colorRGB = sscanf(colorHex(2:end),'%2x',[1,3]) / 255;
            scatter(productData.Index_Number, productData.(yVar), productData.n, colorRGB, "filled", string(mkr(i)));
        end
    end
    
    ylim([-1 1]);
    %ylabel(yVar);
    % Set the aspect ratio of the plot
    set(gca, 'PlotBoxAspectRatio', [2, 1, 1]);
end

