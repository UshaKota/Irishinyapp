
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
#library(GGally)
library(reshape2)
#library(biglm)
library(MASS)
library(scales)

data(iris)
shinyServer(function(input, output, session) {
# send the pictures of each species  
  
  # image2 sends pre-rendered images
  output$image2 <- renderImage({
    if (is.null(input$picture))
      return(NULL)
    
    if (input$picture == "setosa") {
      return(list(
        src = "images/Iris-setosa-10_1.jpg",
        contentType = "image/jpeg",
        alt = "IrisSetosa",height=200,width=200
      ))
      
    } else if (input$picture == "versicolor") {
      return(list(
        src = "images/Iris-versicolor-21_1.jpg",
        filetype = "image/jpeg",
        alt = "Iris Versicolor",height=200,width=200
      ))
    }
      else if (input$picture == "virginica") {
        return(list(
          src = "images/Iris-virginica-3_1.jpg",
          filetype = "image/jpeg",
          alt = "Iris Versicolor",height=200,width=200
        ))
    }
    
  }, deleteFile = FALSE)
  
  output$text1 <- renderText({ 
    "UshaKota"
  })
  
  output$Plots <- renderPlot({
    
    if (input$visualization == "pairs") {
      #return()
      pairs(iris[1:4], main = "Edgar Anderson's Iris Data", pch = 21, bg = c("red", "green3", "blue",height = 600, width = 800)[unclass(iris$Species)])
      
    } else if (input$visualization == "Sepal~Petal") {
      qplot(Sepal.Length, Petal.Length, data = iris, color = Species, size=Petal.Width,
            xlab = "Sepal Length", ylab = "Petal Length",
            main = "Sepal vs. Petal Length in Fisher's Iris data")
            
    }
    else if (input$visualization == "scatterplot") {
      
      plot(iris$Sepal.Width, iris$Sepal.Length, pch=21, bg=c("red","green3","blue")[unclass(iris$Species)], main="Edgar Anderson's Iris Data", xlab="Sepal Width", ylab="Sepal Length")
      abline(lm(Sepal.Length ~ Sepal.Width, data=iris)$coefficients, col="black")
      
#       ggplot(iris, aes(x=Petal.Length, fill=Species)) + 
#         geom_histogram(position="dodge", binwidth=0.1)
#       
    }
    
    else if (input$visualization == "boxplot") {
      dat_long <- melt(iris)
      
      ggplot(dat_long, aes(x=variable, y=value, fill=Species)) + geom_boxplot()
      
    }
  })
    
    output$ModelPlot <- renderPlot({
      val.list<-model.data()
      dataset<-val.list$dataset
      lda<-dataset$lda
      prop.lda<-val.list$prop.lda
      
      ggplot(dataset) + geom_point(aes(lda.LD1, lda.LD2, colour = species, shape = species,size=2.5)) + ggtitle("Iris Species LD Projections") + 
      labs(x = paste("LD1 (", percent(prop.lda[1]), ")", sep=""),
           y = paste("LD2 (", percent(prop.lda[2]), ")", sep="")) + theme(panel.grid.major = element_line(colour = "blue"))   
    
  })
  
    
    model.data<-reactive({
      train <- sample(1:150, 75)
      
      r3 <- lda(Species ~ ., # training model
                iris, 
                prior = c(1,1,1)/3 
                )
      
      plda = predict(object = r3, # predictions
                     newdata = iris)
      
      
      prop.lda = r3$svd^2/sum(r3$svd^2)
      
      
      dataset = data.frame(species = iris[,"Species"],p.width=iris[,"Petal.Width"],
                           lda = plda$x)
      
      return(list(dataset=dataset, prop.lda=prop.lda, plda=plda, model=r3))
    
    })
    



output$classification <- renderPrint({ 
  
  if(input$classification){
    model<-model.data()
    head((model$plda)$class)
  } 
})

output$posterior <- renderTable({ 
  if(input$posterior){
  model<-model.data()
  head(model$plda$posterior, 3)
  }
})


output$projections <- renderTable({ 
  if(input$projections) {
  model<-model.data()
  head(model$plda$x, 3)
  }
})

})
    
 
    
 