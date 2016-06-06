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

shinyUI(fluidPage(

  titlePanel("OrbiPrep"),

  sidebarLayout(
    sidebarPanel(
      fileInput("files",label = "picture(s) file(s)",multiple = T),
      h4("The picture should not be cropped outside of the export otherwise the calcul will not be accurate, only the wincats cropping is supported for the moment"),
      numericInput("cropping","cropping (mm)",value=2),
      numericInput("stamp_width","stamp width (mm)",value=2),
      numericInput("stamp_height","stamp height (mm)",value=1),
      actionButton("remove_last","remove last stamp"),
      radioButtons('format', 'Document format', c('PDF', 'HTML', 'Word'),
                   inline = TRUE),
      downloadButton("Report")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("pictures",
                 plotOutput("pict.1",click="click.plot.1"),
                 plotOutput("pict.2",click="click.plot.2"),
                 plotOutput("pict.3",click="click.plot.3")
                ),
        tabPanel("table",
                 tableOutput("table")
                 )
      )
    )
  )
))
