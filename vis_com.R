#!/bin/Rscript

library(shiny)
library(ggplot2)
library(patchwork)
library(easyGgplot2)
library(shinyjs)


load("taxainfo.RData")

ui <- fluidPage(
  titlePanel("Summarizing abundance of Eukaryotic taxa"),
  
  sidebarLayout(
    sidebarPanel(

      fileInput("file1", "choose a result of kraken style file from the pipeline", accept = ".KSout"),
      checkboxInput("showby", h4("showing top taxa"), value = T),
      
      textInput("text", h4("type in the taxon for result visualization:"), 
                value = "Rousettus,Chiroptera,Mammalia"),
      
      selectInput("level", 
                  h4("taxonomic level to show"), 
                  choices =  c("S", "G","F", "C", "O", "P", "K"),
                  selected = "S"
      ),
      
      textInput("dlpath", 
                h4("path to download the table:"), 
                value = "PATH..."),
      
      checkboxInput("checkdl", 
                    h4("check to dowload file:"), 
                    value = F),
      sliderInput("perws", "ignoring taxa with exact percentage below:", 
                  value = 0.1, min = 0, max = 0.5),
      
      sliderInput("numtaxa", "number of top abundant taxa to visualiza:", 
                  value = 5, min = 0, max = 10),

      #selectInput("prots", h4("please select from:"), choices = unique(ws2$V1))
    ),
    mainPanel(
      dataTableOutput("pc_tab"),
      plotOutput("distPlot")
    )
  )
)

server <- function(input, output,session) {
  
  output$pc_tab <- renderDataTable({
    file <- input$file1
    ext <- tools::file_ext(file$datapath)
    
    req(file)
    validate(need(ext == "KSout", "Please upload a Krakken style out put file"))
    
    abdfile <- read.table(file$datapath, header = F, sep="\t")
    
    trimmed <- trimws(abdfile$V8)
    abdfile$V8 <- trimmed
    
    tababd <- data.frame()
    if(input$showby == T) {
      le <- unique(abdfile$V4)
      
      for(i in 1:length(le)){
        tabtmp <- subset(abdfile, abdfile$V4 == le[i])
        tabtmp <- tabtmp[match(sort(tabtmp$V1, decreasing =T), 
                               tabtmp$V1),]
        tababd <- rbind(tababd, tabtmp[1,])
        print(tabtmp[1,]$V8)

      }
      tababd <- tababd[, c(1,4,5,8)]
      tababd <- tababd[!is.na(tababd$V1), ]
      colnames(tababd) <- c("exact_abdance", "taxonomic_level", "taxon_id", "taxon_name")
    }
    else {
    taxa <- trimws(unlist(strsplit(as.character(input$text), ",")))

    for(i in 1:length(taxa)){
    id <- taxanames$V1[match(taxa[i], taxanames$V2)]
    print(id)
    linlist <- c(unlist(strsplit(taxaindexed[match(grep(paste("\\b",id,"\\b", sep=""), 
                                                        taxaindexed$lineage), 
                                                   rownames(taxaindexed)),]$lineage, " ")))
    linlist <- unique(linlist)
    acc <- match(linlist, abdfile$V5)[!is.na(match(linlist, abdfile$V5))]
    print(acc)
    if(length(acc) >0) {
    tabtmp <- abdfile[acc,]
    tabtmp$bytaxa <- taxa[i]
    tababd <- rbind(tababd, tabtmp)
    print(taxa[i])
    }
    }
    
    tababd <- tababd[, c(1,4,5,8,9)]
    colnames(tababd) <- c("exact_abdance", "taxonomic_level", "taxon_id", "taxon_name", "sortbytaxa")
    print(input$level)
    tababd <- subset(tababd, tababd$taxonomic_level == input$level)
    }

    if(input$checkdl == T && input$dlpath != "PATH...") {
      write.table(tababd, file=paste(input$dlpath), quote=F, sep="\t")
    }
    
    tababd

  },options = list(pageLength = 10))
  
  output$distPlot <- renderPlot({

    file <- input$file1
    ext <- tools::file_ext(file$datapath)
    
    req(file)
    validate(need(ext == "KSout", "Please upload a Krakken style out put file"))
    
    abdfile <- read.table(file$datapath, header = F, sep="\t")
    
    trimmed <- trimws(abdfile$V8)
    abdfile$V8 <- trimmed
    
    tababd <- data.frame()
    le <- unique(abdfile$V4)
    
    for(i in 1:length(le)){
      tabtmp <- subset(abdfile, abdfile$V4 == le[i])
      tabtmp <- tabtmp[match(sort(tabtmp$V1, decreasing =T), tabtmp$V1),]
      tababd <- rbind(tababd, tabtmp[1,])
      print(tabtmp[1,]$V8)
      
    }
    tababd <- tababd[, c(1,4,5,8)]
    tababd <- tababd[!is.na(tababd$V1), ]
    colnames(tababd) <- c("exact_abdance", "taxonomic_level", "taxon_id", "taxon_name")
    tababd$label <- paste(tababd$taxon_name, tababd$taxonomic_level, sep = ";")
   
    pp <- ggplot(tababd, aes(x=reorder(label, -exact_abdance), y=exact_abdance, fill=label)) +
      geom_bar(stat="identity")+
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
      ggtitle("exact abundance of top abundant taxa")
    
    
    taxa <- trimws(unlist(strsplit(as.character(input$text), ",")))
    
    for(i in 1:length(taxa)){
      id <- taxanames$V1[match(taxa[i], taxanames$V2)]
      print(id)
      linlist <- c(unlist(strsplit(taxaindexed[match(grep(paste("\\b",id,"\\b", sep=""), 
                                                          taxaindexed$lineage), 
                                                     rownames(taxaindexed)),]$lineage, " ")))
      linlist <- unique(linlist)
      acc <- match(linlist, abdfile$V5)[!is.na(match(linlist, abdfile$V5))]
      print(acc)
      if(length(acc) >0) {
        tabtmp <- abdfile[acc,]
        tabtmp <- tabtmp[, c(1,4,5,8)]
        colnames(tabtmp) <- c("exact_abdance", "taxonomic_level", "taxon_id", "taxon_name")
        tabtmp <- subset(tabtmp, tabtmp$taxonomic_level == input$level)
        print(tabtmp$exact_abdance)
        tabtmp <- subset(tabtmp, tabtmp$exact_abdance >= input$perws)
        
        if(length(tabtmp$taxon_name) >0 ) {

        tabtmp$relative_abundance <- tabtmp$exact_abdance / sum(tabtmp$exact_abdance)
        tabtmp <- tabtmp[match(sort(tabtmp$exact_abdance, decreasing = T), 
                               tabtmp$exact_abdance), ]
        tabtmp <- tabtmp[1:input$numtaxa, ]
        
        data <- data.frame(relative_abundance = tabtmp$relative_abundance, taxa = tabtmp$taxon_name)
        data <- data[!is.na(data$taxa),]
        print(data$relative_abundance)
        
        data$ymax <- cumsum(data$relative_abundance)
        data$ymin <- c(0, head(data$ymax, n=-1))
        data$labelPosition <- (data$ymax + data$ymin) / 2
        data$label <- paste0(data$taxa, "\n value: ", round(data$relative_abundance * 100, digits = 4), "%")
        
        mp <- ggplot(data, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=label)) +
          geom_rect() +
          geom_text( x=1.5, aes(y=labelPosition, label=label, color=label), size=3) + # x here controls label position (inner / outer)
          scale_fill_brewer(palette=10) +
          scale_color_brewer(palette=10) +
          coord_polar(theta="y") +
          xlim(c(-1, 4)) +
          theme_void() +
          #theme(legend.position = "bottom") +
          ggtitle(taxa[i])
        
        }
        
        else {
          mp <- ggplot() +
            theme_void() +
            geom_text(aes(0,0,label='no species from the taxa was deteced beyond the threshold')) +
            xlab(NULL) +
            ggtitle(taxa[i])
        }
        
        print(taxa[i])
        
      }
      else{
        mp <- ggplot() +
          theme_void() +
          geom_text(aes(0,0,label='no species from the taxa was deteced')) +
          xlab(NULL) +
          ggtitle(taxa[i])
      }
      pp <- pp + mp
    }

    
    pp
  }, height = 800, width = 800)
  
  
  observeEvent(input$refresh, {
    session$invalidate
  })
  
  
}

shinyApp(ui = ui, server = server)

