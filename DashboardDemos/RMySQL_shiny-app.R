library(shiny)
library(RMySQL)
library(DBI)

ui <- fluidPage(
  numericInput("nrows", "Enter the number of rows to display:", 5),
  tableOutput("tbl")
)

server <- function(input, output, session) {
  output$tbl <- renderTable({
    
    # Connect to MySQL server
    connection <- dbConnect(
      drv = MySQL(),
      user = 'root', 
      password = sqlPass,
      dbname = 'sakila',
      host = 'localhost')
    
    # Set to disconnect on exit
    on.exit(dbDisconnect(connection), add = TRUE)
    
    # Select data from MySQL server
    dbGetQuery(connection, paste0("SELECT * FROM actor LIMIT ", input$nrows, ";"))
  })
}

shinyApp(ui, server)