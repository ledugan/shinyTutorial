library(shiny)
library(shinydashboard)
library(dplyr)

## DASHBOARD STRUCTURE
header <- dashboardHeader()
sidebar <-  dashboardSidebar()
body <- dashboardBody()
ui <- dashboardPage(header, sidebar, body)
server <- function(input, output) {}
shinyApp(ui, server)

## DASHBOARD HEADER OVERVIEW
# three types of drop-down menus can be housed in the header: messages, 
# notifications, and tasks

# add a messages drop-down
server <- function(input, output) {}
header <- dashboardHeader(
  dropdownMenu(
    type = "messages",
    messageItem(
      from = "Laura",
      message = "Time to go home! Check the traffic.",
      href = "https://www.kxan.com/traffic"
    ),
    messageItem(
      from = "Andrew",
      message = "Don't forget to feed the critters!",
      href = "https://www.chewy.com"
    )
  )
)
ui <- dashboardPage(header = header,
                    sidebar = dashboardSidebar(),
                    body = dashboardBody())
server <- function(input, output) {}
shinyApp(ui, server)

# add notification items
server <- function(input, output) {}
header <- dashboardHeader(
  dropdownMenu(
    type = "notifications",
    notificationItem(
      text = "Good morning Genius!",
      href = "https://npr.org"
    )
  )
)
ui <- dashboardPage(header = header,
                    sidebar = dashboardSidebar(),
                    body = dashboardBody())
shinyApp(ui, server)

# add task menus
server <- function(input, output) {}
header <- dashboardHeader(
  dropdownMenu(
    type = "tasks",
    taskItem(
      text = "Operation Paint Upstairs Bathroom",
      value = 40 #shows completion bar; value = % done
    )
  )
)
ui <- dashboardPage(header = header,
                    sidebar = dashboardSidebar(),
                    body = dashboardBody())
shinyApp(ui, server)

# header with all three drop-down menu types
server <- function(input, output) {}
header <- dashboardHeader(
  dropdownMenu(
    type = "messages",
    messageItem(
      from = "Laura",
      message = "Check out the city's Grow Green resources",
      href = "http://www.austintexas.gov/growgreenresources"
    )
  ),
  dropdownMenu(
    type = "notifications",
    notificationItem(
      text = "Thunderstorms Wednesday...warn Molly!"
    ),
    notificationItem(
      text = "Saturday is tree cutting down day!"
    )
  ),
  dropdownMenu(
    type = "tasks",
    taskItem(
      text = "Operation Paint Upstairs Bathroom",
      value = 25,
      color = "teal"
    ),
    taskItem(
      text = "Operation Landscape Front Yard",
      value = 10,
      color = "green"
    ),
    taskItem(
      text = "Operation Refinish Dresser",
      value = 0,
      color = "red"
    )
  )
)
ui <- dashboardPage(header = header,
                    sidebar = dashboardSidebar(),
                    body = dashboardBody()
                    )
shinyApp(ui, server)

## DASHBOARD SIDEBAR AND BODY
server <- function(input, output) {}
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Household Projects",
      tabName = "hprojects"
    )
  ),
  sidebarMenu(
    menuItem("Project Budget",
      tabName = "budget"
    )
  )
)
body <-  dashboardBody(
  tabItems(
    tabItem(tabName = "hprojects",
            "Current household projects",
            tabBox(
              title = "Priority",
              tabPanel("Priority 1", "1 - landscaping"),
              tabPanel("Priority 2", "1 - paint master bathroom")
            )
            ),
    tabItem(tabName = "budget",
            "Tax money spending"
            )
  )
)
ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = sidebar,
                    body = body
)
shinyApp(ui, server)

## REACTIVE EXPRESSIONS
# input fxns have 3 req params: inputId, label, choices
server <-  function(input, output) {}
sidebar <- dashboardSidebar(
  selectInput(inputId = "numbers", # use this to access this input elsewhere in the app
              label = "Numbers", # how the input item will be displayed
              choices = 1:3 # options for the input
              )
)
ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = sidebar,
                    body = dashboardBody()
)
shinyApp(ui, server)

# slider input
server <- function(input, output) {}
sidebar <-  dashboardSidebar(
  sliderInput(inputId = "height",
              label = "Height",
              min = 66, # min value on the slider
              max = 264, # max value on the slider
              value = 165 # where the bar on the slider sits (default)
  )
)
ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = sidebar,
                    body = dashboardBody()
)
shinyApp(ui, server)

# output to the body
sidebar <- dashboardSidebar(
  selectInput(inputId = "name",
              label = "Name",
              choices = starwars$name
  )
)
body <-  dashboardBody(
  textOutput("name") # tells to output the value stored in inputId name to the body
)
ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = sidebar,
                    body = body
                    )
server <- function(input, output) {
  output$name <- renderText({ # tells to output the input entered into inputId 'name'
    input$name
  })
}

shinyApp(ui, server)

## SERVER-SIDE DYNAMIC HOW-TO
# can read in real-time data with a function that will check a file's time stamp
# and if it is differnt from the last time it read in the file, it will read it 
# in again
# once data are read in, they are read to a reactive expression that contains the
# content of the file; when the dataset is referred to elsewhere in the server
# function, it is expressed to as a function

# general format
crimefile <- "C:\\Users\\ldugan\\Documents\\Personal\\AustinCrime\\CTract_Crime_Report_2016.csv"
server <- function(input, output, session) {
  reactive_data <- reactiveFileReader( # will refer to this datset as reactive_data() elsewhere in the server function
    intervalMillis = 1000, # how many ms bw checking file's modified time
    session = session, # user session; usually set to session
    filePath = crimefile, # path to the file of interest
    readFunc = function(filePath) {
      read.csv(filePath)
      }# which R function will use to read in file
  ) # notice no comma after this block
  
  output$crime_data <- renderTable({
    reactive_data()
      })
}

body <- dashboardBody(
  tableOutput("crime_data")
)

ui <-  dashboardPage(header = dashboardHeader(),
                     sidebar = dashboardSidebar(),
                     body = body
                     )

shinyApp(ui, server)

## PUTTING IT ALL TOGETHER
header <- dashboardHeader(
  dropdownMenu(
    type = "messages",
    messageItem(
      from = "Laura",
      message = "Check out the city's Grow Green resources",
      href = "http://www.austintexas.gov/growgreenresources"
    )
  ),
  dropdownMenu(
    type = "notifications",
    notificationItem(
      text = "Thunderstorms Wed...warn Molly!"
    ),
    notificationItem(
      text = "Saturday is tree cutting down day!"
    )
  ),
  dropdownMenu(
    type = "tasks",
    taskItem(
      text = "Operation Paint Upstairs Bathroom",
      value = 25,
      color = "teal"
    ),
    taskItem(
      text = "Operation Landscape Front Yard",
      value = 10,
      color = "green"
    ),
    taskItem(
      text = "Operation Refinish Dresser",
      value = 0,
      color = "red"
    )
  )
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Household Projects",
             tabName = "hprojects"
    )
  ),
  sidebarMenu(
    menuItem("Project Budget",
             tabName = "budget"
    )
  ),
  selectInput(
    inputId = "love_question",
    label = "Do you love me?",
    choices = c("yes", "no", "more than cookies")
  )
)

body <-  dashboardBody(
  tabItems(
    tabItem(tabName = "hprojects",
            "Current household projects",
            tabBox(
              title = "Priorities",
              tabPanel("Priority 1", "1 - landscaping"),
              tabPanel("Priority 2", "1 - paint master bathroom")
            )
    ),
    tabItem(tabName = "budget",
            "Tax money spending"
    )
  ),
  textOutput("love_question")
)

ui <- dashboardPage(header = header,
                    sidebar = sidebar,
                    body = body
)

homefile <- "C:\\Users\\ldugan\\Documents\\Personal\\home.csv"

server <- function(input, output, session) {
  reactive_home_data <- reactiveFileReader(
    intervalMillis = 1000,
    session = session,
    filePath = homefile,
    readFunc = function(filePath) {
      read.csv(homefile)
    }
  )
  
  output$home_data <- renderTable({ # tells to output the reactive file loaded in the server function
    reactive_home_data()
  })
  
  output$love_question <- renderText({ # tells to output the input entered into inputId 'name'
    input$love_question
  })
}

shinyApp(ui, server)
