library(shiny)
library(DT)
library(stringr)
library(rbokeh)

data <- readRDS('ede_data.rds')

shinyUI(fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
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
                  checkboxGroupInput(
                    "disc_methods",
                    label=h4("Discovery method"),
                    choices=unique(data$PLANETDISCMETH),
                    selected=unique(data$PLANETDISCMETH)
                  ),
                  hr(),
                  div(
                    class="attrib",
                    "Data from ",
                    a(href="http://exoplanets.org", "Exoplanet Data Explorer")
                  )
                ),
                mainPanel(
                  rbokehOutput('plot_planets', height='600px')
                )
                )
))
