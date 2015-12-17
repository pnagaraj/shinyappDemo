library(UsingR)
library(ggplot2)
library(shiny)
#return values for histogram
not_lambda<- function(input) {
    if(input<0.00001 ){
        "Lambda must be between 0.00001 and 100."
    }
    else if (input>100) {
        "Lambda cannot be greater than 100."
    }
    else if (input==""){
        "Enter a valid value."
    }
    else {NULL} 
}
not_nsamp<- function(input) {
    if(input<10 ){
        "Number of samples cannot be less than 10."
    }
    else if (input>200) {
        "Number of samples cannot be greater than 200."
    }
    else if (input==""){
        "Enter a valid value."
    }
    else {NULL} 
}
not_nosim<- function(input) {
    if(input<1 ){
        "Number of simulations cannot be less than 1."
    }
    else if (input>10000) {
        "Number of simulations cannot be greater than 10000."
    }
    else if (input==" "){
        "Enter a valid value."
    }
    else {NULL} 
}
histval<- function(lambda,nsamp,nosim) {
    means<-apply(matrix(rexp(nsamp*nosim, rate = lambda), nosim), 1, mean)
    sampmean <- mean(means)
    popmean <- 1/lambda
    se <-1/(lambda*sqrt(nsamp))
    x1 <- (means-(1/lambda))/se 
    result <- list(means=means,x1=x1)
    return(result)
}
meandif<- function(means,lambda) {
    sampmean<-mean(means)
    popmean<-1/lambda
    pdif=100*(sampmean-popmean)/popmean
    return (pdif)
}
shinyServer(
         function(input, output) {
            mydata<- reactive({ 
                validate(
                    not_lambda(as.numeric(input$lambdaval))
                )
                validate(
                    not_nsamp(as.numeric(input$nsampval))
  
                )
                validate(
                    not_nosim(as.numeric(input$nsimval))
                )
                values<-histval(as.numeric(input$lambdaval),as.numeric(input$nsampval),as.numeric(input$nsimval))
                values<-as.list(values)
                return(values)
                
            })
 
            output$newHist <- renderPlot({
            x1<-mydata()$x1
            g<-ggplot(data.frame(x1),aes(x1))
            g<- g + geom_histogram(binwidth = 0.5, colour = "black", fill = "cyan", aes(y=..density..))
            g<- g + stat_function(fun = dnorm, color = "purple", size = 2)
            g<- g + labs(x = "Sample means", y = "Density")
            g + labs(title = "Compare sample means to standard normal distribution")
            })
  
            output$sampmean<- renderText({
                means<-mydata()$means
                paste("*Sample Mean = ", round(mean(means),4))
            })
            output$popmean<- renderText({ paste("*Population Mean = ", round(1/input$lambdaval,2))})                        
            output$dif<- renderText ({
                means<-mydata()$means
                paste("**Percent Difference between the means = ", round((meandif(means,input$lambdaval)),2))
            })
            output$mesg1<- renderText({
                paste("As the number of simulations are increased, the histogram shown in Cyan matches the normal distribution of means shown in purple more closely. Note that the values in the histogram (in cyan) are standardized. As the number of simulations increase, the percent difference between the means decreases. For further help, click the Help tab.
            If the application is not responding, refresh the page and try again.")
            })    
            
                 
         }
)