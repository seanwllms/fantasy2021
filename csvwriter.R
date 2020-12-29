#write projections files to csv

view_team <- function(team_name) {
  
  rosters_merged %>% 
    filter(team == team_name) 
}

#marmaduke
view_team("marmaduke") %>% 
  write_csv("./results/marmaduke.csv")

#pasadena
view_team("pasadena") %>% 
  write_csv("./results/pasadena.csv")


#hitter and pitcher projections
write_csv(pitcher_projections, path = "./results/pitcher_projections.csv")

hitter_projections %>% 
  select(playerid, Name, Team, position, PA, AB, R, HR, RBI, SB, AVG, marginal_total_points, dollar_value, status) %>% 
  write_csv(path = "./results/hitter_projections.csv")


#create file for best remaining players
hitterpitcher <- bind_rows(hitter_projections, pitcher_projections) %>%
      arrange(desc(dollar_value)) %>%
      select(Name, Team, position, marginal_total_points, dollar_value, status)

hitterpitcher <- filter(hitterpitcher, status != "drafted" & dollar_value > -5)

write.csv(hitterpitcher, "./results/bestremaining.csv")


#write out draft errors to csv
write.csv(drafterrors, "./results/drafterrors.csv")

#write standings output to file
standings.output <- select(standings,
                           team, spent, left, picks_left,
                           total_points, R_points, HR_points, RBI_points, 
                           SB_points, AVG_points, ERA_points, WHIP_points, K_points, SV_points, W_points)



write.csv(standings.output, file="./results/standings.csv")

