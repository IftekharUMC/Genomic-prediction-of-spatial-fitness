library(ggplot2)
X<-read.csv("pheno_barplot_STD.csv",header=T, sep =",")
# bar plot
p<- ggplot(X, aes(x=StrainID, y=Average.Surface.Fitness, fill=Reference.Strains)) + 
  geom_bar(stat="identity", color="black", width=0.8,
           position=position_dodge()) +
  geom_errorbar(aes(ymin=Average.Surface.Fitness-STD, ymax=Average.Surface.Fitness+STD), width=.5,
                position=position_dodge(0.8)) 

p1<- p+labs(title="Surface Fitness of CC5-I Study Strains \nin Relative to Reference Strains USA300 BASAL NAE, NAE and SAE", x="Study Strains", y = "Average Surface Fitness")+
  theme_classic() +
  scale_fill_manual(values=c('Red','Blue','Green'))
p2<- p1 + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1,size=5),
                axis.text.y = element_text(size = 20))
p3<- p2 + theme(plot.title = element_text(hjust = 0.5,size=20))
p4<- p3 + theme(axis.title = element_text(size=20))
p4