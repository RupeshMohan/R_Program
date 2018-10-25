# Dplyr - Guide -----------------------------------------------------------
# Load Data ---------------------------------------------------------------
require(hflights)
# load package ------------------------------------------------------------
require(dplyr)
# Call both head() and summary() on hflights ------------------------------
head(hflights)
summary(hflights)
# Convert the hflights data.frame into a hflights tbl -------------------
hflights<-tbl_df(hflights)

# the object carriers, containing only the UniqueCarrier variable --------
carriers <- hflights$UniqueCarrier

glimpse(hflights)

lut <- c("AA" = "American", "AS" = "Alaska", "B6" = "JetBlue", "CO" = "Continental", 
         "DL" = "Delta", "OO" = "SkyWest", "UA" = "United", "US" = "US_Airways", 
         "WN" = "Southwest", "EV" = "Atlantic_Southeast", "F9" = "Frontier", 
         "FL" = "AirTran", "MQ" = "American_Eagle", "XE" = "ExpressJet", "YV" = "Mesa")
hflights$UniqueCarrier=lut[hflights$UniqueCarrier]
glimpse(hflights)

# Fill up empty entries of CancellationCode with 'E'
# To do so, first index the empty entries in CancellationCode
lut = c('A' = 'carrier', 'B' = 'weather', 'C' = 'FFA', 'D' = 'security', 
        'E' = 'not cancelled')
cancellationEmpty <- hflights$CancellationCode == ""
# Assign 'E' to the empty entries
hflights$CancellationCode[cancellationEmpty] <- 'E'

# Use the lookup table to create a vector of code labels. Assign the vector to the CancellationCode column of hflights
hflights$CancellationCode <- lut[hflights$CancellationCode]

# Distinct Count ----------------------------------------------------------
table(hflights$CancellationCode)


# Select() function -------------------------------------------------------

hflights[c('ActualElapsedTime','ArrDelay','DepDelay')]

# Dpylr Method ------------------------------------------------------------

hflights%>%select(ActualElapsedTime,ArrDelay,DepDelay)

# print range of col ------------------------------------------------------

hflights%>%select(Origin:CancellationCode)

# Select helper functions -------------------------------------------------

select(hflights, UniqueCarrier, FlightNum, contains("Tail"), contains("Cancel"))

select(hflights, ends_with("Time"), ends_with("Delay"))


# Mutate() Function -------------------------------------------------------


# Add New Variable print that varible --------------------------------------------------------

hflights%>%mutate(ActualGroundTime = ActualElapsedTime - AirTime)%>%select(ActualGroundTime,ActualElapsedTime,AirTime)%>%head()

# Add Multiple Variables --------------------------------------------------

hflights%>%mutate(G1=ActualElapsedTime - AirTime,G2=(G1/DepDelay) * 100)%>%select(G1,G2,AirTime,DepDelay)%>%head()


# Filter() ----------------------------------------------------------------

filter(hflights, Distance > 3000)

filter(hflights, UniqueCarrier %in% c('JetBlue', 'Southwest', 'Delta'))

filter(hflights, Cancelled == 1, DepDelay > 0)

filter(hflights, DayOfWeek %in% c(6,7) & Cancelled == 1)

filter(hflights, DepTime < 500 | ArrTime > 2200 )

# Arrange() ---------------------------------------------------------------

hflights%>%filter(Cancelled==1,!is.na(DepDelay))%>%arrange(DepDelay)

# Summarise() -------------------------------------------------------------

c1 <- filter(hflights, Dest == 'MSY')

c1%>%mutate(Date=paste(Year,Month,DayofMonth,sep='-'))%>%select(Date,DepTime,DepDelay)

nrow(filter(hflights, DayOfWeek %in% c(6,7), Distance > 1000, TaxiIn + TaxiOut < 15)) 

# Add variables in Summarize ----------------------------------------------

hflights%>%summarise(min_dist=min(Distance),max_dist=max(Distance))

summarize(filter(hflights, Diverted == 1), max_div = max(Distance))

# Remove rows that have NA ArrDelay: temp1 --------------------------------

temp1 <- filter(hflights, !is.na(ArrDelay))

summarise(temp1, earliest = min(ArrDelay), average = mean(ArrDelay), 
          latest = max(ArrDelay), sd = sd(ArrDelay))

# Keep rows that have no NA TaxiIn and no NA TaxiOut ----------------------

filter(hflights, !is.na(TaxiIn), !is.na(TaxiOut))

#  summarizing statistics for hflights ------------------------------------

summarise(hflights, n_obs = n(), n_carrier = n_distinct(UniqueCarrier), 
          n_dest = n_distinct(Dest), dest100 = nth(Dest, 100))

# Advanced  ---------------------------------------------------------------

hflights %>% 
  mutate(RealTime = ActualElapsedTime + 100, mph = Distance/RealTime*60) %>%
  filter(mph < 105 | Cancelled == 1 | Diverted == 1) %>%
  summarise(n_non = n(), p_non = 100*n_non/nrow(hflights), n_dest = n_distinct(Dest),
            min_dist = min(Distance), max_dist = max(Distance))

# Use summarise() to create a summary of hflights with a single variable, n, 
# that counts the number of overnight flights. These flights have an arrival 
# time that is earlier than their departure time. Only include flights that have 
# no NA values for both DepTime and ArrTime in your count.

hflights%>%mutate(overnight=(ArrTime<DepTime))%>%filter(overnight== TRUE)%>%select(overnight)%>%summarise(count=n())

# Group_By() --------------------------------------------------------------

# Generate a per-carrier summary of hflights with the following variables: n_flights, 
# the number of flights flown by the carrier; n_canc, the number of cancelled flights; 
# p_canc, the percentage of cancelled flights; avg_delay, the average arrival delay of 
# flights whose delay does not equal NA. Next, order the carriers in the summary from 
# low to high by their average arrival delay. Use percentage of flights cancelled to 
# break any ties. Which airline scores best based on these statistics?

hflights %>% 
  group_by(UniqueCarrier) %>% 
  summarise(n_flights = n(), n_canc = sum(Cancelled), p_canc = 100*n_canc/n_flights, 
            avg_delay = mean(ArrDelay, na.rm = TRUE)) %>% arrange(avg_delay)

# Generate a per-day-of-week summary of hflights with the variable avg_taxi, 
# the average total taxiing time. Pipe this summary into an arrange() call such 
# that the day with the highest avg_taxi comes first.

hflights%>%group_by(DayOfWeek)%>%summarise(avg_taxi=mean(TaxiIn+TaxiOut,na.rm=TRUE))%>%arrange(desc(avg_taxi))

  

# Combine group_by with mutate----- ---------------------------------------

# First, discard flights whose arrival delay equals NA. Next, create a by-carrier 
# summary with a single variable: p_delay, the proportion of flights which are 
# delayed at arrival. Next, create a new variable rank in the summary which is a 
# rank according to p_delay. Finally, arrange the observations by this new rank

hflights%>%filter(!is.na(ArrDelay))%>%group_by(UniqueCarrier)%>%summarise(p_delay=sum(ArrDelay>0)/n())%>%mutate(rank=rank(p_delay))%>%arrange(rank)

# n a similar fashion, keep flights that are delayed (ArrDelay > 0 and not NA). 
# Next, create a by-carrier summary with a single variable: avg, the average delay 
# of the delayed flights. Again add a new variable rank to the summary according to 
# avg. Finally, arrange by this rank variable.
hflights %>% 
  filter(!is.na(ArrDelay), ArrDelay > 0) %>% 
  group_by(UniqueCarrier) %>% 
  summarise(avg = mean(ArrDelay)) %>% 
  mutate(rank = rank(avg)) %>% 
  arrange(rank)

# Advanced Group_by() -----------------------------------------------------

# Which plane (by tail number) flew out of Houston the most times? How many times?
# Name the column with this frequency n. Assign the result to adv1. To answer this 
# question precisely, you will have to filter() as a final step to end up with only 
# a single observation in adv1.
# Which plane (by tail number) flew out of Houston the most times? How many times? adv1


hflights%>%group_by(TailNum)%>%summarise(n=n())%>%filter(n==max(n))

