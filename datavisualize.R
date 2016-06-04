library(gridExtra)
library(ggplot2)
p <- read.csv("../DataMining/DataViz/D3jsHTML/D3JSGraphing/data.csv",stringsAsFactors = F)
p <- p[1:nrow(p)-1,]
for (i in 1:ncol(p)) { p[,i] <- as.numeric(p[,i])}
colnames(p) <- make.names(colnames(p))


plot1 <- ggplot(p) + geom_point(aes(x=Year,y=JDMean)) + 
        geom_smooth(data = p,mapping = aes(x=Year,y=JDMean,colour="Global"),method="lm",se=F,size=2,show.legend=TRUE) + 
        geom_smooth(data = p,mapping = aes(x=Year,y=NHem,colour="N.Hem"),method="lm",se=F,size=1.25,show.legend=TRUE) + 
        geom_smooth(data = p,mapping = aes(x=Year,y=SHem,colour="S.Hem"),method="lm",se=F,size=1.25,show.legend=TRUE) + 
        scale_colour_manual(name='Legend', breaks=c("Global","N.Hem","S.Hem"),values=c("gray", "blue","red"))+
        xlab("Year") + ylab("Temperature Mean") + ggtitle("Temparature Mean in Northern and Southern Hemisphere: 1880-2014")

model <- lm(JDMean ~ Year,data=p)
ppredict <- predict(model)
p$MeanDev <- p$JDMean-ppredict

plot2 <- ggplot(p,aes(x=Year,y=MeanDev)) + 
        geom_point(alpha=2/10, shape=21, fill="blue", colour="black", size=3) + 
        geom_smooth(aes(colour="Loess Smoothener"),method="loess",se=TRUE) +
        stat_smooth(aes(colour="Cubic Poly."),method="lm", se=TRUE, fill=NA,formula=y ~ poly(x, 3, raw=TRUE)) +
        scale_colour_manual(name='Legend', breaks=c("Loess Smoothener","Cubic Poly."),values=c("orange","darkred")) +
        xlab("Year") + ylab("Mean Temparature Deviation") + ggtitle("Global Mean Temparature Acceleration : 1880-2014")

require(gridExtra)
#plot1 <- qplot(1)
#plot2 <- qplot(1)
Netplot <- grid.arrange(plot1, plot2, nrow=2)

png("../DataMining/DataViz/D3jsHTML/D3JSGraphing/TemparatureTrends.png")
print(Netplot)
dev.off() #close the file
