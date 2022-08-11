
library(dplyr)
library(ggpubr)

# Paired t test: Two-sample Assuming Equal Variances
p<- read.csv ("NAEvsSAEvsBASAL_NAE_29.csv", header = TRUE, sep = ",")

# group my data
group_by(p, Reference.Strain) %>%
  summarise(
    count = n(),
    mean = mean(Surface.Fitness, na.rm = TRUE),
    sd = sd(Surface.Fitness, na.rm = TRUE)
  )
# Compare means
compare_means(Surface.Fitness ~ Reference.Strain, data = p)

# Visualize: Specify the comparisons you want
my_comparisons <- list( c("NAE", "SAE"), c("NAE", "BASAL NAE"), c("SAE", "BASAL NAE") )

p1<- ggboxplot(p, x = "Reference.Strain", y = "Surface.Fitness", 
               color = "Reference.Strain", palette = c("Blue","Green","Red"),
               order = c("NAE", "SAE","BASAL NAE"),
               xlab = "Reference Strains", ylab = "Average Surface Fitness", add="jitter")
p1
p2 <- p1 +   stat_compare_means(comparisons = my_comparisons) + # Add pairwise comparisons p-value
  stat_compare_means(label.y = 0.9)     # Add global p-value
p2
