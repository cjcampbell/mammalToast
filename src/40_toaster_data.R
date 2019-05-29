
# 2-slice toaster
# https://www.amazon.com/AmazonBasics-KT-3680-2-Slice-Toaster/dp/B072P11H8L/ref=sr_1_3?keywords=toaster&qid=1559104738&refinements=p_n_feature_keywords_two_browse-bin%3A5103478011&rnid=5103477011&s=kitchen&sr=1-3
# 4-slice toaster.
# https://www.amazon.com/Cuisinart-CPT-180-Classic-4-Slice-Stainless/dp/B0000A1ZN1/ref=sr_1_3?keywords=toaster&qid=1559104751&refinements=p_n_feature_keywords_two_browse-bin%3A5103480011&rnid=5103477011&s=kitchen&sr=1-3

# Reporting dimensions of this toaster and 3 compared on each page.

two_slice1  <- c( 10.7, 6.42,  7.56, 2)
two_slice2  <- c( 8.2,  12.7,  8.8 , 2)
two_slice3  <- c( 12.7, 7.9,   8.2 , 2)
two_slice4  <- c( 12.6, 7.08,  8.43, 2)
four_slice1 <- c( 11.15, 10.65,7.5, 4)       	
four_slice2 <- c( 12.7, 7.9,  8.2 , 4)      	
four_slice3 <- c( 12.6, 12.3, 9   , 4)         
four_slice4 <- c( 10.8, 10.7, 7.2 , 4)         

toaster_volume <- rbind( two_slice1,  two_slice2,  two_slice3,  two_slice4,  four_slice1,  four_slice2,  four_slice3,  four_slice4) %>% 
  as.data.frame() %>% 
  dplyr::rename( slices = V4 ) %>% 
  mutate( volume_in3 = V1*V2*V3) %>% 
  mutate( volume_m3 = volume_in3 * 1.6387e-5 )

save(toaster_volume, file = paste0(wd$bin, "toaster_volume.Rda"))
