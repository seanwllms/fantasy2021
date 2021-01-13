
# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  #########################################################
  ############## logic for conditional UI elements ########
  #########################################################
  
  output$playerselect <- reactive({
    if (input$top_tabs == "Player Pool") {
      TRUE
    } else { FALSE }
  })
  
  output$rosters <- reactive({
    if (input$top_tabs == "Rosters") {
      TRUE
    } else { FALSE }
  })
  
  
  
  outputOptions(output, "playerselect", suspendWhenHidden = FALSE)  
  
  

  #full playerpool for testing
  output$playerpooltest <- renderTable({player_pool})
  
  #player pool dynamic table
  output$players <- renderTable({
    
    #build output table for pitchers
    if (input$selected_pos == "Pitchers") {
      
      output_table <- player_pool %>% 
        filter(position == "pitcher") %>% 
        select(Name, Team, status, IP:K, Points, Dollars)
        
    
    #build output table for hitters
    } else {
      if (input$selected_pos == "Hitters") {
        filtered_pool <- filter(player_pool, position != "pitcher")
      } else if (input$selected_pos == "MI") {
        filtered_pool <- filter(player_pool, position %in% c("2b", "ss"))
      } else if (input$selected_pos == "CI") {
        filtered_pool <- filter(player_pool, position %in% c("1b", "3b"))
      }  else {
        filtered_pool <- filter(player_pool, str_detect(position, tolower(input$selected_pos)))
      }
      
      output_table <- select(filtered_pool, Name, Team, position, status, PA:AVG, Points, Dollars)
    }
    
    if (input$playersearch != "") {
      output_table <- output_table %>% 
        mutate(lowercasename = tolower(Name)) %>% 
        filter(str_detect(lowercasename, tolower(input$playersearch))) %>% 
        select(-lowercasename)
    }
    
    #filter out drafted players
    if (input$drafted == TRUE) {
      output_table
    } else {
      output_table %>%  filter(status != "drafted")
    }

  })
  
  #standings table
  output$standings <- renderTable({standings})
  
  #roster table
  output$rostertable <- renderTable({
    rosters %>% 
      filter(team == input$teamselect) %>% 
      select(-team)
  })
}



