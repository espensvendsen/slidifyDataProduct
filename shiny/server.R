#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(UsingR)
library(ggplot2)

shinyServer(function(input, output) {
  diamonds$cut_txt <- as.character(diamonds$cut)
  
  model1 <- lm(price ~ carat, data = diamonds)
  
  model1pred <- reactive({
    caratInput <- input$sliderCarat
    predict(model1, newdata = data.frame(carat = caratInput))
  })
  
  output$pred1 <- renderText({
    caratInput <- input$sliderCarat
    pred <- model1pred()
    paste(caratInput, " carat(s) -> ", floor(pred), " SIN")
  })
  
  output$plot1 <- renderPlot({
    options <- c(fair="", good="", veryGood="", premium="", ideal="")
    if (input$showFair)
      options["fair"] = "Fair"
    if (input$showGood)
      options["good"] = "Good"
    if (input$showVeryGood)
      options["veryGood"] = "Very Good"
    if (input$showPremium)
      options["premium"] = "Premium"
    if (input$showIdeal)
      options["ideal"] = "Ideal"
    subDiamonds <- subset(diamonds, cut_txt %in% options)
    if (nrow(subDiamonds) > 0) {
      model1 <- lm(price ~ carat, data = subDiamonds)
      
      g = ggplot(subDiamonds, aes(x = carat, y = price, color = cut))
      g = g + xlab("Mass (carats)")
      g = g + ylab("Price (SIN )")
      g = g + geom_point()
      g = g + geom_smooth(method = "lm", colour = "black")
      g = g + ylim(0, 22000)
      g
    }
  })
  
  output$plot2 <- renderPlot({
    options <- c(fair="", good="", veryGood="", premium="", ideal="")
    if (input$showFair)
      options["fair"] = "Fair"
    if (input$showGood)
      options["good"] = "Good"
    if (input$showVeryGood)
      options["veryGood"] = "Very Good"
    if (input$showPremium)
      options["premium"] = "Premium"
    if (input$showIdeal)
      options["ideal"] = "Ideal"
    subDiamonds <- subset(diamonds, cut_txt %in% options)
    if (nrow(subDiamonds) > 0) {
      y <- subDiamonds$price
      x <- subDiamonds$carat 
      
      n <- length(y)
      fit <- lm(y ~ x)
      e <- resid(fit)
      yhat <- predict(fit)
      max(abs(e -(y - yhat)))
      max(abs(e - (y - coef(fit)[1] - coef(fit)[2] * x)))
      
      
      plot(subDiamonds$carat, subDiamonds$price,  
           xlab = "Mass (carats)", 
           ylab = "Price (SIN )", 
           bg = "lightblue", 
           col = "black", cex = 2, pch = 21,frame = FALSE)
      abline(fit, lwd = 2) # simple way to add fit lm(y ~ x)
      
      plot(x, e,  
           xlab = "Mass (carats)", 
           ylab = "Residuals (SIN )", 
           bg = "lightblue", 
           col = "black", cex = 2, pch = 21,frame = FALSE)
      abline(h = 0, lwd = 2)
    }
  })    
})