
# Obtain data -------------------------------------------------------------

dat_urls <- list(
  "http://www.esapubs.org/archive/ecol/E084/093/Mammal_lifehistories_v2.txt", # Ernest, 2003
  "http://www.esapubs.org/archive/ecol/E090/184/PanTHERIA_1-0_WR05_Aug2008.txt", # PanTHERIA
  "http://www.esapubs.org/archive/ecol/E090/184/PanTHERIA_1-0_WR93_Aug2008.txt", # PanTHERIA
  "http://www.esapubs.org/archive/ecol/E096/269/Data_Files/Amniote_Database_Aug_2015.csv", # Myhrvold et al., 2015
  "http://www.esapubs.org/archive/ecol/E095/178/MamFuncDat.txt" # Wilman et al,. 2014
)

dat_try <- lapply(dat_urls, function(x){
  if( grepl("txt$", x) ) {
    df <- read.table( x, sep = "\t", header = TRUE )
  }
  if( grepl("csv$", x) ) {
    df <- read.csv( x, header = TRUE)
  }
  return(df)
})

save(dat_try, file = paste0( wd$bin, "dat_try.Rda" ) )

# Tidy data ---------------------------------------------------------------

# Select columns of potential interest with keyword matching.
col_keywords_of_interest <- c( "scientific", "class", "order", "family", "genus", "species", "subspecies", "binomial", "mass" )
col_keywords_string <- paste(col_keywords_of_interest, sep="", collapse="|")

dat1 <- lapply(dat_try, function(x){
  x <- x[ ,  grep( pattern = col_keywords_string, names( x ), ignore.case = TRUE ) ] 
  x <- x[ , -grep("wean|neonate|egg|fledging|speclevel|source", names(x), ignore.case = TRUE)] # Filter out specific columns.
  x <- x %>% dplyr::rename_all(tolower)
  return(x)
})

# Clean col names.
dat2 <- lapply(dat1, function(x){
  names(x) <- gsub("[0-9].", "", names(x))
  names(x) <- gsub("^msw_|^msw|^x|latin", "", names(x))
  return(x)
})

# Split binomials where needed:
dat2[[5]] <- dat2[[5]] %>% 
    tidyr::separate("scientific", c("genus", "species", "subspecies"), sep = " " )

# Combine:
dat3 <- dat2 %>% 
  plyr::ldply() %>% 
  mutate_all(as.character) %>% 
  mutate_all(tolower)
  
# Remove empty rows.
dat3[ dat3 == "<NA>"] <- NA
dat3[ dat3 == ""]     <- NA
dat3[ dat3 == " "]    <- NA
dat3[ dat3 == " NA"]  <- NA
dat3[ dat3 == "-999"]  <- NA
dat3 <- dat3[ rowSums( is.na(dat3) ) != ncol(dat3), ]
  
mydat <- dat3 %>% 
  mutate(
    binomial = if_else(
      is.na(binomial),
      paste(genus, species, sep = " "),
      binomial
      )
  ) %>% 
  mutate(
    SciName = gsub(" ", "_", binomial)
    ) %>% 
  # Reorder cols:
  select( class, order, family, binomial, genus, species, subspecies, everything() ) %>% 
  # Because there are some amniotes in these data, but they are labeled by class,
  # we can filter out the birds and reptiles and be assured the remainder are mammals.
  dplyr::filter( class == "Mammalia" | is.na(class) )

# What fraction of each column is filled?
lapply(mydat, function(x) sum( !is.na(x) ) / length(x) )

save( mydat, file = paste0( wd$bin, "mydat.Rda" ) )
