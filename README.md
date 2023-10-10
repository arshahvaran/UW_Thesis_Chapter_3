# UW_Thesis_Chapter_2

**A Comprehensive Evaluation of Semi-Empirical Retrieval Schemes for Satellite-Based Chl-a Modelling in Oligo-Mesotrophic Waters: A Case Study of Western Lake Ontario**


**Ali Reza Shahvaran1,2,3,*, Homa Kheyrollah Pour2,4, and Philippe Van Cappellen1,3**


1 Ecohydrology Research Group, Department of Earth and Environmental Sciences, University of Waterloo, Ontario, Canada, N2L 3G1

2 Remote Sensing of Environmental Change (ReSEC) Research Group, Department of Geography and Environmental Studies, Wilfrid Laurier University, Waterloo, Ontario, Canada, N2L 3C5

3 Water Institute, University of Waterloo, Waterloo, Ontario, Canada, N2L 3G1

4 Cold Regions Research Centre, Wilfrid Laurier University, Waterloo, Ontario, Canada, N2L 3C5
  
  
  
This repository aims to serve as a comprehensive resource for researchers and professionals looking to leverage satellite-based Chl-a modeling for water quality analysis, particularly in oligo-mesotrophic waters.
  
  
  
## Repository Structure

  - AllData.xlsx: Contains the primary dataset used in this research. Preview here
  
  -  Python: Folder containing Python scripts.
  
      - Merge.py: Merges and preprocesses multiple Excel files.
    
      - RFImportance.py: Computes feature importance using Random Forest.
    
      - Models.py: Performs linear regressions on datasets.
    
      - CorrelationAnalysis.py: Computes correlation metrics between specified columns.
    
  -  MATLAB: Folder containing MATLAB scripts.
  
      - Rsquared_Heatmap.m: Generates heatmaps visualizing R2 values of products.
    
      - RFImportance_Barplots.m: Visualizes importance scores using stacked bar plots.
    
      - Mod_vs_Meas.m: Generates scatter plots of measured vs. modeled Chl-a concentrations.
    
      - CorrelationAnalysis.m: Produces scatter plots for different categories based on Excel data.
  
  
  
## Original Data Sources

- FRDR → https://doi.org/10.20383/102.0713

- HH Water Quality Data → https://data.ec.gc.ca/data/sites/areainterest/hamilton-harbour-area-of-concern/hamilton-harbour-water-quality-data/

- Great Lakes Nearshore - Water Chemistry → https://data.ontario.ca/dataset/water-chemistry-great-lakes-nearshore-areas) 

- Great Lakes Water Quality Monitoring and Surveillance Data → https://data-donnees.ec.gc.ca/data/substances/monitor/great-lakes-water-quality-monitoring-and-aquatic-ecosystem-health-data/

- USGS EarthExplorer (for Landsat) → https://earthexplorer.usgs.gov/

- Copernicus Data Hub (for Sentinel 2) → https://scihub.copernicus.eu/
  
  
  
## Usage

To execute the scripts, ensure the required dependencies are installed:

- For Python scripts: os, pandas, numpy, and sklearn.

- For MATLAB scripts: MATLAB environment.

Make sure to update paths to datasets and other files as necessary in each script.
  
  
  
## License

The code and data in this repository are licensed under CC BY 4.0.
  
  
  
## References
For any queries or further clarifications, please contact Ali Reza Shahvaran at alireza.shahvaran@uwaterloo.ca.

