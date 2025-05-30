

################################################################################
#                          ALPHA DIVERSITY                                     #
################################################################################

# This function calculate alpha diversity metrics for a phyloseq object
# 
# phy_objetc <- Phyloseq object created with qiime2 data
# group <- metadata column you want to use to separate data.
# alfa_metrics <- vector with the statistical metrics to calculate alfa diversity
# my comparision <- a list of pairs of condition you want to compare
# stat_metrics <- statistica metric do you want to use to see if there is a significant difference between conditions
# asterisk <- if yes show astherisks in accordance to significance level, if no write the pvalue

alpha_diversity_plot <- function(phy_object, group, alfa_metrics, my_comparisons, stat_metric, asterisk, title){
  library(ggpubr)
  #alpha diversity plot
  p <- plot_richness(phy_object, x=group, measures=alfa_metrics) 
  p <- p + geom_boxplot(alpha=9)
  p <- p + theme_light()
  
  if (asterisk == TRUE){
    p <- p + stat_compare_means(method = stat_metrics, comparisons = my_comparisons, label = "p.signif",  p.adjust.method = "BH")
  }else{
    p <- p + stat_compare_means(method = stat_metrics, p.adjust.method = "BH")  
    
  }
  p <- p + ggtitle(label = title) + theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    panel.border = element_rect(colour = "black", fill=NA, size=1),
    axis.title=element_text(size=14,face="bold"),
    axis.text=element_text(size=12),
    strip.text = element_text(size = 14),
    axis.title.x=element_blank())
  
  return(p)
}
  

################################################################################
#                           ABUNDANCE                                          #
################################################################################

plot_piechart <- function(df, metric, taxa){
  ggplot(df, aes(x="", y=get(metric), fill=get(taxa))) +
    geom_bar(stat="identity", width=1) +
    geom_col(width = 1, color = 1) +
    theme_void()+ 
    coord_polar("y", start=0)+
    theme(legend.text=element_text(size=12)) + 
    theme(strip.text = element_text(size = 14)) +
    labs(fill=taxa)
}

################################################################################
#                          DIFFERENTIAL ABUNDANCE DESEQ2                       #
################################################################################

daa_bar_plot <- function(df, contrast, title, col_pal){
  #Transform data
  # Phylum order
  x = tapply(df$log2FoldChange, df$Phylum, function(x) max(x))
  x = sort(x, TRUE)
  df$Phylum = factor(as.character(df$Phylum), levels=names(x))
  # Genus order
  x = tapply(df$log2FoldChange, df$Genus, function(x) max(x))
  x = sort(x, TRUE)
  df$Genus = factor(as.character(df$Genus), levels=names(x))
  
  #Generate plot
  plt <- ggplot(df) +
    geom_col(aes(x = log2FoldChange, y = Genus, fill = Phylum)) + 
    geom_vline(xintercept = 0.0, color = "Black", size = 0.7)  +
    ggtitle(title) +
    theme_minimal() 
    
    if (!identical(col_pal, FALSE)){
      plt <- plt + scale_fill_manual(values = col_pal) 
    }
  
  return(plt)
}

################################################################################
#                          BETA DIVERSITY                                      #
################################################################################

betadiversity_analysis <- function(pseq, method, distance, weighted = FALSE){
  if(tolower(distance) == "unifrac"){
    if(weighted == TRUE){
      phyloseq::ordinate(pseq, method = method, distance = distance, weighted=T)
    }else{
      phyloseq::ordinate(pseq, method = method, distance = distance, weighted=F)
    }
  }else{
    if(weighted == FALSE){
      phyloseq::ordinate(pseq, method = method, distance = distance)
    }else{
      print("These metrics do not use weight")
    }
  }
}

plot_distance <- function(pseq, bd, color, shape=NULL, elipse = TRUE){
  if(is.null(shape) == FALSE){
    plt <- plot_ordination(pseq, bd, color= color, shape=shape) + geom_point(size=3)
  }else{
    plt <- plot_ordination(pseq, bd, color= color) + geom_point(size=3)
  }
  
  plt <- plot_ordination(pseq, bd, color= color, shape=shape) + geom_point(size=3)
  if (elipse ==TRUE){
    plt <- plt + stat_ellipse() 
  }
  
  plt <- plt + theme_classic() +theme(axis.title=element_text(size=14,face="bold"),
                     axis.text=element_text(size=12),
                     legend.text=element_text(size=12),
                     legend.title=element_text(size=14))
  return(plt)
}
