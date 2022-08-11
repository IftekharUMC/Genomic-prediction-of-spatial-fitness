# Kendalls Tau ranking test
p<- read.csv ("KendallsTau2.csv", header = TRUE, sep = ",")

x = p$x
y = p$y
res<-cor.test(x,y, method="kendall")
res