library(dplyr)
library(magrittr)
library(knitr)

df <- read.csv("response.csv", sep=";")

df$Team <- as.factor(df$Team)
df$Round <- as.factor(df$Round)
df$Point <- scan(text=df$Point, dec=",", sep=".")
df$Point <- as.double(df$Point)

teams <- as.character(unique(df$Team))

rounds <- c("Pop culture round", "Department of Linguistics round",
            "Food and Language round", "Anthe and Thomas' Triple T(h)reats",
            "Music round", "Common thread round", "Not The Onion round",
            "Earlier, later, or same day round", "durante_Faculty of Arts",
            "durante_Ling 101 round")


double <- read.csv("double.csv", sep=";")
double$Round <- lapply(double$Double, function(index) {
  rounds[index]
})
double$Doubled <- apply(double, 1, function(row) {
  df %>%
    filter(Team == row[["Team"]] & Round == row[["Round"]]) %>% 
    summarise(Point = sum(Point)) %>% 
    as.double()
})
                      
scoreboard <- df %>%
  group_by(Team) %>% 
  summarise(Point = sum(Point)) %>% 
  as.data.frame()

scoreboard <- left_join(scoreboard, double)
scoreboard$Points <- scoreboard$Point + scoreboard$Doubled
scoreboard <- subset(scoreboard, select = c(Team, Points))

scoreboard <- scoreboard[order(-scoreboard$Points, desc(scoreboard$Team)),]
row.names(scoreboard) <- 1:nrow(scoreboard) %>% as.double()

personal_top <- function(team) {
  top <- df %>%
    filter(Team == team) %>%
    group_by(Round) %>% 
    summarise(Points = sum(Point)) %>% 
    as.data.frame()
  
  top$Round <- gsub("durante_", "", top$Round)
  top <- top[order(-top$Points),]
  
  row.names(top) <- 1:nrow(top) %>% as.double()
  
  return(top)
}
