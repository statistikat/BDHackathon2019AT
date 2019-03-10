# exploration MOTUS data

library(data.table)
library(MOTUSteachers18)

# Activity categorisations and labels
act_grp <- data.table(MOTUSteachers18::activity_groupings)
act_grp <- act_grp[, !grep("_NL$", names(act_grp)), with = FALSE]  # remove dutch-language columns

?activity_groupings

# Activity data
act <- data.table(MOTUSteachers18::teachers18_act)
act[, start := as.POSIXct(start)]
act[, end   := as.POSIXct(end)]


?teachers18_act

# time spent in different acitivites (minutes)
aggr <- data.table(MOTUSteachers18::teachers18_aggr)
?teachers18_aggr

# Background characteristics of the teachers in the Teachers18 project
char <- data.table(MOTUSteachers18::teachers18_char)
?teachers18_char


char

nrow(act)
ncol(act)
class(act)


head(act)





aws.s3::get_bucket("s3://eu-west-1-hackathon-data/iLog2")


# main activity
  act[where == 1, sum(duration), by = "mainact"]  # at school
  act[where == 1, sum(duration), by = "mainact"]  # at school
  act[where == 2, sum(duration), by = "mainact"]  # at home
  act[where == 3, sum(duration), by = "mainact"]  # other location
  act[where == 4, sum(duration), by = "mainact"]  # transport
  
