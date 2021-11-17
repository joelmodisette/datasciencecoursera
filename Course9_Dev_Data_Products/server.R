#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# source("global.R")
library(stringr)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        
     nodes <- reactive({
             
        targetAPT <- input$targetAPT  
        
        # now just find the techniques related to the target APT
        
        APT_to_tech_target <- APT_to_tech_all %>% filter(`source name` == targetAPT)
        
        # find the techniques related to tactics for the target APT
        
        tech_2_tac_target <- tech_2_tac_all %>% filter(ID %in% APT_to_tech_target$`target ID`)
        
        # Build only the target nodes needed for graph
        
        nodes <- nodes_all %>% filter(name %in% targetAPT | 
                                        name %in% APT_to_tech_target$`target ID` |
                                        name %in% tech_2_tac_target$tactics) 
        
        nodes <- data.frame(node = c(0:(nrow(nodes)-1)), name = nodes)
        
        as.data.frame(nodes)
     
     })

     links <- reactive({
     
        # Now using the target nodes, build just the target links
        # Start with links from targeted APT to techniques.
        
        targetAPT <- input$targetAPT  
        
        # now just find the techniques related to the target APT
        
        APT_to_tech_target <- APT_to_tech_all %>% filter(`source name` == targetAPT)
        
        # find the techniques related to tactics for the target APT
        
        tech_2_tac_target <- tech_2_tac_all %>% filter(ID %in% APT_to_tech_target$`target ID`)
        
        nodes <- nodes()
        
        links_target_APT <- left_join(APT_to_tech_target, nodes, by = c("source name" = "name")) %>% 
          rename("source" = node)
        
        links_target_APT <- left_join(links_target_APT, nodes, by = c("target ID" = "name")) %>% 
          rename("target" = node)
        
        links_target_APT$value <- 1
        
        links_target_APT <- links_target_APT %>% select(source, target, value)
        
        # Build links from targeted techniques to tactics
        
        
        links_tech_tac <- left_join(tech_2_tac_target, nodes, by = c("ID" = "name")) %>% 
          rename("source" = node)
        
        links_tech_tac <- left_join(links_tech_tac, nodes, by = c("tactics" = "name")) %>% 
          rename("target" = node)
        
        links_tech_tac$value <- 1
        
        links_tech_tac <- links_tech_tac %>% select(source, target, value)
        
        links <- links_target_APT
        links <- links %>% add_row(links_tech_tac)
        
        links <- links %>% select(source, target, value)
        as.data.frame(links)
     })
     
     table <- reactive({
             
             nodes <- nodes() %>% select(name)

             nodes1 <- inner_join(enterprise_attack_v10_0_groups, nodes, by = c("name" = "name")) %>%
                select(name, description)

             nodes2 <- inner_join(enterprise_attack_v10_0_techniques, nodes, by = c("ID" = "name"))
             nodes2$description <- str_c("Technique: ", nodes2$name, ' --> ', nodes2$description)  
             nodes2 <- nodes2 %>%
                select(ID, description) %>%
                rename(name = ID)

             nodes3 <- inner_join(enterprise_attack_v10_0_tactics, nodes, by = c("name" = "name")) %>%
                select(name, description)
             nodes3$description <- str_c("Tactic/Kill Chain: ", nodes3$description)

             tablebuild <- nodes1  %>%  add_row(nodes2)  %>% add_row(nodes3)
             tablebuild
                     
             })
     
     output$plot <- renderSankeyNetwork({
     # Make the Network
          sankeyNetwork(Links = links(), 
                        Nodes = nodes(), 
                        Source = 'source',  
                        Target = 'target',  
                        Value = 'value',  
                        NodeID = 'name',
                        fontSize = 14,
                        nodeWidth = 50) 
                        })
     output$table <- renderDataTable({
             table()
             
     }) 
})

