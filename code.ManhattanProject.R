# Author: Benjamin Reddy
# Taken from pages 49-50 of O'Neil and Schutt
# http://www1.nyc.gov/site/finance/taxes/property-rolling-sales-data.page


# read csv file
library(readr)
mp <- read.csv("rollingsales_manhattanproject.csv",skip=4,header=TRUE)
## Check the data

head(mp)
summary(mp)
str(mp) # Very handy function!
#Compactly display the internal structure of an R object.


## clean/format the data with regular expressions
## More on these later. For now, know that the
## pattern "[^[:digit:]]" refers to members of the variable name that
## start with digits. We use the gsub command to replace them with a blank space.
# We create a new variable that is a "clean' version of sale.price.
# And sale.price.n is numeric, not a factor.

mp$SALE.PRICE.N <- as.numeric(gsub("[^[:digit:]]","", mp$SALE.PRICE))
count(is.na(mp$SALE.PRICE.N))

names(mp) <- tolower(names(mp)) # make all variable names lower case

## Get rid of leading digits
mp$gross.sqft <- as.numeric(gsub("[^[:digit:]]","", mp$gross.square.feet))
mp$land.sqft <- as.numeric(gsub("[^[:digit:]]","", mp$land.square.feet))
mp$year.built <- as.numeric(as.character(mp$year.built))

## do a bit of exploration to make sure there's not anything
## weird going on with sale prices
attach(mp)
hist(sale.price.n) 
detach(mp)

## keep only the actual sales

mp.sale <- mp[mp$sale.price.n!=0,]
plot(mp.sale$gross.sqft,mp.sale$sale.price.n)
plot(log10(mp.sale$gross.sqft),log10(mp.sale$sale.price.n))

## for now, let's look at 1-, 2-, and 3-family homes
mp.homes <- mp.sale[which(grepl("FAMILY",mp.sale$building.class.category)),]
dim(mp.homes)
plot(log10(mp.homes$gross.sqft),log10(mp.homes$sale.price.n))
summary(mp.homes[which(mp.homes$sale.price.n<100000),])
""

## remove outliers that seem like they weren't actual sales
mp.homes$outliers <- (log10(mp.homes$sale.price.n) <=5) + 0
mp.homes <- mp.homes[which(mp.homes$outliers==0),]
plot(log10(mp.homes$gross.sqft),log10(mp.homes$sale.price.n))