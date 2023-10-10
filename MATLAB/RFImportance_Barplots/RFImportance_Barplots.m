% ----------------------------------------------------------------------------
% Header information:
% Author: Ali Reza Shahvaran
% Filename: RFImportance_Barplots.m
% License: CC BY 4.0
% ----------------------------------------------------------------------------
% Description: This script loads data from an Excel file and visualizes 
% the importance scores of various indices for different products using 
% stacked bar plots. Each unique combination of Satellite and Category 
% is plotted separately. The color of each segment in the bar plot corresponds 
% to its product, and an asterisk indicates the highest segment in each plot.
% ----------------------------------------------------------------------------
% Dependencies: MATLAB
% ----------------------------------------------------------------------------
% Input: 
% - 'Merged4.xlsx': An Excel file containing data on the importance scores 
%   of various indices for different products, categorized by Satellite and Category.
% ----------------------------------------------------------------------------
% Output: 
% - Multiple stacked bar plots: Each bar represents an index, and each 
%   segment within a bar represents a product. The height of each segment 
%   corresponds to its importance score.
% ----------------------------------------------------------------------------
clc;
clear all;
close all;

% Load the data
filename = 'Merged4.xlsx'; % The file is in the same folder as the script
dataTable = readtable(filename);

% Define colors for each product
colors = containers.Map({'Level1', 'Level2', 'ACOLITE', 'ATCOR', 'C2RCC', 'DOS1', 'FLAASH', 'iCOR', 'Polymer', 'QUAC'}, ...
                        {'#30123b', '#4662d7', '#35aaf9', '#1ae4b6', '#72fe5e', '#c8ef34', '#faba39', '#f66b19', '#ca2a04', '#7a0403'});

% Define the correct order for the x-axis labels
orderedIndices = compose("I%d", 1:27);

% Define the correct order for the products
orderedProducts = {'Level1', 'Level2', 'ACOLITE', 'ATCOR', 'C2RCC', 'DOS1', 'FLAASH', 'iCOR', 'Polymer', 'QUAC'};

% Find unique Satellite and Category pairs
[satCat, ~, idx] = unique(dataTable(:, {'Satellite', 'Category'}), 'rows');

% Iterate over each unique Satellite and Category pair
for k = 1:height(satCat)
    % Select rows corresponding to the current Satellite and Category pair
    subsetTable = dataTable(idx == k, :);
    
    % Create a new figure
    figure;
    titleString = strcat(satCat.Satellite{k}, ' - ', satCat.Category{k});
    disp(titleString);
    title(titleString);


    % Find unique Products and Indices for the current Satellite and Category pair
    products = intersect(orderedProducts, unique(subsetTable.Product), 'stable');
    indices = unique(subsetTable.Index);
    
    % Initialize the data matrix for the stacked bar plot
    barData = zeros(length(indices), length(products));
    
    % Populate the data matrix
    for p = 1:numel(products)
        product = products{p};
        productRows = strcmp(subsetTable.Product, product);
        for i = 1:numel(indices)
            index = indices{i};
            indexRow = strcmp(subsetTable.Index, index);
            barData(i, p) = sum(subsetTable.ImportanceScore(productRows & indexRow));
        end
    end
    
    % Find the index and product corresponding to the highest segment
    [maxValue, linearIdx] = max(barData(:));
    [rowIdx, colIdx] = ind2sub(size(barData), linearIdx);
    
    % Calculate the y position of the middle of the tallest segment
    if any(~isnan(barData(rowIdx, :)))
        if colIdx > 1
            belowMaxBarSum = sum(barData(rowIdx, 1:colIdx-1), 'omitnan');
        else
            belowMaxBarSum = 0;
        end
        yPos = belowMaxBarSum + maxValue/2;
    else
        yPos = NaN;
    end

    
    % Plot the stacked bar plot
    barHandle = bar(categorical(indices, orderedIndices), barData, 'stacked', 'FaceAlpha', 0.9);
    
    % Set the colors of the bars
    for p = 1:numel(products)
        barHandle(p).FaceColor = colors(products{p});
    end
    
    % Add an asterisk in the middle of the tallest segment
    xPos = find(strcmp(orderedIndices, indices{rowIdx}));

    % Get the color of the bar segment
    segmentColor = colors(products{colIdx});
    % Convert the color to RGB format
    segmentColor = sscanf(segmentColor(2:end),'%2x',[1 3])/255;
    % Calculate the brightness of the color
    brightness = 0.299 * segmentColor(1) + 0.587 * segmentColor(2) + 0.114 * segmentColor(3);
    % Set text color to black or white based on brightness
    if brightness > 0.5
        textColor = 'k'; % Black text for bright background
    else
        textColor = 'w'; % White text for dark background
    end
    % Add a contrasting text symbol in the middle of the tallest segment
    text(xPos, yPos, '★', 'FontSize', 10, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', textColor);

    

    % Calculate the width and height of the text box (adjust as needed)
    textBoxWidth = 2.5;
    textBoxHeight = 0.05;
    
    xPos2 = xPos + 1.75;

    % Define the background color and alpha (transparency) value
    bgColor = [1 1 1]; % white
    alphaValue = 0.75; % semi-transparent
    
    % Create a semi-transparent patch object as the background
    patch('XData', [xPos2 - textBoxWidth/2, xPos2 + textBoxWidth/2, xPos2 + textBoxWidth/2, xPos2 - textBoxWidth/2], ...
          'YData', [yPos - yPos*0.1, yPos - yPos*0.1, yPos + yPos*0.1, yPos + yPos*0.1], ...
          'FaceColor', bgColor, 'EdgeColor', 'none', 'FaceAlpha', alphaValue);
    
    % Add the importance value next to the asterisk
    text(xPos+0.75, yPos, ['' num2str(maxValue, '%.2f')], 'FontSize', 10, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle');

    

    % Add labels and legend
    %xlabel('Index');
    %ylabel('Importance Score');
    ylim('tight');
    ax = gca; % Get the current axes
    ax.XAxis.TickLength = [0 0]; % Remove the x-axis ticks
end
