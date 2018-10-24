require(lubridate)

now() # current Time


update(now(),year=2015,month=5) # Modify dates

# ADD TIME DATE DAY YEAR 
now()+ddays(2)
now()+dyears(2)
now()+dminutes(45)
now()+dweeks(4)
now()+dhours(4)
now()+dseconds(47852)

# EXtract data

date(now())
minute(now())

year(now())
second(now())
