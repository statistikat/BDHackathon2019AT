source(usethis::proj_path("bigo/combidat.R"))
library(trelliscopejs)

meal_img_url <- function(user_id, meal_id) {
  paste0("http://52.214.106.253/img/meals/", user_id, "_", meal_id, ".jpg")
}

meals2 <- combidat %>%
  filter(!is.na(meal)) %>% 
  mutate(img = meal_img_url(pid, meal), 
         day = lubridate::wday(start_datetime, label = TRUE),
         hour = lubridate::hour(start_datetime), 
         steps_cat = as.factor(steps_cat), 
         country = iso2,
         fitness_cat = as.factor(fitness_cat)
         ) %>% 
  select(
    meal_type, day, img, hour, temperature,
    home_prepared = meal_attributes.home_prepared, sugar,
    median_fitness, median_steps, fitness_cat, steps_cat, country#,
    #id
  )

ts <- meals2 %>% mutate(img = img_panel(img)) %>%
  trelliscope(
    "Meals", ncol = 4, nrow = 2, 
    desc = "View meals filtered by several characteristics",
    path = usethis::proj_path("presentation/trell"))

