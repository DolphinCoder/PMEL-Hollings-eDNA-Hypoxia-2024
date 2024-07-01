# PMEL-Hollings-eDNA-Hypoxia-2024
Eleanor Crotty's 2024 Hollings Scholarship project. Leveraging environmental DNA approaches to understand impacts of episodic hypoxia events on Olympic Coast National Marine Sanctuary marine ecosystems.

## Directories
- OCNMS_Hypoxia: Environmental data cleaning and combining. Main sources are OCNMS CTD casts and the Teawhit Head mooring's 42 meter depth sensor. The folder also includes satellite data and data from the Cha'ba NEMO mooring that I did not end up using.
- OCNMS_sample_metadata_zjd: Contains metadata and all Jonah Ventures outputs from the samples, as well as code to clean, pivot, and combine with the Ocean Molecular Ecology group's metadata.
- OCNMS_eDNA: Environmental DNA metadata and data cleaning and combining. Contains pivoted + combined with metadata eDNA species detection data, as well as code that cleans the species detection.
- OCNMS_Project: Combining the environmental DNA data with the environmental data. Also includes code to compare sampling dates from the metadata with the environmental data to identify gaps in the needed data.
- Each directory has subdirectories Data (inputs), Outputs (outputs, usually cleaned or filtered data), and Plots (any plots saved from code in the parent directory)

## Files in OCNMS_Hypoxia
- CTD_Data_Exploration.Rmd: Produces plots of CTD data and exports the clean CTD data, which is averaged over 30-45 meters depth in order to match the TH042 data.
- Mooring_Data_Exploration.Rmd:
- HypoxiaTimeSeries.Rmd: 

## Files in OCNMS_sample_metadata_zjd

## Files in OCNMS_eDNA

## Files in OCNMS_Project
