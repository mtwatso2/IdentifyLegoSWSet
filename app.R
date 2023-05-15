#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)

data <- read.csv('allLSWpieces.csv')
data$Colour <- factor(data$Colour)
data$Design <- factor(data$Design)

names <- read.csv('legoSW.csv')

height <- c(1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
colors <- c('Bright Red', 'New Dark Red', 'Reddish Brown', 'Dark Brown', 'Bright Orange', 
           'Bright Yellow', 'Light Nougat', 'Brick Yellow', 'Sand Yellow', 'Bright Blue', 
           'Earth Blue', 'White', 'Medium Stone Grey', 'Dark Stone Grey', 'Black')
codes <- c('#C91A09', '#720E0F', '#582A12', '#352100', '#FE8A18', 
           '#F2CD37', '#F6D7B3', '#E4CD9E', '#958A73', '#0055BF', 
           '#0A3463', '#FFFFFF', '#A0A5A9', '#6C6E68', '#000000')
colorDF <- data.frame(height, colors, codes)
colorDF$colors <- factor(colorDF$colors, levels=colorDF$colors)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Identify which Lego Star Wars set(s) your random pieces belong to!"),
    
    #Explaining how to determine piece number and color
    ("Note: Piece Number refers to the 'Item No' found on Bricklink. It can sometimes be found on the bottom of a piece as well."),
    helpText(a("Link to Brick Link part catalog", href = "https://www.bricklink.com/catalogTree.asp?itemType=P")),
    ("Note: You need to enter a valid piece number before you can select the color of the piece."),
    br("(Chart on bottom left shows examples of some of the more common colors.)"),
    helpText(a("Guide to determine color", href = 'https://brickipedia.fandom.com/wiki/Colour_Palette')),
    
    fluidRow(
        column(2,
            textInput("piece1",
                      "Piece #1 Number:",
                       placeholder = 'Enter code here:'),

            selectizeInput("color1",
                      "Piece #1 Color:",
                       choices = levels(data$Colour),#c("Choose a color" = "", levels(data$Colour)),
                       multiple=FALSE,
                       selected = ""),
            textInput("piece2",
                      "Piece #2 Number:",
                       placeholder = 'Enter code here:'),

            selectizeInput("color2",
                      "Piece #2 Color:",
                       choices = levels(data$Colour),#c("Choose a color" = "", levels(data$Colour)),
                       multiple=FALSE,
                       selected = ""),

            textInput("piece3",
                      "Piece #3 Number:",
                       placeholder = 'Enter code here:'),

            selectizeInput("color3",
                      "Piece #3 Color:",
                       choices = levels(data$Colour),#c("Choose a color" = "", levels(data$Colour)),
                       multiple=FALSE,
                       selected = ""),

          fluidRow(
              column(12,
                    plotOutput('barplot')))

         ),#closes first column

         column(10,
                strong('Piece #1 can be found in these set(s):'),
                dataTableOutput('sets1'),

                strong("Common set(s) for Pieces #1 and #2:"),
                dataTableOutput("sets2"),

                strong("Common set(s) for Pieces #1, #2 and #3"),
                dataTableOutput("sets3"),
                
         )#closes second column
    )

    # # Sidebar with a slider input for number of bins
    # sidebarLayout(
    #     sidebarPanel(
    # 
    #         textInput("piece1",
    #                   "Piece #1 Number:",
    #                   placeholder = 'Enter code here:'),
    # 
    #         selectizeInput("color1",
    #                        "Piece #1 Color:",
    #                        choices = levels(data$Colour),#c("Choose a color" = "", levels(data$Colour)),
    #                        multiple=FALSE,
    #                        selected = ""),
    # 
    #         textInput("piece2",
    #                   "Piece #2 Number:",
    #                   placeholder = 'Enter code here:'),
    # 
    #         selectizeInput("color2",
    #                        "Piece #2 Color:",
    #                        choices = levels(data$Colour),#c("Choose a color" = "", levels(data$Colour)),
    #                        multiple=FALSE,
    #                        selected = ""),
    # 
    #         textInput("piece3",
    #                   "Piece #3 Number:",
    #                   placeholder = 'Enter code here:'),
    # 
    #         selectizeInput("color3",
    #                        "Piece #3 Color:",
    #                        choice = c("Choose a color" = "", levels(data$Colour)),
    #                        multiple=FALSE)
    # 
    #         ),
    # 
    #     #
    #     mainPanel(
    #         #plotOutput('barplot'),
    # 
    #         strong('Piece #1 can be found in these set(s):'),
    #         dataTableOutput('sets1'),
    # 
    #         strong("Common set(s) for Pieces #1 and #2:"),
    #         dataTableOutput("sets2"),
    # 
    #         strong("Common set(s) for Pieces #1, #2 and #3"),
    #         dataTableOutput("sets3"),
    #         plotOutput('barplot')
    #     )
    # )# These last two close out side bar layout
) #and UI

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    output$barplot <- renderPlot({
        ggplot(data=colorDF, aes(x=reorder(colors, desc(colors)), y=height)) +
            geom_bar(stat='identity', fill=codes) +
            theme(axis.title.x=element_blank(),
                  axis.text.x=element_blank(),
                  axis.ticks.x=element_blank(),
                  axis.title.y=element_blank(),
                  axis.text.y=element_text(color = 'black', size = 12, face='bold')) +
            coord_flip()
    })
    

    observeEvent(input$piece1, {
        updateSelectizeInput(session, "color1",
                             choices = data$Colour[data$Design == input$piece1],
                             selected = "")
    })
    
    filter1 <- reactive({
        newData = data %>%
            filter(
                Design == input$piece1,
                Colour == input$color1
            )
        a <- c(newData$SetNumber)
        n <- names %>%
            filter(SetNumber %in% a)
        return(n)
    })

    output$sets1 <- renderDataTable(
        filter1(),
        options=list(pageLength=10,                    # initial number of records
                     lengthChange=0,                   # show/hide records per page dropdown
                     searching=0,                      # global search box on/off
                     info=1                            # information on/off (how many records filtered, etc)
        )
    )
    
    
    observeEvent(input$piece2, {
        updateSelectizeInput(session, "color2",
                             choices = data$Colour[data$Design == input$piece2],
                             selected = "")
    })
    
    filter2 <- reactive({
        newData = data %>%
            filter(
                Design == input$piece2,
                Colour == input$color2
            )
        a <- c(newData$SetNumber)
        n <- filter1() %>%
            filter(SetNumber %in% a)
        return(n)
    })

    output$sets2 = renderDataTable(
        filter2(),
        options=list(pageLength=10,                    # initial number of records
                     lengthChange=0,                   # show/hide records per page dropdown
                     searching=0,                      # global search box on/off
                     info=1                            # information on/off (how many records filtered, etc)
        )
    )

    observeEvent(input$piece3, {
        updateSelectizeInput(session, "color3",
                             choices = data$Colour[data$Design == input$piece3],
                             selected = "")
    })
    
    filter3 = reactive({
        newData = data %>%
            filter(
                Design == input$piece3,
                Colour == input$color3
            )
        a <- c(newData$SetNumber)
        n <- filter2() %>%
            filter(SetNumber %in% a)
        return(n)
    })

    output$sets3 = renderDataTable(
        filter3(),
        options=list(pageLength=10,                    # initial number of records
                     lengthChange=0,                   # show/hide records per page dropdown
                     searching=0,                      # global search box on/off
                     info=1                            # information on/off (how many records filtered, etc)
        )
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
