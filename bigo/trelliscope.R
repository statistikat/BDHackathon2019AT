library(trelliscopejs)
source(usethis::proj_path("bigo/bigo_import.R"))

meal_img_url <- function(user_id = 840, meal_id = 0) {
  paste0("http://ip-10-0-1-192.eu-west-1.compute.internal:8888/",
         "filebrowser/download=/dataset/bigO/self_reports/",
         user_id, "/meals/", meal_id, ".jpg")
}

meals %>% mutate(id = 1:nrow(meals), img = meal_img_url(pid, meal)) %>%  
  mutate(img = img_panel(img)) %>% 
  trelliscope("bla", ncol = 4, nrow = 2)


