#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(markdown)

shinyUI(fluidPage(
  titlePanel("Find the right price for your diamonds!"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("sliderCarat", "What is the carat of the diamond?", 0, 5, value = 2, step = 0.2),
      checkboxInput("showFair", "Show/Hide cut Fair", value = TRUE),
      checkboxInput("showGood", "Show/Hide cut Good", value = TRUE),
      checkboxInput("showVeryGood", "Show/Hide cut Very Good", value = TRUE),
      checkboxInput("showPremium", "Show/Hide cut Premium", value = TRUE),
      checkboxInput("showIdeal", "Show/Hide cut Ideal", value = TRUE)
    ),
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Prediction", 
                           br(), 
                           plotOutput("plot1"), 
                           h3("Predicted price"), 
                           textOutput("pred1")),
                  tabPanel("Residuals", 
                           br(), 
                           plotOutput("plot2")),
                  tabPanel("About", 
                           includeMarkdown("about.md"))
      )
    )
  )
))
