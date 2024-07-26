# This is a function to graph species presence and absence data over an environmental variable. 
# Both should have dates in POSIXct.

# This basically only works in eDNAxpO2.Rmd which is fine. 
# Don't expect it to be adaptable to much else due to all the janky stuff I've added.

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
  print("df, envCond, filename, filepath, title, ylab, widthpx = 2500, heightpx = 2000, threshold, thresholdLvl = 0, labelLoc = 75")
}

presenceGraph <- function(df, # Dataframe of species presence/absence + environmental factors
                          envCond, # Environmental condition VARIABLE name for plotting
                          envCondName = "EnvCondName", # Environmental condition name for export filename and plot title
                          filepath = here("OCNMS_Project", "Plots", "PresenceAbsence"), # Where to save the file for export (a directory)
                          ylab = "Environmental Data", # Y axis label
                          widthpx = 2500, # Width for export (pixels)
                          heightpx = 2000, # Height for export (pixels)
                          threshold = T, # Whether or not to draw a horizontal line with a "threshold" for the environmental factor
                          thresholdLvl = 0, # If threshold = T, y-intercept of the horizontal line
                          labelLoc = 75, # Y location of the delta label (picked from EllaInterest)
                          hypoxicdots = T # Delete the hypoxic dots if you're not using oxygen data (this only works for temperature right now)
                          ) {
  print("HEADS UP: Date/time must be called exactly date and be in POSIXct, and envCond must be entered as a string (in quotes)")
  print("If you don't want a threshold line, set threshold = F instead of setting a thresholdLvl")
  print("If you are using temperature, set hypoxicdots = F")
  
  dfsplit <- split(df, df$Species) # Divide the input by species

  for (i in 1:length(dfsplit)) { # For each species: 
    species <- dfsplit[[i]]$Species[1] # Species name for title and export png name
    print(species) 
    title <- paste(paste(species, sep = " ", "Presence vs"), sep = " ", envCondName) # Plot title
    print(title)
    
    spStats <- EllaInterest %>% filter(Species == species) 
    # The statistics of this species from my spreadsheet - these were entered manually
    # print(spStats)
    # Commented out because it prints a dataframe, can be used to check that the function is working
    pctLab <- spStats$DetectionRateDelta # Labels the graph with the change in occurance rate in hypoxia 

    pct_labels <- data.frame(year = c(2021, 2022), label = c("", pctLab)) 
    # Make the labels - pick out the detection rate delta, make the label for 2021 blank to put it on only one facet
    
    if (hypoxicdots == T) {
      hypoxiaT = "red"
      hypoxiaY = "SatPct"
    } else {
      hypoxiaT = "transparent" # Delete the hypoxic dots if told to
      hypoxiaY = "temperature" # make the y temperature so that we don't have invisible dots making the y axis long
      # Idea for later: make this less janky by forcing ylimits that are like, maximum * 1.1 and minimum * 1.1
    }
    
    plotbase <- ggplot(data = envDataSat, aes(x = date, y = .data[[envCond]])) +
      geom_line(color = "gray50", size = 0.2) + # Plot environmental factor
      geom_point(data = Hypoxia, # Plot the hypoxic data in red
                 aes(x = date, y = .data[[hypoxiaY]]), 
                 color = hypoxiaT, # See above for the if(hypoxicdots) bit for explanation
                 size = 0.1) +
      geom_point(data = dfsplit[[i]], aes(x = DateMatch, y = .data[[envCond]], shape = Present, color = Present), 
                 size = 1, stroke = 2) +
      scale_color_manual(values = c("TRUE" = "dodgerblue3", "FALSE" = "orange2")) +
      scale_shape_manual(values = c(1, 19)) +
      SampHighlight1 +
      SampHighlight2 +
      SampHighlight3 +
      theme_bw() +
      theme(text = element_text(size = 15), 
            axis.text.x = element_text(angle = 45, hjust = 1), 
            strip.text = element_text(size = 12), 
            strip.background = element_rect(fill = "gray95"),
            axis.text.x.top = element_blank(), # Needed to delete the extra axis created by ggbreak
            axis.ticks.x.top = element_blank(),
            axis.line.x.top = element_blank()) +
      scale_x_break(as.POSIXct(c("2021-10-12", "2022-05-24"))) +
      scale_x_datetime(breaks = "month", date_labels = "%b-%y") +
      # geom_text(x = as.POSIXct("2022-08-01"), y = labelLoc, aes(label = label), data = pct_labels, size = 10) +
      # Currently not printing the delta because I didn't feel like explaining it in the presentation
      labs(
        title = title, 
        x = "Date", 
        y = ylab
        )
    
    if (threshold == T) { # If threshold, include geom_hline
      print(
        plotbase +
          geom_hline(yintercept = thresholdLvl, linetype = 2)
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