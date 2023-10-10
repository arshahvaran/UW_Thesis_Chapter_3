% ----------------------------------------------------------------------------
% Header information:
% Author: Ali Reza Shahvaran
% Filename: Mod_vs_Meas.m
% License: CC BY 4.0
% ----------------------------------------------------------------------------
% Description: This script generates scatter plots of measured vs. modeled 
% Chl-a concentrations for different models. Each model's data is plotted 
% with its regression fit, 95% confidence intervals, and associated performance 
% metrics. The plots are color-coded based on the satellite data sources. 
% Finally, the performance metrics for all models are saved into a 'Report.xlsx' file.
% ----------------------------------------------------------------------------
% Dependencies: MATLAB
% ----------------------------------------------------------------------------
% Input: 
% - 'Lines.xlsx': A table containing metadata for each model and its associated performance metrics.
% - Multiple Excel files (e.g., "M_(L5_All).xlsx", "M_(L5_AW).xlsx",...), each containing measured 
%   and modeled Chl-a concentrations for a specific model. The filenames are sourced 
%   from the 'Lines.xlsx' and are dynamically read into the script.
% ----------------------------------------------------------------------------
% Output: 
% - Multiple scatter plots: Each showing measured vs. modeled Chl-a concentrations, 
%   regression fit, 95% confidence intervals, and performance metrics for a specific model.
% - 'Report.xlsx': An Excel file containing a summary of performance metrics 
%   for all the models processed.
% ----------------------------------------------------------------------------
clc
clear all
close all

% Define the color scheme for different satellites.
color_landsat5=[0, 0.4470, 0.7410];
color_landsat7=[0.8500 0.3250 0.0980];
color_landsat8=[0.9290 0.6940 0.1250];
color_sentinel2=[0.4940 0.1840 0.5560];

% Reading the input file.
L = readtable('Lines.xlsx');

% Initialize arrays for metrics.
n_values = zeros(28, 1);
RMSE_values = zeros(28, 1);
RMSLE_values = zeros(28, 1);
Bias_values = zeros(28, 1);
MAE_values = zeros(28, 1);
MAPE_values = zeros(28, 1);
MDAPE_values = zeros(28, 1);
epsilon_values = zeros(28, 1);
Beta_values = zeros(28, 1);
Rsquared_values = zeros(28, 1);

% Loop through each model and process its data.
    for i=1:28
    figure;
    T = readtable(strcat(L.Model{i}, ".xlsx"));
    
    % Assign a color based on the satellite.
    if i<8
        colori=color_landsat5;
    elseif i<15
        colori=color_landsat7;
    elseif i<22
        colori=color_landsat8;
    elseif i<29
        colori=color_sentinel2;
    end 
    
    % Extract the measured and modeled Chla values.
    Chla_Meas = table2array(T(:,"ChlA_Uncorrected__g_L"));
    Chla_Mod = table2array(T(:,"Modeled_Y"));
    
    % Plot the data points and set axis properties.
    h1=plot([0.1 140],[0.1 140],"--",LineWidth=1,Color='[0,0,0,0.75]');
    hold on
    h2=xline(7.3,"-g",Alpha=0.30,LineWidth=1);
    h3=yline(7.3,"-g",Alpha=0.30,LineWidth=1);
    h4=scatter(Chla_Meas,Chla_Mod,25,"filled","MarkerEdgeColor",colori,"MarkerFaceColor",colori,"MarkerFaceAlpha","0.4");
    xlim([0.1 140]);
    ylim([0.1 140]);
    
    % Adjust and fit the data.     
    Log_Chla_Meas_Continuous = linspace(min(log10(Chla_Meas)), max(log10(Chla_Meas)), 1000);
    
    % Filter out invalid indices where Chl-a measurements or models are zero or negative.
    valid_indices = (Chla_Meas > 0) & (Chla_Mod > 0);
    adjusted_Chla_Meas = Chla_Meas(valid_indices);
    adjusted_Chla_Mod = Chla_Mod(valid_indices);
    adjusted_Chla_Meas(adjusted_Chla_Meas < 1) = adjusted_Chla_Meas(adjusted_Chla_Meas < 1) + 1;
    adjusted_Chla_Mod(adjusted_Chla_Mod < 1) = adjusted_Chla_Mod(adjusted_Chla_Mod < 1) + 1;
    
    % Fit a linear regression to the log-transformed data. 
    [p, S] = polyfit(log10(adjusted_Chla_Meas), log10(adjusted_Chla_Mod), 1);
    yfit_log_continuous = polyval(p, Log_Chla_Meas_Continuous); 
    
    % Convert the log-transformed fitted values back to original scale.
    Chla_Meas_Continuous = 10.^Log_Chla_Meas_Continuous;
    yfit_continuous = 10.^yfit_log_continuous;
    
    % Update the plot with the fitted line and confidence intervals.    
    h5 = plot(Chla_Meas_Continuous, yfit_continuous, 'LineWidth', 1.5, 'Color', colori); 
    [yfit_delta_log, delta_log_continuous] = polyconf(p, Log_Chla_Meas_Continuous, S, 'predopt', 'curve'); 
    upper_bound_log_continuous = yfit_log_continuous + delta_log_continuous;
    lower_bound_log_continuous = yfit_log_continuous - delta_log_continuous;
    upper_bound_continuous = 10.^upper_bound_log_continuous;
    lower_bound_continuous = 10.^lower_bound_log_continuous;
    h6 = fill([Chla_Meas_Continuous, fliplr(Chla_Meas_Continuous)], [upper_bound_continuous, fliplr(lower_bound_continuous)], colori, 'FaceAlpha', 0.15, 'EdgeColor', 'none');
    
    % Style the plot.
    set(gca, 'YScale', 'log');
    set(gca, 'XScale', 'log');
    set(gca, 'TickLength',[0.05 0.05]);
    xlabel('Measured Chl-a (µg/L)');
    ylabel('Modeled Chl-a (µg/L)');
    pbaspect([1 1 1]);
    
    % Style the plot: remove axis labels and set axis properties.
    %set(gca,'YTickLabel',[]); %to remove y axis ticks
    ylabel(''); %to remove y axis label
    %set(gca,'XTickLabel',[]); %to remove x axis ticks
    xlabel(''); %to remove x axis label
    set(gca, 'Box', 'off'); 
    set(gca, 'XAxisLocation', 'bottom'); 
    set(gca, 'YAxisLocation', 'left'); 
    
    % Compute the metrics for the current model.    
    AC = string(table2array(L(i,"AtmosphericCorrection")));
    Mod = string(table2array(L(i,"Model_Name")));
    I = string(table2array(L(i,"Index_Number")));
    n = numel(Chla_Mod);
    R = corrcoef(log10(adjusted_Chla_Meas), log10(adjusted_Chla_Mod));
    Rsquared = R(1,2)^2;
    RMSLE = rmse(log10(adjusted_Chla_Mod), log10(adjusted_Chla_Meas));
    RMSE = rmse(adjusted_Chla_Mod, adjusted_Chla_Meas);
    MAPE = mape(adjusted_Chla_Mod, adjusted_Chla_Meas);
    MDAPE = median(abs((adjusted_Chla_Mod - adjusted_Chla_Meas) ./ adjusted_Chla_Meas)) * 100;
    MAE = 10^((1/n)*sum(abs(log10(adjusted_Chla_Mod)-log10(adjusted_Chla_Meas))));
    Bias = 10^((1/n)*sum((log10(adjusted_Chla_Mod)-log10(adjusted_Chla_Meas))));
    EPSILON = 100 * (10^(median(abs(log10(adjusted_Chla_Mod ./ adjusted_Chla_Meas)))) - 1);
    BETA = 100 * sign(median(log10(adjusted_Chla_Mod ./ adjusted_Chla_Meas))) * (10^(median(log10(adjusted_Chla_Mod ./ adjusted_Chla_Meas))) - 1);
    
    % Add annotations to the plot with model details and performance metrics.
    fontsize = 7.5;
    xpos1=10^-0.8;
    ypos1=10^1.95;
    xpos2=10^2.0;
    ypos2=10^0.05;
    text(xpos1,ypos1,['Model: ' num2str(Mod)],'FontSize', fontsize, 'fontweight', 'bold')
    text(xpos1,(ypos1/10^0.15),['Retrieval Index: I' num2str(I)],'FontSize', fontsize, 'fontweight', 'bold')
    text(xpos1,(ypos1/10^0.30),['Atmospheric Correction: ' num2str(AC)],'FontSize', fontsize, 'fontweight', 'bold')
    text(xpos1,(ypos1/10^0.45),sprintf('n = %.0f',n),'FontSize', fontsize, 'fontweight', 'bold')
    text(xpos1,(ypos1/10^0.60),sprintf('Slope = %.2f',p(1)),'FontSize', fontsize, 'fontweight', 'bold')
    %text(xpos2,(ypos2/10^0.40),sprintf('RMSLE = %.2f',RMSLE),'FontSize', fontsize, 'fontweight', 'bold','HorizontalAlignment','right') %
    text(xpos2,(ypos2/10^0.55),sprintf('RMSE (µg/L) = %.2f',RMSE),'FontSize', fontsize, 'fontweight', 'bold','HorizontalAlignment','right') %
    text(xpos2,(ypos2/10^0.7),sprintf('R^2 = %.2f',Rsquared),'FontSize', fontsize,'HorizontalAlignment','right') %
    
    % Disable the grid and add legend.
    grid off
    legend([h1 h5 h6],{'Data','Fit','95% CI'},"Location",'northeast',"FontSize",fontsize)
    hold off;
    
    % Store the computed metrics.
    n_values(i) = n;
    RMSE_values(i) = RMSE;
    RMSLE_values(i) = RMSLE;
    Bias_values(i) = Bias;
    MAE_values(i) = MAE;
    MAPE_values(i) = MAPE;
    MDAPE_values(i) = MDAPE;
    epsilon_values(i) = EPSILON;
    Beta_values(i) = BETA;
    Rsquared_values(i) = Rsquared;
    end

% Add the metrics to the table and save as an Excel file.
L.n = n_values;
L.RMSE = RMSE_values;
L.RMSLE = RMSLE_values;
L.Bias = Bias_values;
L.MAE = MAE_values;
L.MAPE = MAPE_values;
L.MDAPE = MDAPE_values;
L.epsilon = epsilon_values;
L.Beta = Beta_values;
L.R2 = Rsquared_values;
writetable(L, 'Report.xlsx');
save('Mod_vS_Meas.mat');