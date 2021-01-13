library(shiny)
library(tidyverse)

ALL_POSITIONS <- c("Catcher", "1B", "2B", "SS", "3B", "CI", "MI", "OF", "DH")

#list of teams
TEAMS <- c("marmaduke",
           "pkdodgers",
           "ottawa",
           "isotopes",
           "perpetual",
           "dsb",
           "lacugna",
           "deano",
           "dembums",
           "bellevegas",
           "chicago",
           "balco",
           "sturgeon",
           "rippe",
           "pasadena",
           "deener",
           "ds9",
           "bears")

#read in full player pool
player_pool <- bind_rows(
  #hitter projections
  read_csv("hitter_projections.csv"),
  read_csv("pitcher_projections.csv")
) %>% 
  arrange(-dollar_value) %>% 
  mutate(across(PA:SB, ~as.character(round(.x, 0))),
         across(c(AVG, ERA, WHIP), ~as.character(round(.x, 3))),
         across(c(IP,SV:K), ~as.character(round(.x, 0))),
         across(marginal_total_points:dollar_value, ~as.character(round(.x, 1))),
         status = ifelse(is.na(status), "", status)) %>% 
  rename(Points = marginal_total_points, Dollars = dollar_value) 
  

#read in standings
standings <- read_csv("standings.csv") %>% 
  select(-X1) %>% 
  mutate(across(spent:picks_left, ~as.character(round(.x,0))),
         across(total_points:W_points, ~as.character(round(.x,1)))) %>% 
  rename_with(~str_remove(.x,"_points"), contains("_points")) %>% 
  rename(Points = total)


#read in rosters
rosters <- read_csv("rosters.csv") %>% 
  mutate(across(AB:SB, ~as.character(round(.x, 0))),
         across(c(AVG, ERA, WHIP), ~as.character(round(.x, 3))),
         across(c(salary,IP,SV:K), ~as.character(round(.x, 0))),
         across(marginal_total_points:dollar_value, ~as.character(round(.x, 1))),
         across(AB:dollar_value, ~ifelse(is.na(.x), "", .x))) 
