library(data.table)
library(lubridate)
#rm(list=ls())
source(usethis::proj_path("bigo/bigo_import.R"))

tables_a[ ,month:=month(utc_timestamp)]
tables_a[ ,day:=day(utc_timestamp)]
tables_a[ ,month_day:=paste0(month,"_",day)]
tables_a[ ,ntimestamp_byDay:=.N, by=c("pid","month_day")]
tables_a[ ,fitness := rowSums(.SD) , .SDcols=c("biking","jogging","walking")]
tables_a[ ,fitness_byDay:=sum(fitness), by=c("pid","month_day")]
tables_a[ ,fitness_byDay_min:=fitness_byDay/60]
tables_a[ ,fitness_byDay_min_rounded:=round(fitness_byDay_min)]
tables_a[ ,steps_byDay:=sum(steps), by=c("pid","month_day")]

# simple Version, nicht auf Tageszeiten eingehen sondern nur auf Anzahl der Time Stamps pro Tag
sub_a <- subset(tables_a, ntimestamp_byDay>=40)
table(sub_a$fitness_byDay_min_rounded)

sub2_a <- sub_a[,sel:=!duplicated(month_day), by=c("pid")]
sub2_a <- subset(sub2_a, sel)
sub2_a[ ,median_fitness:=median(fitness_byDay_min_rounded), by=c("pid")]
sub2_a[ ,median_steps:=median(steps_byDay), by=c("pid")]

fitness <- sub2_a[!duplicated(pid),list(pid,median_fitness,median_steps,ntimestamp_byDay)]
fitness[ ,table(median_fitness)]
fitness[ ,table(median_steps)]

# median fitness per pid over all days with ntimestamp_byDay>=40 
fitness[median_fitness<30 ,fitness_cat:=0]
fitness[median_fitness>=30 & median_fitness<60 ,fitness_cat:=1]
fitness[median_fitness>=60 ,fitness_cat:=2]
# median nr of steps per pid over all days with ntimestamp_byDay>=40 
fitness[median_steps<2000,steps_cat:=0]
fitness[median_steps>=2000 & median_steps<5000 ,steps_cat:=1]
fitness[median_steps>=5000,steps_cat:=2]

# Eigentlich: Active: 10,000 steps per day indicates the point that should be used to classify individuals as active. 
# Aber in den Daten sind nur faule Saecke:
# > max(fitness$median_steps)
# [1] 9544

# saveRDS(fitness, "/mnt/s3/fitness.rds")
