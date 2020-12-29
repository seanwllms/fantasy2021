library(shiny)
library(tidyverse)

#read in full player pool
player_pool <- bind_rows(
  #hitter projections
  read_csv("../results/hitter_projections.csv"),
  read_csv("../results/pitcher_projections.csv")
) %>% 
  mutate(across(PA:SB, round, 0),
         across(c(AVG, ERA, WHIP), round, 3),
         across(SV:K, round, 0),
         across(marginal_total_points:dollar_value, round, 1)) %>% 
  rename(Points = marginal_total_points, Dollars = dollar_value)


ALL_POSITIONS <- c("C", "1B", "2B", "SS", "3B", "CI", "MI", "OF", "DH")