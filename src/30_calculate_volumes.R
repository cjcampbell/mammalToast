
load(paste0(wd$bin, "massdat.Rda"))

# OLS Results from calculating mammal volumes estimated from body mass relative to minimum convex hull volume estimates.
# Source:
# Brassey, C. A., & Sellers, W. I. (2014). 
# Scaling of convex hull volume to body mass in modern primates, non-primate mammals and birds. 
# PLoS One, 9(3), e91691.
# https://doi.org/10.1371/journal.pone.0091691


# Looking at density data -------------------------------------------------



# Note that these are either single data points or ranges, so I'm not getting too analytical here.
#

mam_density_tab <- read.table( paste0(wd$data, "brassey_sellers_2014"), sep = ",", header = TRUE ) %>%
  tidyr::separate("density_kg_per_m3",
                  c("density_kg_per_m3_min", "density_kg_per_m3_max"), sep = "-" ) %>%
  dplyr::mutate(
    density_kg_per_m3_max = if_else(
      !is.na(density_kg_per_m3_max),
      density_kg_per_m3_max,
      density_kg_per_m3_min )
    ) %>%
  dplyr::mutate(
    density_kg_per_m3_min = as.numeric(density_kg_per_m3_min),
    density_kg_per_m3_max = as.numeric(density_kg_per_m3_max)
    ) %>%
  melt(id.vars = "Species", value.name = "density_kg_per_m3")


mam_density_tab %>%
  ggplot() +
  geom_boxplot(aes(y = Species, x = density_kg_per_m3)) +
  geom_point(aes(y = Species, x = density_kg_per_m3))

guesstimated_mammal_density <- mean(mam_density_tab$density_kg_per_m3)

# My conversion -----------------------------------------------------------

voldat <- massdat %>%
  mutate( mass_estimation_kg =  mass_estimation / 1000 ) %>% 
  mutate( vol_estimation_m3 = mass_estimation_kg / guesstimated_mammal_density)

save(voldat, file = paste0(wd$bin, "voldat.Rda"))


# Conversion --------------------------------------------------------------

# 
# 
# # These authors used log10 transformed data ("Prior to log10 transformation the datasets did not meet the requirements for normality (Shapiro-Wilks test) and homoscedasticity (Breusch-Pagan test). Model results are therefore only reported for log10 transformed data.")
# 
# # OLS Results:
# # log_bodymass_kg <-  (3.09*log_convex_hull_volume_m3) + 0.92
# 
# voldat <- massdat %>% 
#  # mutate( log_bodymass_kg = log10( mass_estimation / 1000 ) ) %>% 
#  # mutate( log_convex_hull_volume_m3 = (log_bodymass_kg - 0.92) / 3.09 ) %>% 
#  # mutate( volume_m3 = 10^log_convex_hull_volume_m3 )
#   
#   mutate( volume_m3 = ((mass_estimation / 1000) - 0.92) / 3.09 )
# 
# hist(voldat$volume_m3)
# 
# save(voldat, file = paste0(wd$bin, "voldat.Rda"))
