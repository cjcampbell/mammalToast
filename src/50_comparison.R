
load(paste0(wd$bin, "voldat.Rda"))
load(paste0(wd$bin, "toaster_volume.Rda"))


# How many mammals are smaller than a toaster? -----------------------------
toaster_vol <- toaster_volume$volume_m3 %>% mean

sum( voldat$vol_estimation_m3 < toaster_vol, na.rm = T) / nrow(voldat)



# Plot --------------------------------------------------------------------
require(plotly)

g <- ggplot(voldat) +
  theme_bw() +
  geom_histogram(aes(vol_estimation_m3, color = order, fill = order, group = order), alpha = 0.5, binwidth = 0.5, position = "stack") +
  scale_color_viridis_d() +
  scale_fill_viridis_d() +
  geom_vline(xintercept = toaster_vol, col = "red") +
  scale_x_log10() +
  scale_y_continuous(limits = c(0, 1750), expand = c(0,0 )) +
  theme(legend.position = "none")

ggplotly(g, tooltip = c("fill") )


# Plot with phylopic ------------------------------------------------------
# 
# require(rphylopic)
# 
# bats <- search_text(text = "chiroptera", options = "names")
