
library(dplyr)
library(ggpubr)

# Paired t test: Two-sample Assuming Equal Variances
p<- read.csv ("NAEvsSAEvsBASAL_NAE.csv", header = TRUE, sep = ",")

# group my data
group_by(p, Reference.Strain) %>%
  summarise(
    count = n(),
    mean = mean(Surface.Fitness, na.rm = TRUE),
    sd = sd(Surface.Fitness, na.rm = TRUE)
  )

library("ggpubr")
p1<- ggpaired(p, x = "Reference.Strain", y = "Surface.Fitness", 
          color = "Reference.Strain", line.color = "gray", line.size = 0.4,
          palette = c("Blue", "Green", "Red"),
          order = c("NAE", "SAE", "BASAL NAE"),
          xlab = "Reference Strains", ylab = "Average Surface Fitness", add="jitter")
p2<-p1+ stat_compare_means(paired = TRUE) 
p2
