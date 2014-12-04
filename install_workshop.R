install.packages(c("ggplot2", "gridExtra", "knitr", "maps", 
                   "plyr", "reshape2", "rmarkdown", "SpatialEpi", "xtable"))
download.files("https://www.jarad.me/ISDSWorkshop_0.1.tar.gz", "ISDSWorkshop.tar.gz", mode="wb")
install.packages("ISDSWorkshop.tar.gz", repos = NULL, type = "source")

if (require(ISDSWorkshop)) print("ISDS R Workshop installed succesfully!\n")

