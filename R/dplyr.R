library(dplyr) # Import package
library(hflights) # import data

data(hflights) # Load data

head(hflights) # diaply basic rows

df<-tbl_df(hflights) # converts to local_df


print(df,n=15) # returns 15 rows

data.frame(head(df))# Display with all col names

# FILTER ##

df[(df$Month==1 & df$DayofMonth==1),] # TWo  condtions(noraml appoarch)

filter(df,Month==1,DayofMonth==1)# use , to add condition

filter(df,df$UniqueCarrier=="AA" | df$UniqueCarrier=='UA') # Use Pipe for OR COndition

filter(df,df$UniqueCarrier %in%  c("AA","UA")) # Also use %in% operator  in R to customize the filter



## SELECT  DATAFRAME ###

df[,c("UniqueCarrier","Month","DayofMonth")] ## Normal DATA FRAME 



select(df,UniqueCarrier,Month,DayofMonth)# Dplyr way

select(df,Year:DayofMonth,contains("Taxi"),contains('Delay')) #  extract col contain such str and cont of cols

### Chaining || pipelining  ####

filter(select( df,UniqueCarrier,DepDelay),DepDelay>60) ## Filter data based on condition

## Chaining Method ##

df%>% 
  select(UniqueCarrier,DepDelay) %>%
  filter(DepDelay>60)                ## chaining method


## ARRANGE DATA ####
df[order(df$DepDelay),c('UniqueCarrier','DepDelay')] ## Normal method

## dplyr way

df %>%  select(UniqueCarrier,DepDelay) %>%  arrange(DepDelay) 


df %>%  select(UniqueCarrier,DepDelay) %>%  arrange(desc(DepDelay))


## MUTATE ADD NEW VARIABLE ###

df %>% select(Distance,AirTime) %>%  mutate(speed=Distance*AirTime) # speed new VAR

## GROUPBY ###

df %>% group_by(Dest) %>% summarise(avg_delay=mean(ArrDelay,na.rm=TRUE))
 
df %>% group_by(Dest) %>% summarise(avg_delay=median(ArrDelay,na.rm=TRUE))


head(aggregate(ArrDelay ~ Dest ,df , mean))



df %>% group_by(UniqueCarrier) %>%  summarise_each(funs(mean),Cancelled,Diverted) # Each Carrier

df %>% group_by(UniqueCarrier) %>% summarise_each(funs(min(.,na.rm=TRUE),max(.,na.rm=TRUE)),matches("Delay"))

df %>% group_by(Month,DayofMonth) %>% summarise(fligth_count=n()) %>% arrange(desc(fligth_count))

df %>% group_by(Month,DayofMonth) %>% tally(sort=TRUE) # rewrite with tally


df %>% group_by(Dest) %>% select(Cancelled) %>% table() %>%head()



df %>% group_by(UniqueCarrier) %>%select(Month,DayofMonth,DepDelay)%>% filter(min_rank(desc(DepDelay))<=2)%>%arrange(UniqueCarrier,desc(DepDelay)) 



df %>% group_by(Month) %>% tally() %>% mutate(change =n -lead(n)) # after sub
# lag previous sub


## group by and summerizse and mutuate function

df2=data.frame(ID=c(3,5,7:9), Score=c(52,60:63))
df1=data.frame(ID=c(1:5), Score=c(50:54))

intersect(df1,df2) ## Extrct unique row from two dataset common to both

