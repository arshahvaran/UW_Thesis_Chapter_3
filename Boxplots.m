
% ----------------------------------------------------------------------------
% Header information:
% Author: Ali Reza Shahvaran
% Filename: Boxplots
% License: CC BY 4.0
% ----------------------------------------------------------------------------
% Description: This script generates boxplots for different classifications of in-situ Chl-a concentration.
% ----------------------------------------------------------------------------
% Dependencies: MATLAB R2022b
% ----------------------------------------------------------------------------
% Input: The script reads data from the following .xlsx files:
% - All.xlsx
% - Area.xlsx
% - Seasonality.xlsx
% - TSI.xlsx
% - All of the abovementioned files are a subset of the original file "AllData.xlsx"
% ----------------------------------------------------------------------------
% Output: The script generates a figure containing four boxplots
% ----------------------------------------------------------------------------


% Clear workspace, close all open figures, and clear command window
clc;
clear all;
close all;

% Load a built-in MATLAB dataset (irrelevant in this script, can be ignored)
load carsmall

% Create a tiled layout for multiple subplots
t = tiledlayout(1,4);
t.TileSpacing = 'none';

% ---------------------- First Boxplot ----------------------

% Select the next tile in the layout
nexttile

% Read data from the 'All.xlsx' file and create a table
T_All = readtable('All.xlsx','Range','A1:A607');
T_All=T_All{:,:};

% Create a boxplot with custom widths, labels, and symbol
b1 = boxplot(T_All,'Widths',0.15,'Labels',{''},'Symbol','+k');

% Add y-axis label
ylabel('In-situ Chl-a Concentration (ug/L)')

% Add x-axis label
xlabel('All')

% Define the color for the boxplot
str_All = '#FFFFFF';
color_All = sscanf(str_All(2:end),'%2x%2x%2x',[1 3])/255;
colors_All = transpose([color_All(:)]);

% Customize the appearance of the boxplot
h = findobj(gca,'Tag','Box');
for j=1:length(h)
patch(get(h(j),'XData'),get(h(j),'YData'),colors_All(j,:),'FaceAlpha',.5);
end

% Turn on y-axis grid and turn off x-axis grid
set(gca, 'YGrid', 'on', 'XGrid', 'off')

% Add a reference line at y=7.3 with custom appearance
yline(7.3,"-g",Alpha=0.30,LineWidth=1);

% ---------------------- Second Boxplot ----------------------

% Select the next tile in the layout
nexttile

% Read data from the 'Area.xlsx' file and create a table
T_Area = readtable('Area.xlsx','Range','A1:B417');
T_Area=T_Area{:,:};

% Create a boxplot with custom widths, labels, and symbol
b2 = boxplot(T_Area,'Widths',0.3,'Labels',{'Hamilton Harbour','Western Lake Ontario'},'Symbol','+k');

% Remove y-axis tick labels
set(gca,'yticklabel',{[]})

% Add x-axis label
xlabel({'Area';'Classification'},'Position',[1.5 130],'VerticalAlignment','top','HorizontalAlignment','center')

% Define the colors for the boxplot
str_HH = '#989898';
str_WLO = '#d1d1d1';
color_HH = sscanf(str_HH(2:end),'%2x%2x%2x',[1 3])/255;
color_WLO = sscanf(str_WLO(2:end),'%2x%2x%2x',[1 3])/255;
colors_Area = transpose([color_HH(:), color_WLO(:)]);

% Customize the appearance of the boxplot
h = findobj(gca,'Tag','Box');
for j=1:length(h)
patch(get(h(j),'XData'),get(h(j),'YData'),colors_Area(j,:),'FaceAlpha',.5);
end

% Turn on y-axis grid and turn off x-axis grid, and rotate x-axis labels
set(gca, 'YGrid', 'on', 'XGrid', 'off','XTickLabelRotation',90)

% Add a reference line at y=7.3 with custom appearance
yline(7.3,"-g",Alpha=0.30,LineWidth=1);

% ---------------------- Third Boxplot ----------------------

% Select the next tile in the layout
nexttile

% Read data from the 'Seasonality.xlsx' file and create a table
T_Seasonality = readtable('Seasonality.xlsx','Range','A1:B700');
T_Seasonality=T_Seasonality{:,:};

% Create a boxplot with custom widths, labels, and symbol
b3 = boxplot(T_Seasonality,'Widths',0.3,'Labels',{'Autumn / Winter','Spring / Summer'},'Symbol','+k');

% Remove y-axis tick labels
set(gca,'yticklabel',{[]})

% Add x-axis label
xlabel({'Seasonality';'Classification'},'Position',[1.5 130],'VerticalAlignment','top','HorizontalAlignment','center')

% Define the colors for the boxplot
str_AW = '#a8eeff';
str_SS = '#ffb9a8';
color_AW = sscanf(str_AW(2:end),'%2x%2x%2x',[1 3])/255;
color_SS = sscanf(str_SS(2:end),'%2x%2x%2x',[1 3])/255;
colors_Seasonality = transpose([color_AW(:), color_SS(:)]);

% Customize the appearance of the boxplot
h = findobj(gca,'Tag','Box');
for j=1:length(h)
patch(get(h(j),'XData'),get(h(j),'YData'),colors_Seasonality(j,:),'FaceAlpha',.5);
end

% Turn on y-axis grid and turn off x-axis grid, and rotate x-axis labels
set(gca, 'YGrid', 'on', 'XGrid', 'off','XTickLabelRotation',90)

% Add a reference line at y=7.3 with custom appearance
yline(7.3,"-g",Alpha=0.30,LineWidth=1);

% ---------------------- Fourth Boxplot ----------------------

% Select the next tile in the layout
nexttile

% Read data from the 'TSI.xlsx' file and create a table
T_TSI = readtable('TSI.xlsx','Range','A1:B700');
T_TSI=T_TSI{:,:};

% Create a boxplot with custom widths, labels, and symbol
b4 = boxplot(T_TSI,'Widths',0.3,'Labels',{'Oligotrophic / Mesotrophic','Eutrophic / Hypereutrophic'},'Symbol','+k');

% Remove y-axis tick labels
set(gca,'yticklabel',{[]})

% Add x-axis label
xlabel({'TSI';'Classification'},'Position',[1.5 130],'VerticalAlignment','top','HorizontalAlignment','center')

% Define the colors for the boxplot
str_OM = '#d7ffa6';
str_EH = '#9fff2c';
color_OM = sscanf(str_OM(2:end),'%2x%2x%2x',[1 3])/255;
color_ES = sscanf(str_EH(2:end),'%2x%2x%2x',[1 3])/255;
colors_TSI = transpose([color_OM(:), color_ES(:)]);

% Customize the appearance of the boxplot
h = findobj(gca,'Tag','Box');
for j=1:length(h)
patch(get(h(j),'XData'),get(h(j),'YData'),colors_TSI(j,:),'FaceAlpha',.5);
end

% Turn on y-axis grid and turn off x-axis grid, and rotate x-axis labels
set(gca, 'YGrid', 'on', 'XGrid', 'off','XTickLabelRotation',90)

% Add a reference line at y=7.3 with custom appearance
yline(7.3,"-g",Alpha=0.30,LineWidth=1);

% ---------------------- Color Definitions ----------------------

% This section defines the colors used in the boxplots above, but is not
% necessary for the execution of the script, as colors were already defined and
% applied in the boxplot sections.

% color_All="#FFFFFF";
% color_HH="#989898";
% color_WLO="#d1d1d1";
% color_AW="#a8eeff";
% color_SS="#ffb9a8";
% color_EH="#9fff2c";
% color_OM="#d7ffa6";