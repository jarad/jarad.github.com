## ----packages---------------------------------------------------------------------------------------------------------------------------
library("tidyverse"); theme_set(theme_bw())
library("shiny")


## ----input------------------------------------------------------------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("User input options"),

  column(width = 3,
    actionButton("action",
                 label = "actionButton"),

    fileInput("file",
              label = "File input"),

    textInput("text",
              label = "Text")
  ),
  column(width = 3,
    checkboxInput("checkbox",
                  label = "Checkbox"),

    checkboxGroupInput("checkboxGroup",
                       label = "Checkbox Group",
                       choices = c("A","B","C")),

    radioButtons("radioButtons",
                 label = "Radio Buttons",
                 choices = c("A","B","C")),

    selectInput("select",
                label = "Select",
                choices = c("A","B","C")),

    selectInput("select",
                label = "Select multiple",
                choices = c("A","B","C"),
                multiple = TRUE)
  ),
  column(width = 3,
    numericInput("numeric",
                 label = "Numeric", value = 0),

    sliderInput("slider",
                label = "Slider",
                min = 0, max = 10, value = 5, step = 1),

    sliderInput("slider",
                label = "Slider range",
                min = 0, max = 10, value = c(3,7), step = 1)
  ),
  column(width = 3,
         dateInput("date",
                   label = "Date"),

         dateRangeInput("daterange",
                        label = "Date range"),

         helpText(h3("Help text"),
                  "Here is some help text.")
         )
)

shinyApp(ui = ui, server = function(input, output) {} )


## ----output-text------------------------------------------------------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Here is text output!"),

  textOutput("text")
)

server <- function(input, output) {
  output$text <- renderText({
    "Here's some text"
  })
}

shinyApp(ui = ui, server = server)


## ----output-table-----------------------------------------------------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Here is table output!"),

  tableOutput('table')
)

server <- function(input, output) {
  output$table <- renderTable(warpbreaks)
}

shinyApp(ui = ui, server = server)


## ----output-datatable-------------------------------------------------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Here is datatable output!"),

  dataTableOutput('table')
)

server <- function(input, output) {
  output$table <- renderDataTable(warpbreaks)
}

shinyApp(ui = ui, server = server )


## ----output-plot------------------------------------------------------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Here is plot output!"),

  plotOutput("plot")
)

server <- function(input, output) {
  output$plot <- renderPlot({
    hist(rnorm(100))
  })
}

shinyApp(ui = ui, server = server)


## ----output-print-----------------------------------------------------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Here is print output!"),

  verbatimTextOutput("print")
)

server <- function(input, output) {
  output$print <- renderPrint({
    m <- lm(breaks ~ tension + wool, data = warpbreaks)
    summary(m)
  })
}

shinyApp(ui = ui, server = server)


## ----shiny-simple-ui--------------------------------------------------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("2-D Histogram with Hexes!"),

  sidebarLayout(
    sidebarPanel(
      checkboxInput(inputId = "logx", label = "Log Carat"),
      checkboxInput(inputId = "logy", label = "Log Price"),

      textInput(inputId = "low",  label = "Low color",  value = "gray"),
      textInput(inputId = "high", label = "High color", value = "blue"),
    ),
    mainPanel(
      plotOutput(outputId = "hexbinPlot")
    )
  )
)


## ----shiny-simple-server----------------------------------------------------------------------------------------------------------------
server <- function(input, output) {
  output$hexbinPlot <- renderPlot({
    g <- ggplot(diamonds, aes(x = carat, y = price)) +
      geom_hex() +
      theme_bw() +
      labs(
        title = "Diamonds: Price vs Carat",
        x     = "Carat",
        y     = "Price ($)"
      ) +
      scale_fill_gradient(
        low  = input$low,
        high = input$high
      )

    if (input$logx)
      g <- g + scale_x_log10()

    if (input$logy)
      g <- g + scale_y_log10()

    g
  })
}


## ---- shiny-simple----------------------------------------------------------------------------------------------------------------------
shinyApp(ui = ui, server = server)


## ---------------------------------------------------------------------------------------------------------------------------------------
shiny::runGitHub('pvalue','jarad')

