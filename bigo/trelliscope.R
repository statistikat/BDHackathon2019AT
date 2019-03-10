source(usethis::proj_path("bigo/bigo_import.R"))
library(trelliscopejs)

meal_img_url <- function(user_id, meal_id) {
  paste0("http://52.214.106.253/img/meals/", user_id, "_", meal_id, ".jpg")
}

meals2 <- merge(
  tables_c[, list(activity = sum(foot+bike, na.rm = TRUE)), by = pid],
  meals_json
) 

meals2 <- meals2 %>% 
  mutate(id = 1:nrow(meals2), img = meal_img_url(pid, meal), 
         day = lubridate::wday(start_datetime, label = TRUE),
         hour = lubridate::hour(start_datetime)) %>% select(
           meal_type, day, img, hour, temperature,
           home_prepared = meal_attributes.home_prepared, sugar
         )

ts <- meals2 %>% mutate(img = img_panel(img)) %>%
  trelliscope(
    "Meals", ncol = 4, nrow = 2, 
    desc = "View meals filtered by several characteristics",
    path = usethis::proj_path("presentation/trell"))

