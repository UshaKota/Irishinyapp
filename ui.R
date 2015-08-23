
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)



shinyUI(fluidPage(
  tags$head(tags$style(".rightAlign{float:right;}")),
  titlePanel("Iris Species Data Analysis"),
  sidebarLayout(
    navlistPanel(selected="Facts",id='mynavlist',
      "Presentation",
      
      tabPanel("Facts",
              helpText("ref://https://www.idiap.ch/software/bob/docs/releases/last/sphinx/html/IrisExample.html.
                The Iris flower data set or Fisher's Iris data set is a multivariate data set introduced by Sir Ronald Aylmer Fisher (1936) as an example of discriminant analysis. It is sometimes called Anderson's Iris data set because Edgar Anderson collected the data to quantify the morphologic variation of Iris flowers of three related species. The dataset consists of 50 samples from each of three species of Iris flowers (Iris setosa, Iris virginica and Iris versicolor). Four features were measured from each sample, they are the length and the width of sepal and petal, in centimeters. Based on the combination of the four features, Fisher developed a linear discriminant model to distinguish the species from each other.
                . The presentation is based on notes at :https://tgmstat.wordpress.com/2014/01/15/computing-and-visualizing-lda-in-r/ and "),
               radioButtons("picture", "Species Picture:",
                       list("setosa", "versicolor","virginica")),imageOutput("image2",height="50%"),
                       icon=icon("file-picture-o"), class = 'rightAlign',br()),
      tabPanel("Plots",radioButtons("visualization", "Visualization",
                                    list("pairs", "Sepal~Petal","scatterplot","boxplot")),icon = icon("bar-chart-o"),plotOutput("Plots",width="150%"),br()),
      tabPanel("LDA Model",plotOutput("ModelPlot"),checkboxInput("classification", "Show Classification result(head)", FALSE),fluidRow(verbatimTextOutput("classification")),
               checkboxInput("posterior", "Posterior Probabilities", FALSE),hr(),fluidRow(column(4, tableOutput("posterior"))),
               checkboxInput("projections", "LD Projections", FALSE),fluidRow(column(8, tableOutput("projections"))),icon=icon("book")) ,br(),
      
                                         well=T
#       fluid=T,
#       widths = c(4, 8)

#       
      
      
      
    ),
    sidebarPanel(verbatimTextOutput("This application is ")) 


    
  )
))
  