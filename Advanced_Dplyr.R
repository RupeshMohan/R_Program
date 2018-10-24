require(dplyr)

data<-read.csv('sampledata.csv')

head(data)

sample_n(data,1) # Return Data of 1 Row

sample_frac(data,0.5) # Return 50% of data random

head(distinct(data))

distinct(data, Index, .keep_all= TRUE) # Distinct based on col

distinct(data, Index,Y2011 ,.keep_all= TRUE)

select(data,State,Y2006,everything()) # Reorder col arrangement

data%>% rename(index_index=Index)%>%head()

data%>% filter(grepl("Ar",State))%>% head


data%>% summarise_at(vars(Y2005,Y2006),funs(n(),mean,median))

data%>%summarise_at(vars(Y2005,Y2006),funs(n(),missing=(sum(is.na(.))),mean(.,na.rm=TRUE)))


data%>% filter(Index %in%c('A','C','I'))%>%group_by(Index) %>%do(head(.,2))

mutate_all(data,funs("new"=.*10))


