##############################################
####### Aula CE2 - Prof. Thais #######
##############################################

library(tidyverse)
library(nycflights13)
library(hms)
library(lubridate)


## Pacote hms
View(flights)

hms::hms(10,00,11)
hms::hms(hours=11, minutes = 00, seconds=10)

x <- hms::hms(10,51,10)
x
class(x)
?hms::hms


## Pacote lubridate
ymd("2012/01/11")
ymd("2012,01,11")
ymd("2012-01-11")
ymd("2012, JAN / 11")
dmy("11, jan, 2012")


###################
## Pacote hms #####
###################
?hms::hms
?lubridate::hms
hms::hms(56,34,12)

hms::hms(seconds= 56, minutes = 34, hours= 12)
hms(hours=12, minutes=34, seconds=56)


########################
## Pacote lubridate ####
########################
x <- "January, 11, 2010"
class(x)
year(x)

y <- mdy("Apr, 14, 2026")
class(y)
week(y)
y
unclass(y)
year(y)
month(y)
day(y)
wday(y, label=T, abbr=T)
wday(y)
mday(y)
day(y)
yday(y)
qday(y) # quarter day 

y <- mdy("Nov, 11, 2010")
y
year(y) <- 2011
qday(y)
week(y)
yday(y)

mdy("01, 11, 2010")
mdy("01/11/2010")
mdy("January, 11th, 2010")
mdy("January-11th-2010")

## Exemplo do slide
flights %>%
  mutate(weekday = wday(time_hour, label = TRUE, abbr = FALSE)) %>%
  group_by(weekday) %>%
  filter(!is.na(arr_delay)) %>%
  summarise(avg_delay = mean(arr_delay)) %>%
  ggplot() +
  geom_col(mapping = aes(x = weekday, y = avg_delay))


# Exercício:
# Use the appropriate lubridate function to parse each of the following dates:
d1 <- "January 1, 2010"
d2 <- "2015-Mar-07"
d3 <- "06-Jun-2017"
d4 <- c("August 19 (2015)", "July 1 (2015)")
d5 <- "12/30/14" # Dec 30, 2014

## Opção alternativa: Função make_date ou make_datetime
View(flights)
flights2 <- flights %>% 
  select(year, month, day, hour, minute) %>% 
  mutate(departure = make_datetime(year, month, day, hour, minute))
View(flights2)


# Modify the variables dep_time, arr_time, sched_dep_time and sched_arr_time to include Date + Time.
flights_dt <- flights %>% 
  filter(!is.na(dep_time), !is.na(arr_time)) %>% 
  mutate(
    dep_time = make_datetime(year, month, day, dep_time %/% 100, dep_time %% 100),
    arr_time = make_datetime(year, month, day, arr_time %/% 100, arr_time %% 100),
    sched_dep_time = make_datetime(year, month, day, sched_dep_time %/% 100, sched_dep_time %% 100),
    sched_arr_time = make_datetime(year, month, day, sched_arr_time %/% 100, sched_arr_time %% 100)
  ) %>% 
  select(origin, dest, ends_with("delay"), ends_with("time"))


## Rounding dates
today()
now()
floor_date(flights2$departure, "week")
round_date
ceiling_date

x <- now()
Sys.timezone()

head(OlsonNames())
length(OlsonNames())
x
round_date(x, "minute")
ceiling_date(x, "minute")
floor_date(x, "minute")

round_date(x, "hour")
floor_date(x, "hour")

round_date(x, "month")
floor_date(x, "month")
ceiling_date(x, "month")


flights2 %>% 
  count(week = floor_date(departure, "week")) %>% 
  ggplot(aes(week, n)) +
  geom_line()


## Math with instants
today() + 15
now() + 15
wday(today() + 15, label=T)

?period
today() + days(15)
now() + days(15)
now() + hours(8)
now() + hours(100)
now() + days(1500)

am(now())
pm(now())


## How old are you?
age = today() - ymd("2019/01/25")
as.duration(age)


## Maths
flights %>% 
  filter(arr_time < dep_time)

## Fixing
flights <- flights %>% 
  mutate(
    overnight = arr_time < dep_time,
    arr_time = arr_time + days(overnight * 1),
    sched_arr_time = sched_arr_time + days(overnight * 1)
  )

flights %>% 
  filter(arr_time < dep_time)



  
