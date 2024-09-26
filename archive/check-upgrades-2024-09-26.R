library(tidyverse)
library(glue)

# Read data
vanc <- read_csv("../data/vancouver-bikeways-preprocess-v1.csv") %>%
	mutate(city = "vancouver")
calg <- read_csv("../data/calgary-bikeways-preprocess-v1.csv") %>%
	mutate(city = "calgary")
toron <- read_csv("../data/toronto-bikeways-preprocess-v1.csv") %>%
	mutate(city = "toronto")

# Combine data
bike <- bind_rows(vanc, calg, toron)

# Get upgrade counts
bike_upgrades <- bike %>%
	mutate(
		upgrade = case_when(
			!is.na(verify_install_type) & !is.na(verify_upgrade2_type) ~
				glue("{verify_install_type} -> {verify_upgrade1_type} -> {verify_upgrade2_type}"),
			!is.na(verify_install_type) & !is.na(verify_upgrade1_type) ~
				glue("{verify_install_type} -> {verify_upgrade1_type}"),
			.default = NA
		)
	) %>%
	filter(!is.na(upgrade)) %>%
	group_by(city, upgrade) %>%
	count %>%
	group_by(city) %>%
	arrange(desc(n), .by_group = T) %>%
	left_join(
		bike %>%
			group_by(city) %>%
			summarize(
				n_upgrade = sum(!is.na(verify_upgrade1_type) | !is.na(verify_upgrade2_type)),
				n_upgrade1 = sum(!is.na(verify_upgrade1_type) & is.na(verify_upgrade2_type)),
				n_upgrade2 = sum(!is.na(verify_upgrade2_type))
			),
		by = "city"
	) %>%
	mutate(
		n_perc = n / n_upgrade * 100
	) %>%
	select(city, upgrade, n, n_perc, everything())
bike_upgrades

# Save upgrade counts
bike_upgrades %>% write_csv("../data/archive/check-upgrades-2024-09-26.csv")
