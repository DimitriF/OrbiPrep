#### License ####
#Copyright (C) {2016}  {Fichou Dimitri}
#{dimitrifichou@laposte.net}

#This program is free software; you can redistribute it and/or modify 
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation; either version 2 of the License, or
# any later version.

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License along
#with this program; if not, write to the Free Software Foundation, Inc.,
#51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


library(shiny)
# library(jpeg)
# library(png)
# library(jpeg)
# library(knitr)
# library(markdown)
# library(abind)
library(DLC)
library(rmarkdown)

# source("R/f.read.image.R")
# source("R/raster.R")

shinyServer(function(input, output) {

  files <- reactive({
    validate(
      need(!is.null(input$files), "Please upload the pictures")
    )
    validate(
      need("DLC" %in% installed.packages(), "Install the DLC package: devtools::install_github('DimitriF/DLC')")
    )
    DLC::f.read.image(input$files$datapath, height = 1000 - 10*input$cropping*2, ls.format = T)
  })
  
  coord <- reactiveValues(x=NULL,y=NULL)
  
  observeEvent(input$click.plot.1,{
    coord$x <- c(coord$x,round(input$click.plot.1$x))
    coord$y <- c(coord$y,round(input$click.plot.1$y))
  })
  observeEvent(input$click.plot.2,{
    coord$x <- c(coord$x,round(input$click.plot.2$x))
    coord$y <- c(coord$y,round(input$click.plot.2$y))
  })
  observeEvent(input$click.plot.3,{
    coord$x <- c(coord$x,round(input$click.plot.3$x))
    coord$y <- c(coord$y,round(input$click.plot.3$y))
  })
  observeEvent(input$remove_last,{
    if(length(coord$x) > 1){
      coord$x <- coord$x[-length(seq(coord$x))]
      coord$y <- coord$y[-length(seq(coord$y))]
    }else{
      coord$x <- NULL
      coord$y <- NULL
    }
    
  })
  
  pict.1 <- reactive({
    par(mar=c(0,0,3,0),xaxt="n",yaxt="n")
    DLC::raster(files()[[1]],main=input$files$name[1],xlim=c(0,2*dim(files()[[1]])[1]))
    if(!is.null(coord$x)){
      text(x=coord$x,y=coord$y,label=seq(length(coord$x)),col="red",pos = 3)
      symbols(x=coord$x,y=coord$y,fg="red",inches = F,add = T,rectangles = cbind(rep(input$stamp_width*10,length(coord$x)),rep(input$stamp_height*10,length(coord$x))))
    }
  })
  pict.2 <- reactive({
    validate(
      need(length(files()) >= 2, "need 2 files to show the third picture")
    )
    par(mar=c(0,0,3,0),xaxt="n",yaxt="n")
    DLC::raster(files()[[2]],main=input$files$name[2],xlim=c(0,2*dim(files()[[2]])[1]))
    if(!is.null(coord$x)){
      text(x=coord$x,y=coord$y,label=seq(length(coord$x)),col="red",pos = 3)
      symbols(x=coord$x,y=coord$y,fg="red",inches = F,add = T,rectangles = cbind(rep(input$stamp_width*10,length(coord$x)),rep(input$stamp_height*10,length(coord$x))))
    }
  })
  pict.3 <- reactive({
    validate(
      need(length(files()) >= 3, "need 3 files to show the third picture")
    )
    par(mar=c(0,0,3,0),xaxt="n",yaxt="n")
    DLC::raster(files()[[3]],main=input$files$name[3],xlim=c(0,2*dim(files()[[3]])[1]))
    if(!is.null(coord$x)){
      text(x=coord$x,y=coord$y,label=seq(length(coord$x)),col="red",pos = 3)
      symbols(x=coord$x,y=coord$y,fg="red",inches = F,add = T,rectangles = cbind(rep(input$stamp_width*10,length(coord$x)),rep(input$stamp_height*10,length(coord$x))))
    }
  })
  
  output$pict.1 <- renderPlot({
    pict.1()
  })
  output$pict.2 <- renderPlot({
    pict.2()
  })
  output$pict.3 <- renderPlot({
    pict.3()
  })
  
  table.dim <- reactive({
    data <- data.frame(pictX = coord$x, pictY = coord$y)
    data$stamp = seq(nrow(data))
    data$x = data$pictX/10 + input$cropping
    data$y = data$pictY/10 + input$cropping
    data$reverse_y = 100 - data$y
    data$Rt = rep("         ",nrow(data))
    data$mz_pos = rep("         ",nrow(data))
    data$mz_neg = rep("         ",nrow(data))
    data$remark = rep("               ",nrow(data))
    data[,3:ncol(data)]
  })
  
  output$table <- renderTable({
    table.dim()
  })
  
  output$Report <- downloadHandler(
    filename = function() {
      paste('Orbiprep_report', sep = '.', switch(
        input$format, PDF = 'pdf', HTML = 'html', Word = 'docx'
      ))
    },
    
    content = function(file) {
      src <- normalizePath('report.Rmd')
      
      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, 'report.Rmd')
      
      library(rmarkdown)
      out <- render('report.Rmd', switch(
        input$format,
        PDF = pdf_document(), HTML = html_document(), Word = word_document()
      ))
      file.rename(out, file)
    }
  )

})
