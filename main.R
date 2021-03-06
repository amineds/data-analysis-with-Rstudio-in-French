library(ggplot2)
library(dplyr)

### Lecture de fichiers, cas particulier du format `.csv`
## Premi�re chose � faire, d�finir le r�pertoire de travail 
## � l'aide de la fonction `setwd`

#source : "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
gdp_data <- read.csv("gdp.csv",
                     stringsAsFactors=FALSE,
                     header = FALSE,
                     skip=5,
                     nrows=190,
                     strip.white = TRUE,
                     skipNul = TRUE
                    )
head(gdp_data,n=5) #les 5 premi�res lignes
dim(gdp_data)
names(gdp_data)

#Profilage de chaque colonne
str(gdp_data)

### Nettoyage des donn�es
#Ne garder que les colonnes qui nous int�ressent

gdp_data <- gdp_data[,c(1,2,4,5)]

#Adaptation de la variable V5 : revenu domestique brut (GDP)
gdp_data$V5 <- as.numeric(gsub(",",'',gdp_data$V5))

#source : "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
eds_data <- read.csv("edstats_country.csv",
                     stringsAsFactors=TRUE,
                     header = TRUE,
                     skip=0,
                     skipNul = TRUE,
                     strip.white = TRUE
                    )

### Formattage de donn�es
#On commence par combiner les 2 dataframes avec la fonction merge.
merged_data = merge(gdp_data,
                    eds_data,
                    by.x="V1",
                    by.y="CountryCode",
                    all=FALSE                 
)

#On renomme certaines colonnes et on ordonne notre dataframe selon le `Rank`
merged_data <- reshape::rename(merged_data,c(V1="CountryCode",V2="Rank",V4="CountryName",V5="GDP"))

merged_data <- arrange(merged_data,Rank)

###  Repr�sentation statistique des donn�es
## Application de quelques fonctions statistiques sur les donn�es

#Moyenne du rang pour les pays membres de l'OCDE
mean(merged_data$Rank[merged_data$Income.Group=="High income: OECD"])

#Moyenne du rang pour les pays hors OCDE
mean(merged_data$Rank[merged_data$Income.Group=="High income: nonOECD"])

range(merged_data$GDP)

###  Repr�sentation graphique des donn�es
p <- ggplot(merged_data, aes(x=factor(Income.Group),y=GDP,label=merged_data$CountryCode))

p <- p + geom_boxplot() + coord_flip()

#p <- p + geom_text()

p

###  Consolidation des donn�es
merged_data %>%
    group_by(Region) %>%
    summarise(sum_gdp = sum(GDP)) %>%
    arrange(desc(sum_gdp))

