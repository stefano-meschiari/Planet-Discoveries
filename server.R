library(shiny)
library(DT)
library(stringr)
library(dplyr)
library(rbokeh)
library(RColorBrewer)
data <- readRDS('ede_data.rds')

shinyServer(function(input, output) {  
  filtered_data <- reactive({
    disc_methods <- input$disc_methods
    year_range <- input$years

    data %>%
      mutate(color = brewer.pal(7, 'Set1')[as.factor(PLANETDISCMETH)],
             Name=NAME,
             Year=DATE,
             Mass=sprintf("%.2f", data$MASS),
             Period=sprintf("%.2f", data$PER),
             DiscMethod=PLANETDISCMETH) %>%
      filter(PLANETDISCMETH %in% disc_methods &
                                   DATE >= year_range[1] &
                                   DATE <= year_range[2])
  })

  output$plot_planets <- renderRbokeh({
    data <- filtered_data()
    p <- figure(xlim=c(0.1, 10^6), ylim=c(5e-5, 50)) %>%
      ly_points(PER, MASS, data=data,
                color=PLANETDISCMETH,
                line_color=color,
                fill_color=color,
                hover=list(Name, Year, DiscMethod, Period, Mass)) %>%
      x_axis(label='Period [d]', log=TRUE) %>%
      y_axis(label='Mass [Mjup]', log=TRUE)
    p    
  })

  output$nplanets <- renderText({ str_c(nrow(filtered_data()), " planets selected.") })
})