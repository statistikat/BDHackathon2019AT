install.packages("geofacet")
# or from github:
# devtools::install_github("hafen/geofacet")

library(geofacet)
library(ggplot2)
library(reshape2)
require(data.table)
library(ggmosaic)
library(dplyr)

combidat <- readRDS("~/BDHackathon2019AT/bigo/combidat.rds")

fit <- combidat[!is.na(median_fitness) & !is.na(iso2), list(pid,median_fitness,median_steps,fitness_cat,steps_cat,iso2,meal_type,temperature)]
fit <- fit[!iso2%in%-99,]
fit <- fit[!duplicated(pid),]
fit[iso2=="GB" ,iso2:="UK"]
fit[iso2=="GR" ,iso2:="EL"]
fit[, fitness:=fitness_cat]
fit[fitness_cat=="0", fitness:="easygoing"]
fit[fitness_cat=="1", fitness:="average"]
fit[fitness_cat=="2", fitness:="fit"]
fit[,fitness:=ordered(fitness, levels= c("easygoing","average","fit"))]

pdf("~/BDHackathon2019AT/bigo/geofacetplots/fitness_cat_country.pdf")
ggplot(fit, aes(x=fitness, fill=fitness)) +
  geom_bar() +
  #coord_flip() +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
  facet_geo(~ iso2, grid="eu_grid1")
dev.off()


fitmeal <- combidat[!is.na(median_fitness) & !is.na(iso2), list(pid,median_fitness,median_steps,fitness_cat,steps_cat,iso2,meal_type,temperature)]
fitmeal <- fitmeal[!iso2%in%-99,]
fitmeal[iso2=="GB" , iso2:="UK"]
fitmeal[iso2=="GR" , iso2:="EL"]
fitmeal <- fitmeal[meal_type != "drink", ]
fitmeal <- fitmeal[!is.na(temperature), ]
fitmeal <- fitmeal[temperature != "mixed",]
pdf("~/BDHackathon2019AT/bigo/geofacetplots/meal_temperature_country.pdf")
ggplot(fitmeal) +
  geom_mosaic(aes(x = product(temperature), fill = meal_type)) +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank()) +
  facet_geo(~ iso2, grid="eu_grid1")
dev.off()
