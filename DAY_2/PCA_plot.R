# Limpiamos el ambiente de R
rm(list=ls())
graphics.off()
set.seed(1)

# Cargamos las librerías y dependencia
library(ggplot2)
library(stringr)

setwd(" ")

### Observemos los Eigenvalues

# Cargamos los datos de eigenvalues
Val <- read.table("pca_results.eigenval") 
Val$PC <- c(1:20)  
colnames(Val) <- c("percent","PC")
print(Val)

# Graficamos  los eigenvalues en Barplot o Histogramas 
ggplot(Val[1:5,], aes(x=Val[1:5,]$PC, y=Val[1:5,]$percent), xlab = "PC") +
  geom_bar(stat = "identity", width = 0.5) +
  labs(y= "% variance", x = "PC")+
  lims(y=c(0,10)) +
  scale_y_continuous(breaks = c(0,2,4,6,8,10))


### Observemos los Eigenvectors

## Cargamos los datos de eigenvector
Vec <- read.table("pca_results.eigenvec", sep = "", fill = TRUE)
Vec <- Vec[,(1:5), drop=FALSE] 
colnames(Vec)<-c("ID","Species","PCA1","PCA2","PCA3") 
print(Vec$Species)  
print(Vec$ID) 


## Graficamos los Componentes 1 vs 2.  PC1 vs PC2

p1 <- ggplot (Vec, aes(x= PCA1, y= PCA2, color = Species))+  
  geom_point(size=4)+  
  theme_classic()+  
  labs(x="PC1 (4.44%)", y="PC2 (2.84%)") +  
  theme(axis.title.x = element_text(face="bold", vjust=0, size=rel(1.5))) +  
  theme(axis.title.y = element_text(face="bold", vjust=1.5, size=rel(1.5)))+  
  theme(panel.border = element_rect(colour="black", fill=NA, size=1))  
print(p1)

p2 <- p1 + scale_colour_manual(values = c("#CA3F3F","#64AD3F","#E8B547", "#5F9EA0"))
print(p2)


## Graficamos los Componentes 2 vs 3. PC2 vs PC3

p3 <- ggplot (Vec, aes(x= PCA2, y= PCA3, color = Species))+
  geom_point(size=4)+
  theme_gray()+
  labs(x="PC2 (1.99%)", y="PC3 (1.8%)") +
  theme(axis.title.x = element_text(face="bold", vjust=0, size=rel(1.5))) +
  theme(axis.title.y = element_text(face="bold", vjust=1.5, size=rel(1.5))) +
  theme(panel.border = element_rect(colour="black", fill=NA, size=1))
print(p3)
p4 <- p3 + scale_colour_manual(values = c("#CA3F3F","#64AD3F","#E8B547", "#5F9EA0"))
print(p4)