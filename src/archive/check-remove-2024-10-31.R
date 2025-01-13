library(tidyverse)
library(glue)
library(sf)

# Read data
vanc <- read_sf("../data/vancouver-bikeways-preprocess-v2.geojson") %>%
	mutate(city = "vancouver")
calg <- read_sf("../data/calgary-bikeways-preprocess-v3.geojson") %>%
	mutate(city = "calgary")
toron <- read_sf("../data/toronto-bikeways-preprocess-v3.geojson") %>%
	mutate(city = "toronto")

# Combine data
bike <- bind_rows(vanc, calg, toron)

# Filter for installs that have removed or None infra after 2009
bike <- bike %>%
	filter(
		verify_install_type %in% c("None", "N") &
		verify_install_year > 2009
	)

# Create streetview links
bike <- bike %>%
	mutate(
		verify_remove_lon = geometry %>% st_centroid %>% st_coordinates %>% .[, 1],
		verify_remove_lat = geometry %>% st_centroid %>% st_coordinates %>% .[, 2],
		verify_remove_url = paste0(
			"http://maps.google.com/maps?q=&layer=c&cbll=",
			verify_remove_lat,
			",",
			verify_remove_lon
		)
	)

# Save file with city, ids, and remove columns
bike <- bike %>%
	select(
		city,
		id,
		verify_install_year,
		verify_install_type,
		verify_install_comment,
		verify_remove_url
	) %>%
	mutate(
		verify_remove_year = NA,
		verify_remove_type = NA,
		verify_remove_comment = NA
	) %>%
	as_tibble %>%
	select(-geometry)
bike %>% write_csv("../data/archive/check-remove-2024-10-31.csv", na = "")
