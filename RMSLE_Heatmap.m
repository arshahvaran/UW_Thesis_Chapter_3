% ----------------------------------------------------------------------------
% Header information:
% Filename: RMSLE_Heatmap.m
% ----------------------------------------------------------------------------
% Description: This script generates heatmaps of root mean square log error (RMSLE) values for different Marker Color Atmospheric Corrections (AC) and retrieval indexes in the input dataset. It displays the heatmaps in a 1x4 tiled layout, each corresponding to a subset of the data.
% ----------------------------------------------------------------------------
% Dependencies: MATLAB, readtable, heatmap, flipud, turbo (colormap)
% ----------------------------------------------------------------------------
% Input: Excel file ('CorrelationData.xlsx') containing data for the heatmaps, including the retrieval indexes, Marker Color Atmospheric Corrections, and RMSLE values.
% The above mentioned file is the organized subset of the output file derived eariler from the Corellation_Analysis.m code
% ----------------------------------------------------------------------------
% Output: A 1x4 tiled layout of heatmaps, displaying the RMSLE values for different Marker Color Atmospheric Corrections and retrieval indexes.
% ----------------------------------------------------------------------------
% Clear Command Window, workspace, and close all figures
clc
clear all
close all

% Read the CorrelationData.xlsx file into a table
T = readtable('CorrelationData.xlsx');

% Create a 1x4 tiled layout for subplots
tiledlayout(1,4)

% Set the index to choose a specific case for plotting (1-7)
j = 7; %1 for All, 2 for HH, 3 for WLO, 4 for AW, 5 for SS, 6 for EH, 7 for OM

% Loop through the data subsets (columns) based on the index (j)
for i=((4j)-3):4j
% Move to the next tile (subplot) in the tiled layout
nexttile
% Select a subset of the data table based on the current index (i)
Table = T(((270*(i-1))+1):(270*i),:);

% Create a heatmap with custom settings for display
h = heatmap(Table,'MarkerColor_AC','X','ColorVariable','Y3_RMSE','ColorMethod','none','Colormap',flipud(turbo),'ColorLimits',[0 0.7]);

% Rotate X-axis labels by 90 degrees
set(struct(h).NodeChildren(3), 'XTickLabelRotation', 90);

% Get the current axes
Ax = gca;

% Set heatmap's X-axis label to empty
h.XLabel = ''; 

% Set the heatmap's cell label format
h.CellLabelFormat = '%.2f';

% Hide the colorbar
h.ColorbarVisible = "off";

% Customize labels and display options for each subplot based on the index (i)
if i == ((4*j)-3)
    h.Title = '';
    h.YLabel = 'Indexes';
    h.XLabel = '';
end
if i == ((4*j)-2)
    h.Title = '';
    h.YLabel = '';
    h.XLabel = '';
    Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
end
if i == ((4*j)-1)
    h.Title = '';
    h.YLabel = '';
    h.XLabel = '';
    Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
end
if i == (4*j)
    h.Title = '';
    h.YLabel = '';
    h.XLabel = '';
    Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
end
end

% Rotate X-axis labels by 90 degrees for the last heatmap
set(struct(h).NodeChildren(3), 'XTickLabelRotation', 90);