# exploration MOTUS data

library(data.table)
library(MOTUSteachers18)

# Activity categorisations and labels
act_grp <- data.table(MOTUSteachers18::activity_groupings)
?activity_groupings

# Activity data
act <- data.table(MOTUSteachers18::teachers18_act)
?teachers18_act

# time spent in different acitivites (minutes)
aggr <- data.table(MOTUSteachers18::teachers18_aggr)
?teachers18_aggr

# Background characteristics of the teachers in the Teachers18 project
char <- data.table(MOTUSteachers18::teachers18_char)
?teachers18_char
