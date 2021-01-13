#vector of hitter replacement values
replacement_hitter <- read_xlsx("./replacement/replacement_hitters.xlsx", sheet = "positionless_replacement") %>% 
  filter(Player == "Adjusted Average") %>% 
  select(R, HR, RBI, SB, AVG) 

replacement_hitter$AB <- c(400)

#create replacement pitcher values
#these are the mean projections for the 170th through 190th best players
replacement_pitcher <- readxl::read_xlsx("./replacement/replacement_pitchers.xlsx") %>% 
  filter(Name == "Adjusted Average") %>% 
  select(W:WHIP) 

#hard code more reasonable pitcher numbers
replacement_pitcher$ERA <- 5.1
replacement_pitcher$WHIP <- 1.43
replacement_pitcher$SV <- 0
replacement_pitcher$W <- 4.68
replacement_pitcher$K <- 93.5

#hard code more reasonable hitter numbers
replacement_hitter$R <- 53.5
replacement_hitter$HR <- 13.7
replacement_hitter$RBI <- 54
replacement_hitter$AVG <- .2255
replacement_hitter$SB <- 4.75