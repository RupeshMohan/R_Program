library(data.table) # Import Library

library(hflights) # Import Library

citation('data.table') # detail about lib

head(hflights) # Print 6 rows

class(hflights) # Data Type

colnames(hflights) #Return colname of df

df<-as.data.table(hflights) # Convert df to data table


hflights[1:5,c('DepDelay','ArrDelay')] # data frame method

df[1:5,list(DepDelay,ArrDelay)] # data table way

df[1:5,.(DepDelay,ArrDelay)] # . dot operation

## DATA FILTERATION ##
 
head(hflights[hflights$ArrDelay>=45,'Origin']) # data frame way filter data (return Origin)

head(df[ArrDelay>=45,Origin]) # data table filter

## OMIT NAN VALUES ##
length(hflights[!is.na(hflights$ArrDelay),"ArrDelay"]) # data frame way

length(df[,na.omit(ArrDelay)]) # data table way


## DATA Aggreagtion ##



