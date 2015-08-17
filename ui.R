library(shiny)
library(DT)
library(stringr)
library(rbokeh)
library(devtools)
library(threejs)

data <- readRDS('ede_data.rds')

shinyUI(fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
  tags$script(src = "debug.js"),
  
  div(class="page-header",
      h1('Planetary candidates'),
      div(class="pull-right lead",
          "Created by ",
          a(href="http://stefano-meschiari.github.io", "Stefano Meschiari")
          ),
      div(class="lead subtitle",
          textOutput("nplanets"))
      ),
  sidebarLayout(position="right",
                sidebarPanel(
                  checkboxInput("threed", "3-D plot"),
                  sliderInput(
                    "years",
                    label=h4("Discovery year"),
                    min=min(data$DATE),
                    max=max(data$DATE),
                    value=range(data$DATE),
                    sep='',
                    round=0,
                    step=1
                  ),
                  div(
                    id="disc-methods-container",
                    checkboxGroupInput(
                      "disc_methods",                    
                      label=h4("Discovery method"),
                      choices=unique(data$PLANETDISCMETH),
                      selected=unique(data$PLANETDISCMETH)
                    )
                  ),
                  hr(),
                  div(
                    class="attrib",
                    "Data from ",
                    a(href="http://exoplanets.org", "Exoplanet Data Explorer")
                  )
                ),
                mainPanel(
                  conditionalPanel(
                    condition = "input.threed == false",
                    rbokehOutput('plot_planets', height='600px')
                  ),
                  conditionalPanel(
                    condition = "input.threed == true",
                    scatterplotThreeOutput("plot_planets_3d", height='600px')
                  )
                )
                )
))
