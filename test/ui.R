library(shiny)
library(threejs)

shinyUI(fluidPage(
  checkboxInput("testCheckbox", "3-D plot"),  
  scatterplotThreeOutput("test", height='600px')
))
