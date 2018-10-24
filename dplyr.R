##  http://genomicsclass.github.io/book/pages/dplyr_tutorial.html

require(dplyr)

require(downloader)

url <- "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/msleep_ggplot2.csv"

file<-'msleep.csv'

if(!file.exists(file)) download(url,file)

df<-read.csv('msleep.csv')

head(df)

## SELECT FUNCTION ##

head(select(df,name,sleep_total)) # select require col 

head(select (df,-name)) # select all and except col use (-) negative sign

head(select(df,name:brainwt)) # select a range of cols use (:) colon sign

head(select(df,starts_with('na'))) ## select col name start_with() ,ends_with(), contains() ,matches(),one_of()

# filter ()

filter(df,df$sleep_total>16) ## filter() and && or opertor are also used

filter(df, order %in% c("Perissodactyla", "Primates")) # in operator

# Arrange()

head(arrange(df,df$sleep_total))

head(arrange(select(df,order,sleep_total),sleep_total,order))
df%>% select(order,sleep_total)%>% arrange(order,sleep_total) %>% head()

# mutate()

df %>% 
  mutate(rem_proportion = sleep_rem / sleep_total, 
         bodywt_grams = bodywt * 1000) %>% head
## summarise()

df%>% summarise(mean(sleep_total)) # summarise data with function

df%>% summarise(mean=mean(sleep_total)) # label summary output

df%>% summarise(avg=mean(sleep_total),min=min(sleep_total),max=max(sleep_total),total=n(),unique=n_distinct(sleep_total))
# few summarise function

## Group_by()

df%>%
  group_by(order)%>%
  summarise(avg=mean(sleep_total),min=min(sleep_total),max=max(sleep_total),count=n(),Unique=n_distinct(sleep_total))%>%
  head()

