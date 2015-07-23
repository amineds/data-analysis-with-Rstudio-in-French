Ce tutoriel, dans la mesure du possible, présente les principales étapes d'une analyse de données en langage R à l'aide de RStudio.

Seront abordées :
* Lecture de fichiers, cas particulier du format .csv
* Nettoyage des données
* Formattage de données
* Exploration des données
* Consolidation des données
* Représentation graphique des données

### Lecture de fichiers, cas particulier du format `.csv`

Première chose à faire, définir le répertoire de travail avec l'aide de la fonction `setwd`


```r
#source : "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
gdp_data <- read.csv("gdp.csv",
                     stringsAsFactors=TRUE,
                     header = FALSE,
                     skip=5,
                     nrows=190,
                     strip.white = TRUE,
                     skipNul = TRUE
                    )
head(gdp_data,n=5) #les 5 premières lignes
```

```
##    V1 V2 V3            V4           V5 V6 V7 V8 V9 V10
## 1 USA  1 NA United States  16,244,600     NA NA NA  NA
## 2 CHN  2 NA         China   8,227,103     NA NA NA  NA
## 3 JPN  3 NA         Japan   5,959,718     NA NA NA  NA
## 4 DEU  4 NA       Germany   3,428,131     NA NA NA  NA
## 5 FRA  5 NA        France   2,612,878     NA NA NA  NA
```
Profilage de chaque colonne

```r
str(gdp_data)
```

```
## 'data.frame':	190 obs. of  10 variables:
##  $ V1 : Factor w/ 190 levels "ABW","AFG","AGO",..: 179 34 87 45 58 61 25 145 84 78 ...
##  $ V2 : int  1 2 3 4 5 6 7 8 9 10 ...
##  $ V3 : logi  NA NA NA NA NA NA ...
##  $ V4 : Factor w/ 190 levels "Afghanistan",..: 182 37 85 64 60 181 25 141 83 77 ...
##  $ V5 : Factor w/ 189 levels " 1,008 "," 1,129 ",..: 39 164 134 95 63 60 58 55 54 15 ...
##  $ V6 : Factor w/ 7 levels "","a","b","c",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ V7 : logi  NA NA NA NA NA NA ...
##  $ V8 : logi  NA NA NA NA NA NA ...
##  $ V9 : logi  NA NA NA NA NA NA ...
##  $ V10: logi  NA NA NA NA NA NA ...
```
Ne garder que les colonnes qui nous intéressent

```r
gdp_data <- gdp_data[,c(1,2,4,5)]
```


```r
#source : "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
eds_data <- read.csv("edstats_country.csv",
                     stringsAsFactors=TRUE,
                     header = TRUE,
                     skip=0,
                     skipNul = TRUE,
                     strip.white = TRUE
                    )
```

### Nettoyage des données

### Formattage de données

On commence par combiner les 2 dataframes avec la fonction merge.


```r
#Merging data
merged_data = merge(gdp_data,
                    eds_data,
                    by.x="V1",
                    by.y="CountryCode",
                    all=FALSE                 
)
```
On renomme certaines colonnes et on ordonne notre dataframe selon le `Rank`

```r
suppressWarnings(library(reshape))
suppressWarnings(library(dplyr))
```

```
## 
## Attaching package: 'dplyr'
## 
## The following object is masked from 'package:reshape':
## 
##     rename
## 
## The following objects are masked from 'package:stats':
## 
##     filter, lag
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
merged_data <- reshape::rename(merged_data,c(V1="CountryCode",V2="Rank",V4="CountryName",V5="GDP"))

merged_data <- arrange(merged_data,desc(Rank))
```

###  Exploration statistique des données

Application de quelques fonctions statistiques sur les données


```r
#Moyenne du rang pour les pays membres de l'OCDE
mean(merged_data$Rank[merged_data$Income.Group=="High income: OECD"])
```

```
## [1] 32.96667
```


```r
#Moyenne du rang pour les pays hors OCDE
mean(merged_data$Rank[merged_data$Income.Group=="High income: nonOECD"])
```

```
## [1] 91.91304
```


```r
#Seuils du GDP
range(merged_data$GDP)
```

```
## Error in Summary.factor(structure(c(180L, 175L, 176L, 177L, 178L, 179L, : 'range' not meaningful for factors
```

###  Exploration graphique des données

###  Consolidation des données

### Représentation graphique des données



