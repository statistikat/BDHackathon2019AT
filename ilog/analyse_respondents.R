library(jsonlite)
library(data.table)
library(hms)


infiles <- list.files("/mnt/s3/ilog/resp", full.names = TRUE)



get_activities <- function(.x){

  a <- rbindlist(lapply(.x$answer, get_activity))
  a[, ts_notif  := lubridate::ymd_hms(strtrim(.x$notificationtimestamp, 14))]
  a[, ts_answer := lubridate::ymd_hms(strtrim(.x$answertimestamp, 14))]
  a
}

get_activity <- function(.x) {

  dd <- fromJSON(.x)
  
  if (is.data.frame(dd)){
    res <- as.data.table(dd)
  } else if (length(dd)){
    res <- data.table::rbindlist(dd)
  }
  
  type <- res[qid == 1]$cnt
  mot <- res[qid == 3]$cnt
  
  if (!length(mot)) mot <- NA_character_
  
  data.table(
    type = type,
    mot = mot
  )
}




res <- lapply(infiles, function(.x){
  cat(basename(.x), "\n")
  
  dd <- try(readRDS(.x))
  
  if (inherits(dd, "try-error"))  return(NULL)
  
  answer_names <- c("instanceid", "answer", "answerduration", "answertimestamp", 
                    "day", "delta", "instancetimestamp", "notificationtimestamp", 
                    "payload")
  
  sel <- vapply(lapply(dd, names), identical, logical(1),  answer_names) & vapply(dd, function(.x) nrow(.x) > 0, logical(1))
  
  
  res <- lapply(dd[sel], get_activities)
  
  if (length(res) == 1){
    res <- res[[1]]
  } else {
    res <- rbindlist(res)
  }
  
  if (length(res)){
    res[, respondent := strtrim(tools::file_path_sans_ext(basename(.x)), 4)]
  }
  
  res
  

} )


res <- purrr::compact(res)

act <- data.table::rbindlist(res, fill = TRUE)

act[, type := gsub("\\d* - ", "", type)]
act[, mot := gsub("\\d* - ", "", mot)]

table(act$type)
table(act$mot)


saveRDS(act, "activities.rds")
saveRDS(act, "/mnt/s3/ilog/activities.rds")


act[, sporty_type := grepl("sport", type, ignore.case = TRUE)]
act[, sporty_mot  := grepl("(foot)|(bicycle)", type, ignore.case = TRUE)]

act[, time := as.hms(ts_notif)]
act

ppl <- act[, .(
  sports = sum(sporty_type | sporty_mot), 
  answers = sum(type != "Expired"),
  days = difftime(max(ts_answer), min(ts_notif), unit = "days")
), 
  by = "respondent"
]

ppl[, fitness := sports/as.numeric(days)]
ppl[, rigor   := answers/as.numeric(days)]

ppl[, fitlvl := dplyr::case_when(
  fitness == 0 ~ 0,
  fitness <  0.5 ~ 1,
  TRUE ~ 2
)]


ppl[rigor > 12 & days >= 1]

act[respondent %in% ppl[fitlvl == 2]$respondent, table(type)]

act[respondent %in% ppl[fitlvl == 1]$respondent, table(type)]
act[respondent %in% ppl[fitlvl == 0]$respondent, table(type)]

table(act[time >= hms(0, 0, 22) | time <= hms(0, 0, 6)]$type)


