
## load libraries
library(shiny)
library(dplyr)
library(networkD3)
library(tidyr)
library(readxl)
  
 
gps_url <- "https://attack.mitre.org/docs/enterprise-attack-v10.1/enterprise-attack-v10.1-groups.xlsx"
gps_filename <- "enterprise-attack-v10.1-groups.xlsx"
download.file(gps_url, destfile = gps_filename, mode = "wb")
enterprise_attack_v10_0_groups <- read_excel(gps_filename)

tech_url <- "https://attack.mitre.org/docs/enterprise-attack-v10.1/enterprise-attack-v10.1-techniques.xlsx"
tech_filename <-"enterprise-attack-v10.1-techniques.xlsx" 
download.file(tech_url, destfile = tech_filename, mode = "wb")
enterprise_attack_v10_0_techniques <- read_excel(tech_filename)

rel_url <-  "https://attack.mitre.org/docs/enterprise-attack-v10.1/enterprise-attack-v10.1-relationships.xlsx"
rel_filename <- "enterprise-attack-v10.1-relationships.xlsx"
download.file(rel_url, destfile = rel_filename, mode = "wb")
enterprise_attack_v10_0_relationships <- read_excel(rel_filename, col_types = "text")

tactics_url <-  "https://attack.mitre.org/docs/enterprise-attack-v10.1/enterprise-attack-v10.1-tactics.xlsx"
tactics_filename <- "enterprise-attack-v10.1-tactics.xlsx"
download.file(tactics_url, destfile = tactics_filename, mode = "wb")
enterprise_attack_v10_0_tactics <- read_excel("enterprise-attack-v10.1-tactics.xlsx", col_types = "text") %>%
  select(name, description) %>%
  replace(.=="Command and Control", "Command And Control")
  
  
  # Come up with all 14 Tactics, not UKC anymore
  
  UKC <- c("Reconnaissance", "Resource Development", "Initial Access", "Execution", 
           "Persistence", "Privilege Escalation", "Defense Evasion", 
           "Credential Access", "Discovery", "Lateral Movement", "Collection", 
           "Command And Control", "Exfiltration", "Impact")
  
  UKC <- data.frame(name = UKC)
  
  # Find all possible APT's 
  
  APT <- enterprise_attack_v10_0_groups %>% select(name)
  
  # Find all possible Techniques
  
  techniques <- enterprise_attack_v10_0_techniques %>% select(ID) %>% rename(name = `ID`)  
  
  # Collect up all possible nodes
  
  nodes_all <- UKC
  nodes_all <- nodes_all %>% add_row(APT)
  nodes_all <- nodes_all %>% add_row(techniques)
  # nodes <- data.frame(node = c(0:711), name = nodes)
  nodes_all <- data.frame(nodes_all)
  
  # Build the link data frame
  # We only want links related to targetAPT
  
  # Find the source of APT to techniques
  
  APT_to_tech_all <- enterprise_attack_v10_0_relationships %>% 
    filter(`source type` == 'group' & `target type` == 'technique')
  APT_to_tech_all <- APT_to_tech_all %>% select(`source name`, `target ID`)
  
  # Now find the relations between all techniques and UKC
  
  techniques_df <- enterprise_attack_v10_0_techniques
  tech2tac_df <- techniques_df %>% select(ID, tactics)
  
  tester <- tidyr::separate(tech2tac_df, tactics, into = c("1", "2", "3", "4", "5"), sep = ", ", extra  = "drop", fill = "right")
  tester <- tester %>% tidyr::gather(key = "tactics", value = "file.column", 2:6)
  tester <- tester %>% dplyr::select(-tactics)
  tester <- tester %>% dplyr::rename(tactics = file.column)
  
  tester <- tester %>% filter(!is.na(tactics))
  tech_2_tac_all <- tester
  
  
