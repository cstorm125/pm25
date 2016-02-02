#download then unzip
download.file(url='https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip',destfile='fnei.zip')
unzip('fnei.zip')
#Read
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
#Merge
#merged<-merge(NEI,SCC,by.x='SCC',by.y='SCC',all=FALSE)

#Get SCC for coal-related combustions
i<-grep('Motor',SCC$Short.Name,ignore.case = TRUE)
index <-SCC[i,]$SCC

#Aggregate and name columns
motorem <-aggregate(NEI$Emissions,
                    by=list(NEI$year, NEI$SCC %in% index,NEI$fips=='24510'),sum)
names(motorem) <-c('year','Motor','Bal','Emissions')
motorem<-motorem[motorem$Motor==TRUE & motorem$Bal==TRUE,]

#Plot
library(ggplot2)
qplot(year,Emissions,data=motorem, geom=c('line'), 
      main='Emission from Motor-related Sources 1999-2008 in Baltimore City')

#Save
ggsave(file="plot5.png", dpi=72)