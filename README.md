# PMEL-Hollings-eDNA-Hypoxia-2024
Eleanor Crotty's 2024 Hollings Scholarship project. Leveraging environmental DNA approaches to understand impacts of episodic hypoxia events on Olympic Coast National Marine Sanctuary marine ecosystems.

## Directories
- OCNMS_Hypoxia: Environmental data cleaning and combining. Main sources are OCNMS CTD casts and the Teawhit Head mooring's 42 meter depth sensor (TH042). The folder also includes satellite data and data from the Cha'ba NEMO mooring that I did not end up using.
- OCNMS_sample_metadata_zjd: Contains metadata and all Jonah Ventures outputs from the samples, as well as code to clean, pivot, and combine with the Ocean Molecular Ecology group's metadata.
- OCNMS_eDNA: Environmental DNA metadata and data cleaning and combining. Contains pivoted + combined with metadata eDNA species detection data, as well as code that cleans the species detection.
- OCNMS_Project: Combining the environmental DNA data with the environmental data. Also includes code to compare sampling dates from the metadata with the environmental data to identify gaps in the needed data.
- Each directory has subdirectories Data (inputs), Outputs (outputs, usually cleaned or filtered data), and Plots (any plots saved from code in the parent directory)

### Files in OCNMS_Hypoxia
- CTD_Data_Exploration.Rmd: Produces plots of CTD data and exports the clean CTD data, which is averaged over 30-45 meters depth in order to match the TH042 data.
- Mooring_Data_Exploration.Rmd: Produces plots of TH042 data and cleans the data from the mooring.
- CTD and Mooring _Data_Exploration.Rmd both include code to make the two datasets compatible by renaming variables, formatting the dates as POSIXct, etc.
- HypoxiaTimeSeries.Rmd: Combines CTD and mooring data and makes some graphs to compare them.
- NEMO_Data_Exploration.Rmd and Satellite_Data_Exploration.Rmd are both attempts at investigating alternate sources of data to fill the gap in data in 2023. These data sources did not agree well with TH042 in 2021-22, so I did not use them for 2023.

### Files in OCNMS_sample_metadata_zjd

### Files in OCNMS_eDNA

### Files in OCNMS_Project
