library(tidyverse)
library(glue)
library(sf)

# Read data
vanc <- read_sf("../data/vancouver-bikeways-preprocess-v1.geojson") %>%
	mutate(city = "vancouver")
calg <- read_sf("../data/calgary-bikeways-preprocess-v1.geojson") %>%
	mutate(city = "calgary")
toron <- read_sf("../data/toronto-bikeways-preprocess-v1.geojson") %>%
	mutate(city = "toronto")

# Combine data
bike <- bind_rows(vanc, calg, toron)

# Get verify data
bike_verify <- bike %>%
	filter(!city %in% c("calgary", "vancouver")) %>%
	add_row( # calgary filters appendix 2
		bike %>%
			filter(
				city == "calgary" &
					install_type %in% c("Bicycle Lane", "Cycle Track") &
					!status %in% c("INACTIVE", "PLANNED")
			)
	) %>%
	add_row( # vancouver filters appendix 2
		bike %>%
			filter(
				city == "vancouver" &
					install_type %in% c("Painted Lanes", "Protected Bike Lanes", "Local Street") &
					road_type != "Off-street"
			)
	)

# Get verify data with missing installs
bike_miss <- bike_verify %>%
	filter(is.na(verify_install_year) & is.na(verify_misclass)) %>%
	filter(city %in% c("calgary", "vancouver")) %>%
	select(city, everything())

# Save as csv and geojson
bike_miss %>% write_csv("../data/archive/check-verify-2024-09-27.csv")
bike_miss %>% select(Description = id) %>% write_sf("../data/archive/check-verify-2024-09-27.kml", driver = "kml", delete_dsn = TRUE)
bike_miss %>% write_sf("../data/archive/check-verify-2024-09-27.geojson")
