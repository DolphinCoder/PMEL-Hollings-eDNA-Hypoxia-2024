# PMEL-Hollings-eDNA-Hypoxia-2024
Eleanor Crotty's 2024 Hollings Scholarship project. Leveraging environmental DNA approaches to understand impacts of episodic hypoxia events on Olympic Coast National Marine Sanctuary marine ecosystems. In addition to this README file, this repository also contains several PDF files called "Hollings Project Workflow *", which are flowcharts explaining how all of these .Rmd files and data sources connect, focused on the inputs and outputs that are critical to follow my workflow and generate the final dataset of species detections with associated environmental data.

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

[Hollings Project Workflow-EnvData.pdf](https://github.com/user-attachments/files/16059843/Hollings.Project.Workflow-EnvData.pdf)

### Files in OCNMS_sample_metadata_zjd
- JV = Jonah Ventures, the DNA metabarcoding service we use (sic, this is my understanding from lab meetings)
- /OCNMS/JV_bioinformatics contains the results of DNA metabarcoding from the OCNMS eDNA samples.
- OCNMS_JV2_sample_metadata.Rmd is an example of how to filter the data, focused on Alaska
- eDNA_SampleData_Exploration.Rmd: Imports the MiFish and CO1 Universal primer datasets (primer_tab+taxa.csv), the Jonah Ventures metadata, and the Ocean Molecular Ecology group metadata. It cleans the metadata, pivots the species detection metabarcoding data so that each sample + species detection combination is a row, and combines the species detection data with the metadata.
- Exports cleaned eDNA data to OCNMS_eDNA

### Files in OCNMS_eDNA
- EnvironmentalDataxSampleDates.Rmd: Imports Ocean Molecular Ecology group metadata, extracts DNA sampling dates, and plots these over the full environmental data time series to identify data gaps and visualize the full set of data.
- OCNMS_eDNA_Exploration.Rmd: Imports the cleaned eDNA detections data and the OCNMS species of interest list, filters out only the species detections on the list of interest and exports those.

[Hollings Project Workflow-eDNA.pdf](https://github.com/user-attachments/files/16059847/Hollings.Project.Workflow-eDNA.pdf)

### Files in OCNMS_Project
- EnvironmentalData2.Rmd combines satellite data with CTD and mooring data and makes some plots of this. Satellite data is not consistent with data at depth so I did not use it.
- OCNMS_SpeciesDetections_Cleaning.Rmd: Imports species detections on the OCNMS species of interest list, makes a variable for presence and absence, and then filters for species that are present in at least 10 samples.
- eDNAxEnvData.Rmd: Cleans eDNA and environmental data so that they are compatible, and joins them by datetime (rounded to the nearest 10 minutes) and plots them on top of each other. This produces eDNAxEnvData.csv, a dataset with each species detection in the 4 species of interest with more than 10 detection dates + the associated environmental data from the TH042 mooring.

[Hollings Project Workflow.pdf](https://github.com/user-attachments/files/16059851/Hollings.Project.Workflow.pdf)
