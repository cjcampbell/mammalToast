
load(paste0(wd$bin, "voldat.Rda"))
load(paste0(wd$bin, "toaster_volume.Rda"))

# How many mammals are smaller than a toaster? -----------------------------
toaster_vol <- toaster_volume$volume_m3 %>% mean

sum( voldat$vol_estimation_m3 < toaster_vol, na.rm = T) / nrow(voldat)


# Histogram of volume of mammal bodies by species counts.  ----------
# Log scale on horizontal axis. 
# Colors show taxonomic order (visible with tooltip). 
# Mean toaster volume inidicated by red vertical line.
g <- ggplot(voldat) +
  theme_bw() +
  geom_histogram(aes(vol_estimation_m3, color = order, fill = order, group = order), alpha = 0.5, binwidth = 0.5, position = "stack") +
  scale_color_viridis_d() +
  scale_fill_viridis_d() +
  geom_vline(xintercept = toaster_vol, col = "red") +
  scale_x_log10(name = "Estimated volume (m3)", expand = c(0,0)) +
  scale_y_continuous(limits = c(0, 1750), expand = c(0,0 )) +
  theme(legend.position = "none")

# Plot with plotly --
require(plotly)
ggplotly(g, tooltip = c("fill") )

# Plot with phylopic --

require(rphylopic)
# Inform how I select phylopics:
voldat %>% group_by(order) %>% 
  dplyr::summarise(n = n(), mean_vol = mean(vol_estimation_m3, na.rm = T) ) %>% 
  arrange(desc(n)) %>% 
  View

# Make phylopic image plots

addspecies <- data.frame(
  sciname = c(
    "corynorhinus_townsendii",
    "rattus_rattus",
    "nilgiritragus_hylocrius"
    ),
  uuid = c(
    "18bfd2fc-f184-4c3a-b511-796aafcc70f6",
    "66511ed6-60f4-44a6-abfc-68488e98f678",
    "dd52da0c-2d10-4f57-8013-6ffefbedcc40"
    ),
  binom = c(
    "Corynorhinus townsendii",
    "Rattus rattus",
    "Nilgiritragus hylocrius"
    ),
  order = c(
    "chiroptera",
    "rodentia",
    "artiodactyla"
    ),
  my_y = c(
    1500,
    1500, 
    1500
  )
  )
p <- g
for(i in 1:nrow(addspecies)) {
  img <- image_data( addspecies[ i, "uuid"] , size = "64")[[1]]
  horiz <- voldat[ voldat$sciname == addspecies[ i, "sciname"] , "vol_estimation_m3"] %>% unlist %>% log10()
  p <- p + 
    add_phylopic(img, alpha = 1, x = horiz, y = addspecies[ i, "my_y"], ysize = 100) +
    geom_text(label = addspecies[ i, "binom"], x = horiz, y = addspecies[ i, "my_y"] - 75, size = 4 )
}

p
