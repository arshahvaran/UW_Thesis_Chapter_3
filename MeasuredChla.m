% ----------------------------------------------------------------------------
% Header information:
% Author: Ali Reza Shahvaran
% Filename: MeasuredChla
% License: CC BY 4.0
% ----------------------------------------------------------------------------
% Description: This script reads data from 'MeasuredChla.xlsx', extracts the X and Y data for different satellite types, and plots the data using different symbols and colors for each dataset.
% ----------------------------------------------------------------------------
% Dependencies: MATLAB R2022b
% ----------------------------------------------------------------------------
% Input: MeasuredChla.xlsx - An Excel file containing measured Chl-a concentration data.
% - All of the abovementioned file is a subset of the original file "AllData.xlsx"
% ----------------------------------------------------------------------------
% Output: A scatter plot showing the Chl-a concentration for different satellite types.
% ----------------------------------------------------------------------------
% Clear the workspace, close all open figures, and clear the command window
clc
clear all
close all

% Load data from 'MeasuredChla.xlsx' and store it in a table
MeasuredChla = readtable('MeasuredChla.xlsx','Range','A1:D608');

% Extract X and Y data for Landsat 5 HH and convert date format
X_L5_HH = table2array(MeasuredChla(1:125,"Sampling_Date"));
Y_L5_HH = table2array(MeasuredChla(1:125,"ChlA_Uncorrected__g_L"));
t_L5_HH = datestr(datetime(X_L5_HH,'InputFormat','uuuu-MM-dd''T''HH:mm:ss.SS''Z','TimeZone','UTC'),'yyyy-mm-dd HH:MM:SS');

% Extract X and Y data for Landsat 5 WLO and convert date format
X_L5_WLO = table2array(MeasuredChla(126:207,"Sampling_Date"));
Y_L5_WLO = table2array(MeasuredChla(126:207,"ChlA_Uncorrected__g_L"));
t_L5_WLO = datestr(datetime(X_L5_WLO,'InputFormat','uuuu-MM-dd''T''HH:mm:ss.SS''Z','TimeZone','UTC'),'yyyy-mm-dd HH:MM:SS');

% Extract X and Y data for Landsat 7 HH and convert date format
X_L7_HH = table2array(MeasuredChla(208:372,"Sampling_Date"));
Y_L7_HH = table2array(MeasuredChla(208:372,"ChlA_Uncorrected__g_L"));
t_L7_HH = datestr(datetime(X_L7_HH,'InputFormat','uuuu-MM-dd''T''HH:mm:ss.SS''Z','TimeZone','UTC'),'yyyy-mm-dd HH:MM:SS');

% Extract X and Y data for Landsat 7 WLO and convert date format
X_L7_WLO = table2array(MeasuredChla(373:429,"Sampling_Date"));
Y_L7_WLO = table2array(MeasuredChla(373:429,"ChlA_Uncorrected__g_L"));
t_L7_WLO = datestr(datetime(X_L7_WLO,'InputFormat','uuuu-MM-dd''T''HH:mm:ss.SS''Z','TimeZone','UTC'),'yyyy-mm-dd HH:MM:SS');

% Extract X and Y data for Landsat 8 HH and convert date format
X_L8_HH = table2array(MeasuredChla(430:532,"Sampling_Date"));
Y_L8_HH = table2array(MeasuredChla(430:532,"ChlA_Uncorrected__g_L"));
t_L8_HH = datestr(datetime(X_L8_HH,'InputFormat','uuuu-MM-dd''T''HH:mm:ss.SS''Z','TimeZone','UTC'),'yyyy-mm-dd HH:MM:SS');

% Extract X and Y data for Landsat 8 WLO and convert date format
X_L8_WLO = table2array(MeasuredChla(533:556,"Sampling_Date"));
Y_L8_WLO = table2array(MeasuredChla(533:556,"ChlA_Uncorrected__g_L"));
t_L8_WLO = datestr(datetime(X_L8_WLO,'InputFormat','uuuu-MM-dd''T''HH:mm:ss.SS''Z','TimeZone','UTC'),'yyyy-mm-dd HH:MM:SS');

% Extract X and Y data for Sentinel 2
% HH and convert date format
X_S2_HH = table2array(MeasuredChla(557:580,"Sampling_Date"));
Y_S2_HH = table2array(MeasuredChla(557:580,"ChlA_Uncorrected__g_L"));
t_S2_HH = datestr(datetime(X_S2_HH,'InputFormat','uuuu-MM-dd''T''HH:mm:ss.SS''Z','TimeZone','UTC'),'yyyy-mm-dd HH:MM:SS');

% Extract X and Y data for Sentinel 2 WLO and convert date format
X_S2_WLO = table2array(MeasuredChla(581:607,"Sampling_Date"));
Y_S2_WLO = table2array(MeasuredChla(581:607,"ChlA_Uncorrected__g_L"));
t_S2_WLO = datestr(datetime(X_S2_WLO,'InputFormat','uuuu-MM-dd''T''HH:mm:ss.SS''Z','TimeZone','UTC'),'yyyy-mm-dd HH:MM:SS');

% Create timeseries objects for each dataset
ts_L5_HH = timeseries(Y_L5_HH,t_L5_HH);
ts_L5_WLO = timeseries(Y_L5_WLO,t_L5_WLO);
ts_L7_HH = timeseries(Y_L7_HH,t_L7_HH);
ts_L7_WLO = timeseries(Y_L7_WLO,t_L7_WLO);
ts_L8_HH = timeseries(Y_L8_HH,t_L8_HH);
ts_L8_WLO = timeseries(Y_L8_WLO,t_L8_WLO);
ts_S2_HH = timeseries(Y_S2_HH,t_S2_HH);
ts_S2_WLO = timeseries(Y_S2_WLO,t_S2_WLO);

% Define colors and transparency for plotting
color_L5 = [0, 0.4470, 0.7410];
color_L7 = [0.8500, 0.3250, 0.0980];
color_L8 = [0.9290, 0.6940, 0.1250];
color_S2 = [0.4940, 0.1840, 0.5560];
alpha = 0.3;

% Plot data using different symbols and colors for each dataset
scatter(X_L5_HH,Y_L5_HH,"filled","diamond","MarkerFaceColor",color_L5,"MarkerEdgeColor",color_L5,'MarkerFaceAlpha',alpha,'MarkerEdgeAlpha',1);
hold on
scatter(X_L5_WLO,Y_L5_WLO,"filled","square","MarkerFaceColor",color_L5,"MarkerEdgeColor",color_L5,'MarkerFaceAlpha',alpha,'MarkerEdgeAlpha',1);
scatter(X_L7_HH,Y_L7_HH,"filled","diamond","MarkerFaceColor",color_L7,"MarkerEdgeColor",color_L7,'MarkerFaceAlpha',alpha,'MarkerEdgeAlpha',1);
scatter(X_L7_WLO,Y_L7_WLO,"filled","square","MarkerFaceColor",color_L7,"MarkerEdgeColor",color_L7,'MarkerFaceAlpha',alpha,'MarkerEdgeAlpha',1);
scatter(X_L8_HH,Y_L8_HH,"filled","diamond","MarkerFaceColor",color_L7,"MarkerEdgeColor",color_L8,'MarkerFaceAlpha',alpha,'MarkerEdgeAlpha',1);
scatter(X_L8_WLO,Y_L8_WLO,"filled","square","MarkerFaceColor",color_L7,"MarkerEdgeColor",color_L8,'MarkerFaceAlpha',alpha,'MarkerEdgeAlpha',1);
scatter(X_S2_HH,Y_S2_HH,"filled","diamond","MarkerFaceColor",color_S2,"MarkerEdgeColor",color_S2,'MarkerFaceAlpha',alpha,'MarkerEdgeAlpha',1);
scatter(X_S2_WLO,Y_S2_WLO,"filled","square","MarkerFaceColor",color_S2,"MarkerEdgeColor",color_S2,'MarkerFaceAlpha',alpha,'MarkerEdgeAlpha',1);

% Set date ticks for the x-axis and format labels
dn_tk=datetime([2000:1:2022],1,0,0,0,0);
set(gca,'xtick',dn_tk)
datetick('x','yy','keeplimits')
xticklabels([2000:1:2022])

% Set x and y axis labels
xlabel('in-situ Measurment Time')
ylabel('In-situ Chl-a Concentration (ug/L)')
xlim padded

% Add legend for the different datasets
legend('Landsat 5 (HH)','Landsat 5 (WLO)','Landsat 7 (HH)','Landsat 7 (WLO)','Landsat 8 (HH)','Landsat 8 (WLO)','Sentinel 2 (HH)','Sentinel 2 (WLO)','Location','northeast','NumColumns',2)

% Get y-axis tick values
yticks1 = [get(gca,'ytick')];

% Create a secondary y-axis on the right with log scale values
yyaxis right
set(gca,'ytick',yticks1/140);
set(gca,'yticklabel',num2cell(transpose(round(log10(yticks1),1))));
set(gca,'ycolor','k')
ylabel('In-situ Log(Chl-a) Concentration (ug/L)')
% yticks = [get(gca,'ytick')]'; % There is a transpose operation here.
% percentsy = repmat('%', length(yticks),1);  %  equal to the size
% yticklabel = [num2str(yticks) percentsy]; % concatenates the tick labels 
% set(gca,'yticklabel',yticklabel)% Sets tick labels back on the Axis
% #ffffcc
% #c2e699
% #78c679
% #238443


