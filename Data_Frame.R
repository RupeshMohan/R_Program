df1<-read.csv('hw.csv') ## Read Data 

## FILTERING ###

df1$Height>52 # return True or False 

which(df1$Height)>52  # Return Index of True

df1[which(df1$Height>52),] # Return data frame True

 
df1[which(df1$Height>52),"Weight"] # Return data frame True Weight col

df1[which(df1[,2]>52),2] ## Acess using Number that col represent

## Sorting DF ###

order(df1$Height) ## Return ordered INdex ascending
 
order(-df1$Height) ## Return INdex  in Descending

df1[order(df1$Height),] ## Return data frame with order

df1[order(df1$Height),][2] # Return data frame with one col 
 
df1[rev(order(df1$Height)),][2] ## Return in Descing order

attach(df1) ## Access Each col individually

names(df1)

class(Customer.No)

## CREATE DF FROM MATRIX ##

mat<-matrix(1:100,nrow=10)
mdf<-data.frame(mat)

attach(mdf)


rbind(X1,X2,X3) # Row wise append

cbind(X4,X5,X6) # COl Wise append

object.size(mdf) # size of df

## SUBSETTING ###

subset(df1,Height>70,select = Weight) ## SUBSET FILTER only weight

subset(df1,Height>70,select = -Weight) ## SUBSET FILTER exclude weight

# CAlucuate the frqency of apaerance ##
library(datasets)
as.data.frame(table(iris$Species)) # frequency of occurence

dim(df1) # Shape of df

df$mpg[df$mpg==21]<-21454 # REPLACE VLAUE IN R
