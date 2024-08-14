# Load some libraries

library(tidyverse)
library(sf)
library(tigris)


# We are going to do basically what we did in classes 2-3, except we will do it in R.

# First we toy around with code really simply

# Load a csv

phila_tracts <- read.csv("https://raw.githubusercontent.com/mafichman/cpln_0795/main/data/philadelphia_tracts_2020.csv")
  
# Manipulate it a bit, do some dplyr verbs

glimpse(phila_tracts)

# Load an sf object


# do a tabular join

# make a plot (histogram)

# make a map

# make a facetted map

# Load the same data from tidycensus... load your API key

library(tidycensus)

# Load the 311 data and do a spatial summary

# check the projection first

# make a markdown from a template, grab this repo from github, make a change to your own repo and push it.