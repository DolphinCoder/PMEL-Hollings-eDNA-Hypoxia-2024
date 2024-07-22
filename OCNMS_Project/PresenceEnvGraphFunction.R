# This is a function to graph species presence and absence data over an environmental variable. 
# Both should have dates in POSIXct.

# if (class(Data) != "data.frame") {
#stop("ERROR: Data must be an object of type data.frame")
#}

test <- function(number, by = NA){
  print(number*2)
  return(number*3)
}

presenceGraphVars <- function() {
  print("df, envCond, filename, filepath, title, ylab, widthpx = 2500, heightpx = 2000, threshold, thresholdLvl = 0")
}

presenceGraph <- function(df, 
                          envCond, 
                          envCondName = "EnvCondName",
                          filepath = here("OCNMS_Project", "Plots", "PresenceAbsence"), 
                          ylab = "Environmental Data",
                          widthpx = 2500,
                          heightpx = 2000,
                          threshold = T,
                          thresholdLvl = 0
                          ) {
  print("HEADS UP: Date/time must be called exactly date and be in POSIXct, and envCond must be entered as a string (in quotes)")
  print("If you don't want a threshold line, set threshold = F instead of setting a thresholdLvl")
  
  dfsplit <- split(df, df$Species)

  for (i in 1:length(dfsplit)) {
    species <- dfsplit[[i]]$Species[1]
    title <- paste(paste(species, sep = " ", "Presence vs"), sep = " ", envCondName)
    print(title)
    
    if (threshold == T) { # If threshold, include geom_hline
      print(
        ggplot(data = envDataSat, aes(x = date, y = .data[[envCond]])) +
          geom_line(color = "black", size = 0.2) +
          scale_color_manual(values = c("TRUE" = "chartreuse3", "FALSE" = "firebrick3")) +
          geom_point(data = dfsplit[[i]], aes(x = DateMatch, y = .data[[envCond]], shape = Present, color = Present), 
                     size = 2) +
          scale_shape_manual(values = c(1, 19)) +
          theme_bw() +
          facet_wrap(facets = vars(year(date)), scales = "free_x", ncol = 4) +
          scale_x_datetime(breaks = "month", date_labels = "%b-%y") +
          theme(text = element_text(size = 15), 
                axis.text.x = element_text(angle = 45, hjust = 1), 
                strip.text = element_text(size = 12), 
                strip.background = element_rect(fill = "gray95")) +
          geom_hline(yintercept = thresholdLvl, linetype = 2) +
          labs(title = title, x = "Date", y = ylab)
      )
    } else { # If no threshold, don't include the geom_hline
      print(
        ggplot(data = envDataSat, aes(x = date, y = .data[[envCond]])) +
          geom_line(color = "black", size = 0.2) +
          scale_color_manual(values = c("TRUE" = "chartreuse3", "FALSE" = "firebrick3")) +
          geom_point(data = dfsplit[[i]], aes(x = DateMatch, y = .data[[envCond]], shape = Present, color = Present), 
                     size = 2) +
          scale_shape_manual(values = c(1, 19)) +
          theme_bw() +
          facet_wrap(facets = vars(year(date)), scales = "free_x", ncol = 4) +
          scale_x_datetime(breaks = "month", date_labels = "%b-%y") +
          theme(text = element_text(size = 15), 
                axis.text.x = element_text(angle = 45, hjust = 1), 
                strip.text = element_text(size = 12), 
                strip.background = element_rect(fill = "gray95")) +
          labs(title = title, x = "Date", y = ylab)
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