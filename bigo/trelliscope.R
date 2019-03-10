source(usethis::proj_path("bigo/bigo_import.R"))
library(trelliscopejs)

meal_img_url <- function(user_id = 840, meal_id = 0) {
  paste0("http://ip-10-0-1-192.eu-west-1.compute.internal:8888/",
         "filebrowser/download=/dataset/bigO/self_reports/",
         user_id, "/meals/", meal_id, ".jpg")
}

meals_json[!is.na(meal_attributes.sugar), sugar := meal_attributes.sugar]
meals_json[!is.na(snack_attributes.sugar), sugar := snack_attributes.sugar]
meals_json[!is.na(drink_attributes.sugar), sugar := drink_attributes.sugar]
meals_json[!is.na(snack_attributes.food_temperature), temperature := snack_attributes.food_temperature]
meals_json[!is.na(meal_attributes.food_temperature), temperature := meal_attributes.food_temperature]


meals2 <- merge(
  tables_c[, list(activity = sum(foot+bike, na.rm = TRUE)), by = pid],
  meals_json
) %>% mutate(id = 1:nrow(meals2), img = meal_img_url(pid, meal), 
             day = lubridate::wday(start_datetime, label = TRUE),
             hour = lubridate::hour(start_datetime)) %>% select(
  meal_type, day, img, hour, temperature,
  home_prepared = meal_attributes.home_prepared, sugar
)

meals2 %>% mutate(img = img_panel(img)) %>%
  trelliscope("Meals", ncol = 4, nrow = 2, 
              desc = "View meals filtered by several characteristics")

lubridate::dmy_hms(tables_a$utc_timestamp)
