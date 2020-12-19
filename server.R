#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(shinyjs)
library(ggplot2)

nrall <- nrwon <- nrties <- 0
start <- TRUE

shinyServer(function(input, output, session) {
    renderSite <- function(x) {
        if (!is.null(x)) {
            nrall <<- nrall + 1
            y = sample(1:3, 1)
            y = arms[y]
            if (x == y) {
                msg = "TIE"
                nrties <<- nrties + 1
            } else if ((y == "Rock" & x == "Paper") | (y == "Paper" & x == "Scissors") | (y == "Scissors" & x == "Rock")) {
                msg = "YOU WON"
                nrwon <<- nrwon + 1
            } else {
                msg = "YOU LOST"
            }
        } else {
            msg = "Start by choosing an action"
            nrall <<- 0
            nrwon <<- 0
            nrties <<- 0
        }
        
        output$oid1 <- renderPrint({msg})
        output$oid2 <- renderPrint({nrall})
        output$oid3 <- renderPrint({nrwon})

        updateCheckboxInput(session,
                            inputId = 'userReset',
                            value = FALSE)
        
        updateRadioButtons(session,'userChoice1',
                           choices = arms,
                           selected = character(0))
        
        reset(id = 'sidebarPanel')
        
        npixel = 150
        
        output$playerMove <- renderImage({
            if(is.null(x)) blankImg(1, 1) else
               if(x == "Rock") rockImg(npixel, npixel) else
                    if(x== "Scissors") scissorsImg(npixel, npixel) else
                        if(x== "Paper") paperImg(npixel, npixel)
        },  deleteFile = FALSE)
        
        output$botMove <- renderImage({
            if(is.null(x)) blankImg(1, 1) else
                if(y == "Rock") rockImg(npixel, npixel) else
                    if(y == "Scissors") scissorsImg(npixel, npixel) else
                        if(y == "Paper") paperImg(npixel, npixel)
        },  deleteFile = FALSE)
        
        output$table <- renderTable(
            data.frame("Total games" = nrall, "Wins" = nrwon, "Ties" = nrties,
                       "Losses" = nrall-nrwon-nrties)
        )
        
    }
    

    # images
    blankImg <- function(h = 1, w = 1) {
        list(src = "images/blank.jpeg", contentType = "image/jpeg",
             height = h, width = w)}
    rockImg <- function(h = 250, w = 250) {
        list(src = "images/rock.jpeg", contentType = "image/jpeg", 
             height = h, width = w, alt = "rock")}
    scissorsImg <- function(h = 250, w = 250) {
        list(src = "images/scissors.jpeg", contentType = "image/jpeg",
             height = h, width = w, alt = "scissors")}
    paperImg <- function(h = 250, w = 250) {
        list(src = "images/paper.jpeg", contentType = "image/jpeg",
             height = h, width = w, alt = "paper")}
    
    if (start) {
        renderSite(NULL)
        start <- FALSE
    }
    
    #action buttons
    observeEvent(input$in_rock, renderSite("Rock"), priority = 2)
    observeEvent(input$in_scissors, renderSite("Scissors"), priority = 2)
    observeEvent(input$in_paper, renderSite("Paper"), priority = 2)
    
    #reactive when any of the three choices are clicked
    clicked <- reactive(c(input$in_rock, input$in_scissors, input$in_paper))
    
    #reacting at user triggered reset
    observe({
        if (input$userReset == TRUE) {
            renderSite(NULL)
        }
    })
    
    #reacting at user choice
    observe({
        if (!is.null(input$userChoice1)) {
            renderSite(input$userChoice1)
        }
    })
})