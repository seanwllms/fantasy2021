library(tidyverse)
library(ggplot)


#read fangraphs data
adp_data_hitters <- read_csv("./adp_analysis/hitteradp.csv") %>% 
  rename(playername = 1) %>% 
  select(playername, ADP, Dollars)

adp_data_pitchers <- read_csv("./adp_analysis/pitcheradp.csv") %>% 
  rename(playername = 1) %>% 
  select(playername, ADP, Dollars)


adp_data_all <- bind_rows(adp_data_hitters, adp_data_pitchers)

#sean values
hitters_sean <- read_csv("./results/hitter_projections.csv") %>% 
  select(Name, playerid, dollar_value, status)

pitchers_sean <- read_csv("./results/pitcher_projections.csv") %>% 
  select(Name, playerid, dollar_value, status) 

sean_dollar_values <- bind_rows(hitters_sean, pitchers_sean)


#merge fangraphs adp with sean dollar values
adp_analysis <- left_join(sean_dollar_values, adp_data_all, by = c("Name"="playername")) %>% 
  distinct() 

nfbc_crosswalk <- readxl::read_xlsx("./nfbc/nfbc_crosswalk.xlsx")

#create model to predict ADP from dollar_value
adp_model_data <- adp_analysis %>% 
  filter(ADP < 599 & dollar_value > -2) %>% 
  mutate(ADP2 = ADP^2,
         status = ifelse(is.na(status), "", status)) %>% 
  filter(Name != "Adalberto Mondesi") %>% 
  arrange(-dollar_value)


#plot adp vs. sean dollar values
adp_scatter <- adp_model_data %>% 
  ggplot(aes(x=dollar_value, y = ADP)) +
  geom_point() +
  geom_smooth()
adp_scatter


exponential_model <- loess(ADP ~ dollar_value, data=adp_model_data, span =.99)
smoothed <- predict(exponential_model)

plot(adp_model_data$ADP, 
     x=adp_model_data$dollar_value, 
     type="p", 
     main="Predicted ADP vs. Actual ADP", 
     xlab="Sean Estimated Dollar Value", 
     ylab="ADP")

lines(x = adp_model_data$dollar_value, y=smoothed)


#identify remaining values
sean_value_targets <- bind_cols(adp_model_data, model_adp=smoothed) %>% 
  mutate(value_targets = ADP - model_adp, dollar_value = round(dollar_value, 1)) %>% 
  filter(!(status=="drafted") & dollar_value > 8 & value_targets > 0) %>% 
  arrange(-value_targets) %>% 
  select(Name, dollar_value, ADP, model_adp)

write_csv(sean_value_targets, path="./results/sean_targets.csv")
file.copy("./results/sean_targets.csv", "./shiny_fantasy/sean_targets.csv", overwrite=TRUE)
