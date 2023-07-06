% ----------------------------------------------------------------------------
% Header information:
% Author: Ali Reza Shahvaran
% Filename: Mod_vs_Meas2.m
% License: CC BY 4.0
% Version: 2.0
% ----------------------------------------------------------------------------
% Description: This script generates a scatter plot of measured vs. modeled Chl-a concentrations, along with their regression fit, 95% confidence intervals, and several performance metrics. The plot is customized with different colors for different satellite data sources.
% ----------------------------------------------------------------------------
% Dependencies: MATLAB
% ----------------------------------------------------------------------------
% Input: Data from 'M27.xlsx' containing measured and modeled Chl-a concentrations, 'Lines.xlsx' containing metadata and performance metrics.
% The above mentioned file is the organized subset of the output file derived eariler from the Regression_Analysis.m code (or approaching the Regression Learner App directly).
% ----------------------------------------------------------------------------
% Output: A scatter plot with measured vs. modeled Chl-a concentrations, regression fit, 95% confidence intervals, and performance metrics.
% ----------------------------------------------------------------------------
% Explanation of code sections:

% 1. Clear previous variables and close any open figures
% 2. Read input data from the M27.xlsx file
% 3. Set the color scheme for different satellite sensors
% 4. Choose color based on the input data (i) for different satellite sensors
% 5. Read input data from the Lines.xlsx file
% 6. Extract data from input tables and perform calculations
% 7. Create scatter plot of measured vs. modeled Chl-a
% 8. Add reference lines for 7.3 µg/L threshold
% 9. Fit a linear regression model to log-transformed Chl-a data
% 10. Calculate R-squared value
% 11. Create a plot of the regression line
% 12. Add 95% confidence interval to the plot
% 13. Set axes to log scale and customize tick length
% 14. Add labels to axes and maintain aspect ratio
% 15. Add 1:1 line to the plot
% 16. Remove axis tick labels
% 17. Extract metadata from the Lines.xlsx table
% 18. Compute various performance metrics
% 19. Define text positions and font size
% 20. Add text annotations to the plot
% 21. Remove grid
% 22. Add legend to the plot


% Clear Command Window, workspace, and close all figures
clc
clear all
close all

% Read the M27.xlsx file into a table
T = readtable('M27.xlsx');
i=27;

% Define colors for different satellites
color_landsat5=[0, 0.4470, 0.7410];
color_landsat7=[0.8500 0.3250 0.0980];
color_landsat8=[0.9290 0.6940 0.1250];
color_sentinel2=[0.4940 0.1840 0.5560];

% Assign color based on the index (i)
if i<8
colori=color_landsat5;
elseif i<15
colori=color_landsat7;
elseif i<22
colori=color_landsat8;
elseif i<29
colori=color_sentinel2;
end

% Read the Lines.xlsx file into a table
L = readtable('Lines.xlsx');

% Extract relevant data from the M27.xlsx table
Log_Chla_Meas=table2array(T(:,"Log_ChlA"));
Log_Chla_Mod=table2array(T(:,"Mod"));
Chla_Meas = table2array(T(:,"ChlA_Uncorrected__g_L"));
Chla_Mod = 10.^table2array(T(:,"Mod"));

% Create scatter plot of measured vs. modeled Chl-a
h1=scatter(Chla_Meas,Chla_Mod,25,"filled","MarkerEdgeColor",colori,"MarkerFaceColor",colori,"MarkerFaceAlpha","0.4");
xlim([0.1 140]);
ylim([0.1 140]);

hold on

% Plot lines at Chl-a concentration of 7.3 for both axes
h2=xline(7.3,"-g",Alpha=0.30,LineWidth=1);
h3=yline(7.3,"-g",Alpha=0.30,LineWidth=1);

% Perform linear regression on log-transformed data
p1 = polyfit(log10(Chla_Meas),log10(Chla_Mod),1);

% Compute R-squared value
Rsquared = 1 - sum((log10(Chla_Mod) - (p1(1) * log10(Chla_Meas) + p1(2))).^2)/((length(log10(Chla_Mod))-1) * var(log10(Chla_Mod)));

% Generate data for the regression line
x1=min(Chla_Meas):0.1:max(Chla_Meas);
x2=log10(x1);
y1=p1(1,1)*x2+p1(1,2);
y2=10.^(y1);
h4=plot(x1,y2,LineWidth=1.5,Color=colori);

% Perform linear regression and compute confidence intervals
[p2,s] = polyfit(log10(Chla_Meas),log10(Chla_Mod),1);
[yfit,dy] = polyconf(p2,x2,s,'predopt','curve');
h5 = patch([x1 fliplr(x1)], [10.^(yfit-dy) fliplr(10.^(yfit+dy))], '','FaceColor',colori,'EdgeColor','none','FaceAlpha',0.15);

% Set both axes to logarithmic scale
set(gca, 'YScale', 'log');
set(gca, 'XScale', 'log');

% Set tick length
set(gca, 'TickLength',[0.05 0.05]);

% Label axes
xlabel('Measured Chl-a (µg/L)');
ylabel('Modeled Chl-a (µg/L)');
pbaspect([1 1 1]);

% Add 1:1 line to the plot
h6=plot([0.1 140],[0.1 140],"--",LineWidth=1,Color='[0,0,0,0.75]');

% Remove axis tick labels
set(gca,'YTickLabel',[]);
ylabel('');
set(gca,'XTickLabel',[]);
xlabel('');

% Extract metadata from the Lines.xlsx table
AC = string(table2array(L(i,"AtmosphericCorrection")));
Mod = string(table2array(L(i,"Model")));
I = string(table2array(L(i,"Index")));
RegType = string(table2array(L(i,"RegType")));

% Compute various performance metrics
n = numel(Log_Chla_Meas);
RMSLE = rmse(Log_Chla_Mod, Log_Chla_Meas);
RMSE = rmse(Chla_Mod, Chla_Meas);
MAPE = mape(Chla_Mod, Chla_Meas);
MDAPE = 100median( ((Chla_Mod-Chla_Meas))./Chla_Meas , 'all' );
MAE = 10^((1/n)sum(abs(Log_Chla_Mod-Log_Chla_Meas)));
Bias = 10^((1/n)sum((Log_Chla_Mod-Log_Chla_Meas)));
epsilon=100((10.^(median(abs(log10(Chla_Mod./Chla_Meas)))))-1);
beta=100sign(median(log10(Chla_Mod./Chla_Meas)))((10.^(median(log10(Chla_Mod./Chla_Meas))))-1);

% Define text positions and font size
fontsize = 7;
xpos1=10^-0.8;
ypos1=10^2.0;
xpos2=10^2.0;
ypos2=10^0.00;

% Add text annotations to the plot
text(xpos1,ypos1,['Model: ' num2str(Mod)],'FontSize', fontsize, 'fontweight', 'bold')
text(xpos1,(ypos1/10^0.1),['Retrieval Index: ' num2str(I)],'FontSize', fontsize, 'fontweight', 'bold')
text(xpos1,(ypos1/10^0.2),['Atmospheric Correction: ' num2str(AC)],'FontSize', fontsize, 'fontweight', 'bold')
text(xpos1,(ypos1/10^0.3),['Regression: ' num2str(RegType)],'FontSize', fontsize, 'fontweight', 'bold')
text(xpos1,(ypos1/10^0.4),sprintf('n = %.0f',n),'FontSize', fontsize, 'fontweight', 'bold')
text(xpos1,(ypos1/10^0.5),sprintf('Slope = %.2f',p1(1,1)),'FontSize', fontsize, 'fontweight', 'bold')
text(xpos2,(ypos2/10^0.6),sprintf('RMSLE = %.2f',RMSLE),'FontSize', fontsize, 'fontweight', 'bold','HorizontalAlignment','right')
text(xpos2,(ypos2/10^0.7),sprintf('R^2 = %.2f',Rsquared),'FontSize', fontsize,'HorizontalAlignment','right')

% Remove grid
grid off

% Add legend
legend([h1 h4 h5],{'Data','Fit','95% CI'},"Location",'northeast',"FontSize",fontsize)

