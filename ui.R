#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(shinyjs)
library(shinythemes)

arms <<- c("Rock","Paper","Scissors")
shinyUI(
    
    navbarPage("Navbar!",
        theme = shinythemes::shinytheme("flatly"),
    tabPanel("Play",
        headerPanel("The Rock-Paper-Scissors Game"),
        sidebarPanel(
            useShinyjs(),
            h2('Test your Luck!'),
            h4('Rules:'),
            h4('Rock beats Scissors, Scissors beats Paper, Paper beats Rock.'),
            h4('You will play against a bot who uses a random generator.'),
            h4('Click on one of the three image below to make your choice.'),
            h4('When you want to reset the counters click on the checkbox.'),
            checkboxInput(inputId = 'userReset', label = "Start again (reset all counters to zero)",value = FALSE ),
            actionButton("in_rock", label = img(src = "images/rock.jpeg", height = "100px", width = "100px")),
            actionButton("in_scissors", label = img(src = "images/scissors.jpeg", height = "100px", width = "100px")),
            actionButton("in_paper", label = img(src = "images/paper.jpeg", height = "100px", width = "100px")),
            #radioButtons(inputId = 'userChoice1', label = "", choices = arms,selected = character(0)),
            #fluidRow(
            #    column(1, actionButton("in_rock", label = img(src = "images/rock.jpeg", height = "100px", width = "100px"))),
            #    column(1, actionButton("in_scissors", label = img(src = "images/scissors.jpeg", height = "50px", width = "50px")), offset = 1),
            #    column(1, actionButton("in_paper", label = img(src = "images/paper.jpeg", height = "50px", width = "50px")), offset = 1)
            #),
            # submitButton('Submit Choice!')
            
        ),

        
        mainPanel(
            useShinyjs(),
            
            fluidRow(
                column(2, imageOutput('playerMove', height = "150px", width = "150px"),
                       tags$small("Your Move"), offset = 1),
                column(2, imageOutput('botMove', height = "150px", width = "150px"),
                       tags$small("Bot Move"), offset = 3)
            ),
            
            br(),
            br(),
            h3('Current result:'),
            h2(textOutput("oid1")),
            tableOutput("table"),
            
        )
    ),
    tabPanel("About",
        h3('Created by Riccardo Sanson'),
        h3(a(href="https://github.com/RiccardoSanson/RPS-Shiny-Application",
             "Github link")),
    )
    ))