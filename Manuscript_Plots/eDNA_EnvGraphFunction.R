# This is a function to graph species presence and absence data over an environmental variable. 
# Both should have dates in POSIXct.

# This needs to be customized per script
# Don't expect it to be adaptable to much else due to all the janky stuff I've added.
# Things that don't adapt well: EllaInterest is manually added stats, and 
# PlotBase comes from whatever the full set of environmental data is named
# HypoxiaDots will prooobably cause problems

library(tidyverse)
library(ggbreak)
# Define highlight rectangles
sampleHighlight <- tibble(x1b = as.POSIXct("2021-08-25"), x1e = as.POSIXct("2021-10-08"), 
                          x2b = as.POSIXct("2022-06-23"), x2e = as.POSIXct("2022-07-19"),
                          x3b = as.POSIXct("2022-08-22"), x3e = as.POSIXct("2022-09-21"),
                          y1 = -Inf, y2 = +Inf)

SampHighlight1 <- geom_rect(data = sampleHighlight,
                            inherit.aes = FALSE,
                            mapping = aes(xmin = x1b, xmax = x1e,
                                          ymin = y1, ymax = y2),
                            color = "black",
                            fill = "gray50",
                            stroke = 2,
                            alpha = 0.2)
SampHighlight2 <- geom_rect(data = sampleHighlight,
                            inherit.aes = FALSE,
                            mapping = aes(xmin = x2b, xmax = x2e,
                                          ymin = y1, ymax = y2),
                            color = "black",
                            fill = "gray50",
                            stroke = 2,
                            alpha = 0.2)
SampHighlight3 <- geom_rect(data = sampleHighlight,
                            inherit.aes = FALSE,
                            mapping = aes(xmin = x3b, xmax = x3e,
                                          ymin = y1, ymax = y2),
                            color = "black",
                            fill = "gray50",
                            stroke = 2,
                            alpha = 0.2)
presenceGraphVars <- function() { # Function that reminds me of all the parameter names
  print("df, envCond, filename, filepath, title, ylab, widthpx = 2500, heightpx = 2000, threshold, thresholdLvl = 0")
}

# Main graphing function
eDNAGraph <- function(df, # Dataframe of species presence/absence + environmental factors
                          envCond, # Environmental condition VARIABLE name for plotting, as a string
                          envCondName = "EnvCondName", # Environmental condition name for export filename and plot title
                          filepath = here("eDNA_Index_Hypoxia", "Plots", "eDNAxDO"), # Where to save the file for export (a directory)
                          ylab = "Environmental Data", # Y axis label
                          widthpx = 2500, # Width for export (pixels)
                          heightpx = 2000, # Height for export (pixels)
                          threshold = T, # Whether or not to draw a horizontal line with a "threshold" for the environmental factor
                          thresholdLvl = 0 # If threshold = T, y-intercept of the horizontal line
                          ) {
  print("HEADS UP: Date/time must be called exactly date and be in POSIXct, and envCond must be entered as a string (in quotes)")
  print("If you don't want a threshold line, set threshold = F instead of setting a thresholdLvl")
  print("Also for some reason you have to press 1 to confirm this function. Don't worry about it.")

  dfsplit <- split(df, df$Species) # Divide the input by species

  for (i in 1:length(dfsplit)) { # For each species: 
    species <- dfsplit[[i]]$Species[1] # Species name for title and export png name
    print(species) 
    title <- paste(paste(species, sep = " ", "eDNA Index vs"), sep = " ", envCondName) # Plot title, changed for eDNA
    print(title)
    
    # Omitted statistics
    # Omitted hypoxic dots
    
    plotbase <- ggplot(data = envData, aes(x = date, y = .data[[envCond]])) + # envData must be changed per .Rmd file if I imported it as something else
      geom_line(color = "gray50", linewidth = 0.2) + # Plot environmental factor
      geom_point(data = dfsplit[[i]], aes(x = DateMatch, y = .data[[envCond]], 
                                          #color = eDNA_index, 
                                          #size = eDNA_index
                                          ), 
                 alpha = 0.7) + # This is the big difference here
      geom_point(data = dfsplit[[i]], aes(x = DateMatch, y = .data[[envCond]], 
                                          #color = eDNA_index, 
                                          #size = eDNA_index
                                          ), 
                 stroke = 1, shape = 1) + # Adding outlines
      scale_colour_gradient(low = "goldenrod2", high = "darkgreen") +
      scale_size(range = c(1,5)) +
      geom_point(data = dfsplit[[i]] %>% filter(eDNA_index == 0), aes(x = date, y = .data[[envCond]]), color = "black") +
      SampHighlight1 +
      SampHighlight2 +
      SampHighlight3 +
      geom_hline(yintercept = 0.66, linetype = 2, color = "red") + # most copepods die
      geom_hline(yintercept = 0.9, linetype = 2, color = "orange") + # ~50% of copepods die
      geom_hline(yintercept = 2.66, linetype = 2, color = "forestgreen") + # many copepods experience sublethal effects (e.g. less egg production)
      theme_bw() +
      theme(text = element_text(size = 25), 
            plot.title = element_text(size = 17),
            legend.title = element_text(size = 20),
            legend.text = element_text(size = 20), 
            strip.text = element_text(size = 12), 
            strip.background = element_rect(fill = "gray95"),
            axis.text.x.top = element_blank(), # Needed to delete the extra axis created by ggbreak
            axis.ticks.x.top = element_blank(),
            axis.line.x.top = element_blank()) +
      scale_x_break(as.POSIXct(c("2021-10-12", "2022-05-24"))) +
      scale_x_datetime(breaks = "month", date_labels = "%b-%y", limits = as.POSIXct(c("2021-06-08", "2022-09-21"))) + # For whatever reason it was extending into 2023. Not figuring out the root cause today.
      # geom_text(x = as.POSIXct("2022-08-01"), y = labelLoc, aes(label = label), data = pct_labels, size = 10) +
      # Currently not printing the delta because I didn't feel like explaining it in the presentation
      labs(
        title = title, 
        x = "Date", 
        y = ylab, 
        color = "eDNA Index",
        )
    
    if (threshold == T) { # If threshold, include geom_hline
      print(
        plotbase +
          geom_hline(yintercept = thresholdLvl, linetype = 2, color = "red")
        )
    } else { # If no threshold, don't include the geom_hline
      print(
        plotbase
      )
    }
    
    spund <- gsub(" ", "_", species)
    filename <- paste(paste(spund, sep = "_", "VS"), sep = "_", envCondName)
    ggsave(filename = here(filepath, (paste(filename, sep = ".", "png"))), 
           width = widthpx, 
           height = heightpx, 
           units = "px")
  }

}

# 2023 graphing function
eDNAGraph_23 <- function(df, # Dataframe of species presence/absence + environmental factors
                      envCond, # Environmental condition VARIABLE name for plotting, as a string
                      envCondName = "EnvCondName", # Environmental condition name for export filename and plot title
                      filepath = here("eDNA_Index_Hypoxia", "Plots", "eDNAxDO"), # Where to save the file for export (a directory)
                      ylab = "Environmental Data", # Y axis label
                      widthpx = 2500, # Width for export (pixels)
                      heightpx = 2000, # Height for export (pixels)
                      threshold = T, # Whether or not to draw a horizontal line with a "threshold" for the environmental factor
                      thresholdLvl = 0 # If threshold = T, y-intercept of the horizontal line
) {
  print("HEADS UP: Date/time must be called exactly date and be in POSIXct, and envCond must be entered as a string (in quotes)")
  print("If you don't want a threshold line, set threshold = F instead of setting a thresholdLvl")
  print("Also for some reason you have to press 1 to confirm this function. Don't worry about it.")
  
  dfsplit <- split(df, df$Species) # Divide the input by species
  
  for (i in 1:length(dfsplit)) { # For each species: 
    species <- dfsplit[[i]]$Species[1] # Species name for title and export png name
    print(species) 
    title <- paste(paste(species, sep = " ", "eDNA Index vs"), sep = " ", envCondName) # Plot title, changed for eDNA
    print(title)
    
    # Omitted statistics
    # Omitted hypoxic dots
    
    plotbase <- ggplot(data = envData, aes(x = date, y = .data[[envCond]])) + # envData must be changed per .Rmd file if I imported it as something else
      geom_line(color = "gray50", linewidth = 0.2) + # Plot environmental factor
      geom_point(data = dfsplit[[i]], aes(x = DateMatch, y = .data[[envCond]], 
                                          #color = eDNA_index, 
                                          #size = eDNA_index
                                          ), 
                 alpha = 0.7) + # This is the big difference here
      geom_point(data = dfsplit[[i]], aes(x = DateMatch, y = .data[[envCond]], 
                                          #color = eDNA_index, 
                                          #size = eDNA_index
                                          ), 
                 stroke = 1, shape = 1) + # Adding outlines
      scale_colour_gradient(low = "goldenrod2", high = "darkgreen") +
      scale_size(range = c(1,5)) +
      geom_point(data = dfsplit[[i]] %>% filter(eDNA_index == 0), aes(x = DateMatch, y = .data[[envCond]]), color = "black") +
      SampHighlight1 +
      SampHighlight2 +
      SampHighlight3 +
      geom_hline(yintercept = 0.66, linetype = 2, color = "red") + # most copepods die
      geom_hline(yintercept = 0.9, linetype = 2, color = "orange") + # ~50% of copepods die
      geom_hline(yintercept = 2.66, linetype = 2, color = "forestgreen") + # many copepods experience sublethal effects (e.g. less egg production)
      theme_bw() +
      theme(text = element_text(size = 25), 
            plot.title = element_text(size = 17),
            legend.title = element_text(size = 20),
            legend.text = element_text(size = 20), 
            axis.text.x = element_text(size = 15),
            strip.text = element_text(size = 12), 
            strip.background = element_rect(fill = "gray95"),
            axis.text.x.top = element_blank(), # Needed to delete the extra axis created by ggbreak
            axis.ticks.x.top = element_blank(),
            axis.line.x.top = element_blank()) +
      scale_x_break(as.POSIXct(c("2021-10-12", "2022-05-24"))) +
      scale_x_break(as.POSIXct(c("2022-10-31", "2023-06-01"))) +
      scale_x_datetime(breaks = "month", date_labels = "%b-%y", limits = as.POSIXct(c("2021-07-08", "2023-08-21"))) +
      labs(
        title = title, 
        x = "Date", 
        y = ylab, 
        color = "eDNA Index",
      )
    
    if (threshold == T) { # If threshold, include geom_hline
      print(
        plotbase +
          geom_hline(yintercept = thresholdLvl, linetype = 2, color = "red")
      )
    } else { # If no threshold, don't include the geom_hline
      print(
        plotbase
      )
    }
    
    spund <- gsub(" ", "_", species)
    filename <- paste(paste(paste(spund, sep = "_", "VS"), sep = "_", envCondName), sep = "_", "2023")
    ggsave(filename = here(filepath, (paste(filename, sep = ".", "png"))), 
           width = widthpx, 
           height = heightpx, 
           units = "px")
  }
  
}