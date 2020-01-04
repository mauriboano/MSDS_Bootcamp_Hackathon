# UVA MSDS skills bootcamp submission for Taylor Derby, Maurizio Boano, Aaron Oliver, and Preston Parrott

library(tidyverse)
library(dplyr)
library(sf)
library(leaflet)
library(parlitools)
library(mnis)


west_hex_map <- parlitools::west_hex_map

party_colour <- parlitools::party_colour

mps <- mps_on_date('2020-01-01')

mps_colours <- left_join(mps, party_colour, by = "party_id")

west_hex_map <- left_join(west_hex_map, mps_colours, by = "gss_code") 


parties <- unique(west_hex_map$party_name)
parties_short <- filter(party_colour, party_name %in% parties)


labels <- paste0(
        "<strong>", west_hex_map$constituency_name, "</strong>", "</br>",
        west_hex_map$party_name, "</br>",
        west_hex_map$display_as, "</br>",
        "2019 Result: ", west_hex_map$result_of_election, "</br>",
        "2019 Majority: ", west_hex_map$majority
) %>% lapply(htmltools::HTML)


leaflet(
        west_hex_map) %>%
        addPolygons(
                color = "grey",
                weight=0.75,
                opacity = 0.5,
                fillOpacity = 1,
                fillColor = ~party_colour,
                label=labels) %>% 
        addLegend("topright", 
                  values = ~(party_name), 
                  colors = ~party_colour,
                  labels = ~party_name,
                  title = "Seats Held",
                  opacity = 1,
                  data = parties_short
        )

