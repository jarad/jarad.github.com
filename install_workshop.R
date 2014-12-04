install.packages(c("ggplot2", "gridExtra", "knitr", "maps", "mapproj", 
                   "plyr", "reshape2", "rmarkdown", "SpatialEpi", "xtable"))
download.file("http://www.jarad.me/ISDSWorkshop_0.1.tar.gz", "ISDSWorkshop.tar.gz", mode="wb")
install.packages("ISDSWorkshop.tar.gz", repos = NULL, type = "source")

if (require(ISDSWorkshop)) message("\n    ISDS R Workshop installed succesfully!\n")

