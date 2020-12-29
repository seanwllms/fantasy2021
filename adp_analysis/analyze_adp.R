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
  select(Name, dollar_value, status)

pitchers_sean <- read_csv("./results/pitcher_projections.csv") %>% 
  select(Name, dollar_value, status) 

sean_values <- bind_rows(hitters_sean, pitchers_sean)


#merge fangraphs adp with sean dollar values
adp_analysis <- left_join(sean_values, adp_data_all, by = c("Name"="playername")) %>% 
  filter(ADP < 599) %>% 
  mutate(ADP2 = ADP^2,
         status = ifelse(is.na(status), "", status))


#plot adp vs. sean dollar values
adp_scatter <- adp_analysis %>% 
  ggplot(aes(x=ADP, y = dollar_value)) +
  geom_point()
adp_scatter

#adp regression
sean_vs_adp <- lm(dollar_value ~ ADP + ADP2, data = adp_analysis) 



#identify remaining values
sean_values <- bind_cols(adp_analysis, reg_estimate=sean_vs_adp$fitted.values) %>% 
  mutate(sean_value = dollar_value - reg_estimate) %>% 
  filter(!(status=="drafted")) %>% 
  arrange(-sean_value)
