source(usethis::proj_path("bigo/combidat.R"))
library(trelliscopejs)

meal_img_url <- function(user_id, meal_id) {
  paste0("http://52.214.106.253/img/meals/", user_id, "_", meal_id, ".jpg")
}

combidat[is.na(fitness_cat), fitness_cat := "999"]
combidat[!is.na(meal_attributes.home_prepared), home_prepared := meal_attributes.home_prepared]
combidat[!is.na(snack_attributes.home_prepared), home_prepared := snack_attributes.home_prepared]
combidat[is.na(home_prepared), home_prepared := "unknown"]
combidat[home_prepared == "TRUE", home_prepared := "yes"]
combidat[home_prepared == "FALSE", home_prepared := "no"]

combidat[!is.na(meal_attributes.fruit), fruit := meal_attributes.fruit]
combidat[!is.na(snack_attributes.fruit), fruit := snack_attributes.fruit]
combidat[is.na(fruit), fruit := "unknown"]
combidat[fruit == "TRUE", fruit := "yes"]
combidat[fruit == "FALSE", fruit := "no"]

combidat[iso2 == "GB", iso2 := "UK"]
combidat[iso2 == "GR", iso2 := "EL"]
combidat[iso2 == "-99", iso2 := NA]

combidat[, country := countrycode::countrycode(
  iso2, "eurostat", "country.name")]

combidat[is.na(country), country := "unknown"]
combidat[is.na(temperature), temperature := "unknown"]

meals2 <- combidat %>%
  filter(!is.na(meal)) %>% 
  mutate(img = meal_img_url(pid, meal), 
         day = lubridate::wday(start_datetime, label = TRUE),
         hour = lubridate::hour(start_datetime), 
         steps_cat = as.factor(steps_cat), 
         country = country,
         sugar2 = ifelse(sugar, "yes", "no"),
         fitness = factor(
           fitness_cat, 
           labels = c("easy-going", "average", "fit", "unknown"))
  ) %>% 
  select(
    `meal type` = meal_type, day, img, hour, temperature,
    `home prepared` = home_prepared, sugar = sugar2,
    steps = median_steps, fitness, country, fruit
  )

ts <- meals2 %>% mutate(img = img_panel(img)) %>%
  trelliscope(
    "Meals", ncol = 4, nrow = 2, 
    desc = "View meals filtered by several characteristics",
    path = usethis::proj_path("presentation/trell"))

ts
