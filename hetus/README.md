
HETUS 2010
==========

HETUS (Harmonised European Time Use Survey) wave 2010 used three main survey instruments to collect time use data in the participating countries:

1.  A household questionnaire asking for context information concerning the whole household of the selected respondent;
2.  An individual questionnaire asking for context information concerning the person(s) belonging to the household individually;
3.  A time use diary asking individual persons about the activities and some context related information (where, with whom) during the 144 10-minutes time slots of the diary day.

Identifying variables
---------------------

-   HID (household id)
-   PID (personal ID)
-   COUNTRY

For example, the number of respondents per country can be obtained as follows

``` r
library(dplyr)
hetus <- readRDS("/mnt/s3/hetus.rds")
hetus %>% filter(!duplicated(COUNTRY, HID, PID)) %>% table()
```

Activities
----------

The main activities are accessible via the columns `Mact001`, `Mact002`, ..., `Mact144`. Each column corresponds to a 10 minute time slot within a day (10 min x 144 = 24 hrs).

``` r
main_activities <- hetus %>% select(Mact1:Mact144)
main_activities[1:10, 1:10]

second_activities <- hetus %>% select(Sactn1:Sactn144)
second_activities
```

A Codebook for the activities can be found here: ??
