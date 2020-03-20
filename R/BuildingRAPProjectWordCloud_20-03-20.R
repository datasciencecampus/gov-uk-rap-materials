## Building word cloud using descriptions of UK government RAP projects
## Authors: Nathan Begbie & Joseph Crispell
## Date created: 20-03-20

#### Preparation ####

# Load required libraries
library(googlesheets4) # Reading data from google doc
library(wordcloud) # Building a word cloud
library(tm) # Used by wordcloud

# Set the path
path <- file.path("C:", "Users", "j-crispell", "Repositories", "gov-uk-rap-materials")

#### Read in the data ####

# Read in the RAP project data from a CSV stored on google
sheet_url <- "https://docs.google.com/spreadsheets/d/1pwbcXwuMT4zignv5hghDS-eMxTkogwpX8Bt3bCL7SSA/edit#gid=1796469886"
projectData <- sheets_read(sheet_url)

#### Process the data ####

# Extract the descriptions from the brief description column
array_of_words <- unlist(strsplit(data$`Please provide a brief outline of the example`, " "))

# Remove non-character characters from words
array_of_words <- gsub(pattern="[[:punct:]]", replacement="", x=array_of_words)

# Ignore words with fewer than X characters
array_of_words <- array_of_words[nchar(array_of_words) > 3]

#### Plot the word cloud ####

# Open a png file
fileName <- file.path(path, "images", "RAP-project-wordcloud.png")
png(fileName, width=620,height=550)

# Set the plotting margins
par(mar=c(0,0,0,0))

# Plot a word cloud representing the frequency that words appear in descriptions
wordcloud(array_of_words, max.words=500, min.freq=2, scale=c(8,0.5))

dev.off()
