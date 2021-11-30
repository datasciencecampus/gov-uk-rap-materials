library(shiny)
library(RMySQL)
library(DBI)

ui <- fluidPage(
  numericInput("nrows", "Enter the number of rows to display:", 5),
  tableOutput("tbl")
)

server <- function(input, output, session) {
  output$tbl <- shiny::renderTable({

    # Connect to MySQL server
    connection <- RMySQL::dbConnect(
      drv = RMySQL::MySQL(),
      user = "root",
      password = input$sqlPass,
      dbname = "sakila",
      host = "localhost"
    )

    # Set to disconnect on exit
    on.exit(RMySQL::dbDisconnect(connection), add = TRUE)

    # Select data from MySQL server
    RMySQL::dbGetQuery(
      connection,
      paste0(
        "SELECT * FROM actor LIMIT ",
        input$nrows, ";"
      )
    )
  })
}

shinyApp(ui, server)
