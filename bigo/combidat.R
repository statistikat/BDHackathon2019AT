#fitness <- readRDS("/mnt/s3/fitness.rds")

source(usethis::proj_path("bigo/fitness.R"))
meals_coords_countries <- readRDS("/mnt/s3/meals_coords_countries.rds")
setDT(meals_coords_countries)
meals_coords_countries[ ,X:=as.character(X)]
meals_coords_countries[ ,Y:=as.character(Y)]
meals_coords_countries <- meals_coords_countries[!duplicated(geometry),]

combidat <- merge(meals_coords_countries[,list(iso2, X, Y)], meals_json, 
                  by.x=c("X","Y"), 
                  by.y = c("location.coordinates1","location.coordinates2"),all.y=TRUE, all.x=FALSE)
combidat <- combidat[order(pid,meal,iso2),]
#combidat[,list(pid,X,Y,meal, iso2)]
combidat <- merge(fitness, combidat, by="pid", all.y=TRUE, all.x=TRUE)

