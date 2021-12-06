#### Preparation ####

# Load libraries
library(timevis) # Wrapper for javascript gantt library: https://visjs.org/
library(htmlwidgets) # Creating html widgets

# Set the path
path <- file.path(
  "C:", "Users", "j-crispell", "Repositories",
  "gov-uk-rap-materials", "CreatingAGantt"
)


#### Plot a Gantt chart ####

# Read in the GANTT table
file <- file.path(path, "GanttTutorialTimeline_18-05-20.csv")
gantt <- read.table(file, header = TRUE, sep = ",", stringsAsFactors = FALSE)

# Set the date formats
gantt$start <- as.POSIXct(gantt$start, format = "%d/%m/%Y %H:%M")
gantt$end <- as.POSIXct(gantt$end, format = "%d/%m/%Y %H:%M")

# Remove NA rows
na_rows <- which(is.na(gantt$id))
if (length(na_rows) > 0) {
  gantt <- gantt[-na_rows, ]
}

# Note the groupings in the gannt chart
groups <- c("Preparation", "Presenting")
style <- c("<b>Preparation</b>", "<b>Presenting</b>")
groups <- data.frame(id = groups, content = style)

# Set the options for timevis
options <- list(editable = FALSE, align = "center", multiselect = TRUE)

# Plot the GANTT chart
timevis(gantt, groups = groups, options = options)

# Save the timeline to file
file <- file.path(path, "GanttTutorial_gantt.html")
saveWidget(
  timevis(
    gantt,
    groups = groups, options = options,
    width = "100%", showZoom = TRUE
  ),
  file,
  selfcontained = FALSE
) # Unfortunately self-contained doesn't work
