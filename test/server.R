library(shiny)
library(threejs)

shinyServer(function(input, output) {  
  filtered_data <- reactive({
    active <- input$testCheckbox
    
    if (active)
      return(list(x=rnorm(10), y=rnorm(10), z=rnorm(10)))
    else
      return(list(x=rnorm(100), y=rnorm(100), z=rnorm(100)))
  })

  
  output$test <- renderScatterplotThree({
    data <- filtered_data()
    colors <- sapply(seq(0, 1, length.out=length(data$x)), function(x) rgb(x, x, x))
    scatterplot3js(data$x, data$y, data$z, size=1, col=colors,
                   renderer='auto')    
  })
  

  output$plot_planets <- renderRbokeh({
    data <- filtered_data()
    p <- figure(xlim=c(0.1, 10^6), ylim=c(5e-5, 50)) %>%
      ly_points(PER, MASS, data=data,
                line_color=color,
                fill_color=color,
                hover=list(Name, Year, DiscMethod, Period, Mass)) %>%
      x_axis(label='Period [d]', log=TRUE) %>%
      y_axis(label='Mass [Mjup]', log=TRUE)
    return(p)
  })


  output$nplanets <- renderText({ str_c(nrow(filtered_data()), " planets selected.") })
})
