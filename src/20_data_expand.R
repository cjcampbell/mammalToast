
# Find unique taxonomies. -------------------------------------------------------------------

load( paste0( wd$bin, "mydat.Rda" ) )

if( length( mydat$SciName ) != nrow(mydat) ) warning( "Not all rows have SciName!" )

# Remove redundancies in mydat.
mydat2 <- mydat %>% 
  split( .$SciName) %>% 
  purrr::map(~ reshape2::melt( data = .,
          id.vars = c( "SciName","class", "order", "family", "genus", "species", "subspecies", "binomial" ),
          variable.name = "mass_descriptor", 
          value.name = "mass"
          ) %>% 
        filter(!is.na(mass))
      ) %>% 
  plyr::ldply() %>% 
  mutate(mass = as.numeric(mass))

# # Existing mammal species -------------------------------------------------
burgin2019 <- read_excel( paste0( wd$data, "burgin2019.xlsx"), sheet = "MDD v1") %>% 
  dplyr::rename_all(tolower) %>% 
  mutate_all(as.character) %>% 
  mutate_all(tolower)

# Here I introduce a big assumption (this is a coarse analysis, and I'm interested in proportions).
# Let's assume that most mammals are about the same mass as others in there genus.
# Let's set the guessed volume for individuals without bodymass info at the average 
# for their species/genus/family/order.

# This is inelegant, but whatchagonnado!
mydat_by_SciName <- mydat2  %>%
  dplyr::rename_all(tolower) %>% 
  dplyr::group_by(sciname) %>%
  dplyr::summarise(
    mass_mean_SciName = mean(mass, na.rm = T),
    mass_sd_SciName   = sd(mass, na.rm = T),
    mass_n_mass = n()
  )
mydat_by_genus <- mydat2  %>%
  dplyr::group_by(genus) %>%
  dplyr::summarise(
    mass_mean_genus = mean(mass, na.rm = T),
    mass_sd_genus   = sd(mass, na.rm = T),
    mass_n_genus = n()
  ) 
mydat_by_family <- mydat2  %>%
  dplyr::group_by(family) %>%
  dplyr::summarise(
    mass_mean_family = mean(mass, na.rm = T),
    mass_sd_family   = sd(mass, na.rm = T),
    mass_n_family = n()
  ) 
mydat_by_order <- mydat2  %>%
  dplyr::group_by(order) %>%
  dplyr::summarise(
    mass_mean_order = mean(mass, na.rm = T),
    mass_sd_order   = sd(mass, na.rm = T),
    mass_n_order = n()
  ) 

bigdat <- burgin2019 %>% 
  left_join(mydat_by_SciName, by = "sciname") %>% 
  left_join(mydat_by_genus,   by = "genus")  %>%
  left_join(mydat_by_family,  by = "family") %>% 
  left_join(mydat_by_order,   by = "order")

# How many of each get estimated?
massdat <- bigdat %>% 
  mutate(
    estimation_level = if_else(!is.na(mass_mean_SciName), "species",
                               if_else(!is.na(mass_mean_genus), "genus",
                                       if_else(!is.na(mass_mean_family), "family",
                                               if_else(!is.na(mass_mean_order), "order",
                                                       as.character(NA))))),
    mass_estimation = if_else(!is.na(mass_mean_SciName), mass_mean_SciName,
                                 if_else(!is.na(mass_mean_genus), mass_mean_genus,
                                         if_else(!is.na(mass_mean_family), mass_mean_family,
                                                 if_else(!is.na(mass_mean_order), mass_mean_order,
                                                         as.numeric(NA)))))
    )
massdat %>% 
  group_by(estimation_level) %>% 
  dplyr::summarise(n = n())

save(massdat, file = paste0( wd$bin, "massdat.Rda") )



 
# iucn_mam <- read_excel("data/burgin2019.xlsx", sheet = "IUCN-28June2017")






# massdat <- mydat2  %>% 
#   
#   dplyr::group_by(SciName) %>% 
#   dplyr::summarise(
#     mass_mean = mean(mass, na.rm = T),
#     mass_sd   = sd(mass, na.rm = T),
#     n = n()
#   )
# 
# save(massdat, file = paste0( wd$bin, "massdat.Rda") )
# 


# Bring back taxonomic classifications ------------------------------------

# mydat %>% 
#   nrow()
#   group_by(SciName) %>% 
#   filter(
#     !is.na("class") #| !is.na("order") | !is.na("family") 
#     ) %>% 
#   nrow()


# 