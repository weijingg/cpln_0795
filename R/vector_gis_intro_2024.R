# Introduction to GIS with R - The Tidyverse and sf
# CPLN 0795, 2024

# We are going to do almost the exact same routines that we did in classes 2-3 using ArcGIS, 
# except we will do it in R.

# First we toy around with code really simply to see how it executes.

# This is some basic R stuff

# I can do some stuff in the console by executing code

print("hello world")

# I can also make some new objects in my environment

string_object <- "derp"

numeric_object <- 5

vector_object <- c("schwarber", "turner", "harper", "bohm", "realmuto", "castellanos", "stott", "sosa", "rojas")

# To get started we are going to load libraries that we will need to work with more complex data like
# spatial objects and data-frames (aka spreadsheet type things)

library(tidyverse)
library(sf)

# Now let's load the data 

# Load a csv

phila_tracts <- read.csv("https://raw.githubusercontent.com/mafichman/cpln_0795/main/data/philadelphia_tracts_2020.csv")
  
# What do these data look like?

glimpse(phila_tracts)

# Look at some central tendancies

mean(phila_tracts$pop)

median(phila_tracts$med_inc) # what's going wrong here??

median(phila_tracts$med_inc, na.rm = TRUE)

# Let's use the core dplyr "verbs" to manipulate the data and create some new data frames

just_two_columns <- phila_tracts %>%
  select(GEOID, tract)

some_new_column_names <- phila_tracts %>%
  rename(tracty_mctracterson = tract,
         unique_ID = GEOID)

# When I use the mutate command, I'm going to overwrite my existing data frame - that helps
# keep my environment nice and clean (but can also cause me issues if i'm not careful)

phila_tracts <- phila_tracts %>%
  mutate(pct_own = 100*(owner_hh/hhs),
         majority_white = ifelse(pct_wht > 50, "Majority White", "Majority Non-White"))

# Challenge #1 - Let's do some more detailed kinds of summaries using group_by
# Create some Using this code framework - can you find the mean median income of tracts that are
# majority white vs. non?

phila_tracts %>% 
  group_by(majority_white) %>% 
  summarize(total_pop = sum(pop))

# OK, now let's get SPATIAL

# Load an sf object

phila_tracts_sf <- st_read("https://raw.githubusercontent.com/mafichman/cpln_0795/main/data/philadelphia_tracts_no_data.geojson")

# What does it look like?

glimpse(phila_tracts_sf)

phila_tracts_sf

st_crs(phila_tracts_sf)

# Let's reproject it to PA State Plane (see spatialreference.org to find the CRS)
# To keep our environment nice and neat, let's 

phila_tracts_sf <- phila_tracts_sf %>% 
  st_transform(crs = 2272)

# do a tabular join to bring the two objects together

tracts_with_data <- left_join(phila_tracts_sf, phila_tracts, by = "NAME")

# What do we have now? Let's check out our data.

glimpse(tracts_with_data)

# Let's clean it up a bit, some of our columns got duplicated and renamed

tracts_with_data <- tracts_with_data %>%
  select(-tract.y, -GEOID.y) %>%
  rename(GEOID = GEOID.x,
         tract = tract.x)

# Let's make a histogram using the ggplot package - it's basically a "recipe" for a graphic
# You add geometries (geom), and you aestheticize data with aes() inside those elements
# Notice we use a plus sign instead of the pipe from dplyr, but the idea is the same

ggplot()+
  geom_histogram(data = tracts_with_data, 
                 aes(med_inc))

# Let's make it prettier using an onboard graphic theme from ggplot

ggplot()+
  geom_histogram(data = tracts_with_data, 
                 aes(med_inc)) +
  theme_bw()

# Let's go one step further and add some titles and style the axes

ggplot()+
  geom_histogram(data = tracts_with_data, 
                 aes(med_inc)) +
  labs(
    title = "Median Household Income, Philadelphia Census Tracts, 2020",
    subtitle = "The Average Tract's Median HH Income is appx $26,700",
    x="Dollars (not inflation adjusted)",
    y="Number of Tracts",
    caption = "Data: American Community Survey 5-year estimates")+
  theme_bw()

# Let's make a "facetted" map, comparing variables between majority owner versus majority white vs
# majority non-white tracts. Facets split data along categorical lines according to some column

ggplot()+
  geom_histogram(data = tracts_with_data, 
                 aes(med_inc)) +
  facet_wrap(~majority_white)+
  labs(
    title = "Median Household Income, Philadelphia Census Tracts, 2020",
    subtitle = "The Average Tract's Median HH Income is appx $26,700",
    x="Dollars (not inflation adjusted)",
    y="Number of Tracts",
    caption = "Data: American Community Survey 5-year estimates")+
  theme_bw()

## Challenge number 2 - make a new variable using mutate and generate a new facetted histogram 
# for a different variable

# MAKING MAPS

# Oh wait, we can use the ggplot package to make maps too!

ggplot()+
  geom_sf(data = tracts_with_data,
          aes(fill = med_inc))

# make it prettier

ggplot()+
  geom_sf(data = tracts_with_data,
          aes(fill = med_inc), color = "transparent")+
  theme_minimal()


# Challenge # 2 - make a map visualizations by mutating new variables. Create a title, subtitles etc.,
# You can also use facets if you want.



# Challenge # 3 - if time allows:

# Try using the viridis and viridisLite packages to create some cooler color ramps with our fill aesthetics
# Google it and see what you find.