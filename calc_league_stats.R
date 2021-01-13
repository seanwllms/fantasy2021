#get total dollars left
total_dollars_spent <- sum(draftpicks$salary)

total_dollars_remaining <- 270*18 - total_dollars_spent

total_value_remaining_hitters <- filter(hitter_projections, status != "drafted" & dollar_value >= 1) 
total_value_remaining_pitchers <- filter(pitcher_projections, status != "drafted" & dollar_value >= 1) 
total_value_remaining_hitters
total_value_remaining_pitchers
total_value_remaining <- sum(total_value_remaining_hitters$dollar_value - 1) + sum(total_value_remaining_pitchers$dollar_value - 1)
total_value_remaining

#get equity of picks so far
total_value_drafted_hitters <- draftpicks %>% 
  filter(!position=="P" & !position=="B") %>% 
  left_join(hitter_projections, by = c("player" ="Name")) %>% 
  mutate(dollar_value = ifelse(is.na(dollar_value), 0, dollar_value),
         equity = dollar_value-salary)

total_value_drafted_pitchers <- draftpicks %>% 
  filter(position=="P") %>% 
  left_join(pitcher_projections, by = c("player" ="Name")) %>% 
  mutate(dollar_value = ifelse(is.na(dollar_value), 0, dollar_value),
         equity = dollar_value-salary)

total_value_drafted_bench_pitch <- draftpicks %>% 
  filter(position=="B") %>% 
  left_join(pitcher_projections, by = c("player" ="Name")) %>% 
  mutate(dollar_value = ifelse(is.na(dollar_value), 0, dollar_value),
         equity = dollar_value-salary)

total_value_drafted_bench_hit <- draftpicks %>% 
  filter(position=="B") %>% 
  left_join(hitter_projections, by = c("player" ="Name")) %>% 
  mutate(dollar_value = ifelse(is.na(dollar_value), 0, dollar_value),
         equity = dollar_value-salary)

hitter_equity <- sum(total_value_drafted_hitters$equity) + sum(total_value_drafted_bench_hit$equity)
pitcher_equity <- sum(total_value_drafted_pitchers$equity) + sum(total_value_drafted_bench_pitch$equity)

hitter_equity
pitcher_equity

#estimate total marginal points in player pool
total_marginal_points_hit <- filter(hitter_projections, dollar_value >= 1) %>% 
  pull(marginal_total_points) %>% 
  sum()
total_marginal_points_hit

total_marginal_points_pitch <- filter(pitcher_projections, dollar_value >= 1) %>% 
  pull(marginal_total_points) %>% 
  sum()

total_marginal_points_pitch
  
total_marginal_points <- total_marginal_points_hit + total_marginal_points_pitch
total_marginal_points