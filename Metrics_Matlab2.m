% ----------------------------------------------------------------------------
% Header information:
% Author: Ali Reza Shahvaran
% Filename: Metrics_Matlab2.m
% License: CC BY 4.0
% Version: 2.0
% ----------------------------------------------------------------------------
% Description: This script generates a customized scatter plot of Chl-a models using data from an Excel file. It includes custom markers, background color patches, and axis labels.
% ----------------------------------------------------------------------------
% Dependencies: MATLAB R2022b, hex2rgb (function)
% ----------------------------------------------------------------------------
% Input: Data from 'Metrics.xlsx' containing information about Chl-a models, x-axis values, y-axis values, marker sizes, colors, and symbols.
% The above mentioned file is the organized subset of the output file derived eariler from the Regression_Analysis.m code (or approaching the Regression Learner App directly).
% ----------------------------------------------------------------------------
% Output: A scatter plot with custom markers, background color patches, and customized axis labels and limits.
% ----------------------------------------------------------------------------

% Explanation of code sections:

% 1. Clear previous variables and close any open figures
% 2. Read input data from the Metrics.xlsx file
% 3. Extract data for the x-axis and y-axis from the table
% 4. Set marker sizes and colors based on the input table
% 5. Define marker symbols for different categories
% 6. Define colors for different regions and seasons
% 7. Initialize 'hold on' to overlay multiple graphics objects
% 8. Define x-coordinates for colored background patches
% 9. Define y-coordinates for colored background patches
% 10. Create colored background patches for each category
% 11. Loop through data points and create scatter plot with custom markers
% 12. Set y-axis limits
% 13. Add a label to the y-axis (uncomment the desired ylabel)
% 14. Add a label to the x-axis
% 15. Customize x-axis limits, ticks, and tick labels
% 16. Optionally, uncomment the legend and its title string

% Adding explanatory comments within the code:

clc % Clear command window
clear all % Clear all variables from the workspace
close all % Close all open figures

% Read data from the Metrics.xlsx file into a table
T = readtable('Metrics.xlsx');

% Extract the data for the x-axis (Chl-a Models)
x = table2array(T(1:28,"XX"));

% Uncomment the desired y-axis variable to plot
% y = table2array(T(1:28,"Y2_RMSE"));
% y = table2array(T(1:28,"Y1_RMSLE"));
% y = table2array(T(1:28,"Y3_MAE"));
% y = table2array(T(1:28,"Y8_Rsquared"));
% y = table2array(T(1:28,"Y4_MAPE"));
% y = table2array(T(1:28,"Y5_MDAPE"));
% y = table2array(T(1:28,"Y6_Epsilon"));
y = table2array(T(1:28,"Y7_Beta")); % Currently plotting Y7_Beta

% Extract marker sizes and colors from the input table
sz = table2array(T(1:28,"MarkerSize_n"));
c = string(categorical(table2array(T(1:28,"MarkerColor"))));

% Define marker symbols for different categories
mkr1 = string(categorical(table2array(T(1:28,"MarkerSymbol"))));

% Define colors for different regions and seasons
c_All = "#ffffff";
c_HH = "#e8e8e8";
c_WLO = "#cbcbcb";
c_AW = "#ffdcd3";
c_SS = "#d3f6ff";
c_OM = "#cfff95";
c_EH = "#ebffd2";

hold on % Keep the current plot active for adding new objects

% Define x-coordinates for colored background patches
x_p1 = [0 4.5 4.5 0];
x_p2 = [4.5 8.5 8.5 4.5];
x_p3 = [8.5 12.5 12.5 8.5];
x_p4 = [12.5 16.5 16.5 12.5];
x_p5 = [16.5 20.5 20.5 16.5];
x_p6 = [20.5 24.5 24.5 20.5];
x_p7 = [24.5 29 29 24.5];

% Define y-coordinates for colored background patches
y_p = [-5 -5 35 35];

% Create colored background patches for each category
patch(x_p1,y_p, hex2rgb(char(c_All)),'FaceAlpha',0.4,'EdgeColor','none')
patch(x_p2,y_p, hex2rgb(char(c_HH)),'FaceAlpha',0.4,'EdgeColor','none')
patch(x_p3,y_p, hex2rgb(char(c_WLO)),'FaceAlpha',0.4,'EdgeColor','none')
patch(x_p4,y_p, hex2rgb(char(c_AW)),'FaceAlpha',0.4,'EdgeColor','none')
patch(x_p5,y_p, hex2rgb(char(c_SS)),'FaceAlpha',0.4,'EdgeColor','none')
patch(x_p6,y_p, hex2rgb(char(c_OM)),'FaceAlpha',0.4,'EdgeColor','none')
patch(x_p7,y_p, hex2rgb(char(c_EH)),'FaceAlpha',0.4,'EdgeColor','none')

hold on % Keep the current plot active for adding new objects

% Plot each data point with its corresponding marker and color
for i=1:28
hold on
scatter(x(i,1),y(i,1),sz(i,1),hex2rgb(char(c(i,1))),"filled",mkr1(i,1));
end

hold on % Keep the current plot active for adding new objects

% Set y-axis limits
ylim([-5 35]);

% Uncomment the desired y-axis label for the plotted variable
% ylabel("RMSE (µg/L)")
% ylabel("RMSLE")
% ylabel("MAE")
% ylabel("R^2")
% ylabel("MAPE (%)")
% ylabel("MDAPE (%)")
% ylabel("\epsilon (%)")
ylabel("\beta (%)") % Currently showing ylabel for Y7_Beta

% Set x-axis label and limits
xlabel("Chl-a Models")
xlim([0 29]);

% Set x-axis tick labels
xticks(0:1:29);
xticklabels({'','M1','M8','M15','M22','M4','M11','M18','M25','M6','M13','M20','M27','M2','M9','M16','M23','M7','M14','M21','M28','M5','M12','M19','M26','M3','M10','M17', 'M24',''})

% Uncomment if a legend is desired
% lgd.Title.String = 'Classes';