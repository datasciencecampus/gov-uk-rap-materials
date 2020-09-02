# Function to build simple scrollable table for html output
prettyTable <- function(table){
  
  # Use the kable function to create a nicer formatted table
  kable(table, row.names=FALSE) %>%
    
    # Set the format
    kable_styling(bootstrap_options="striped", # Set the colour of rows
                  full_width=FALSE, # Make the table not stretch to fit the page
                  position="left") %>% # Position the table on the left
    
    # Make the table scrollable
    scroll_box(height = "400px")
}

# Function to align the data for a particular count by date
alignCountByDate <- function(data, countColumn){
  
  # Initialise a dataframe to store the aligned data - a row for each date data from any country available
  alignedByDate <- data.frame(Date=sort(unique(covid$Date_reported)), check.names=FALSE)
  
  # Using dates as unique row names as some countries don't have data for every date
  rownames(alignedByDate) <- as.character(alignedByDate$Date)
  
  # Add the death counts for each country
  for(country in unique(covid$Country)){
    
    # Create a column for the current country
    alignedByDate[, country] <- NA
    
    # Get the data for current country
    counts <- covid[covid$Country == country, c("Date_reported", countColumn)]
    
    # Insert the countries data into the aligned table - note using date as the row index
    alignedByDate[as.character(counts$Date_reported), country] <- counts[, countColumn]
  }
  
  return(alignedByDate)
}

# Function to identify top X countries based on latest values in particular count column
getTopCountries <-function(covid, countColumn, n){
  
  # Get the latest date that data available for 
  latestDate <- max(covid$Date_reported)
  
  # Get the latest count values
  latestCounts <- covid[covid$Date_reported == latestDate, c("Country", countColumn)]
  
  # Order the counts from highest to smallest
  latestCounts <- latestCounts[order(latestCounts[, countColumn], decreasing=TRUE), ]
  
  # Return the top "n" countries
  return(latestCounts$Country[1:n])
}

# Function to create interactive line chart of daily deaths trends for particular countries
plotDailyDeathsInteractive <- function(aligendByDate, countries, title, legend=TRUE){
  
  # Define a colour palette
  colours <- colorRampPalette(brewer.pal(8, "Dark2"))(length(countries))
  
  # Create the initial plotly figure
  fig <- plot_ly()
  
  # Add a trace for the rolling average dataset
  for(i in seq_along(countries)){
    fig <- add_lines(fig, 
                     x=alignedByDate$Date, y=alignedByDate[, countries[i]], 
                     name=topCountries[i], 
                     hovertemplate=paste("Number deaths:", alignedByDate[, topCountries[i]]),
                     line=list(color=colours[i]))
  }
  
  # Set the X axis label
  fig <- layout(fig, xaxis=list(title="Date"))
  
  # Set the Y axis label
  fig <- layout(fig, yaxis=list(title="Number deaths per day"))
  
  # Set the plot title
  fig <- layout(fig, title=title)
  
  # Turn off legend if request
  if(legend == FALSE){
    fig <- layout(fig, showlegend=FALSE)
  }
  
  # Plot the final figure
  fig
}