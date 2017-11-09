#!/usr/bin/Rscript --vanilla

# compiles all .Rmd files in _R directory into .md files in _posts directory,
# if the input file is older than the output file.

# run ./knitpages.R to update all R markdown files

source("KnitPost.R")

for (infile in list.files(".", pattern="*.Rmd", full.names=TRUE)) {
    outfile = paste0("../_posts/", sub(".Rmd$", ".md", basename(infile)))

    # knit only if the input file is the last one modified
    if (!file.exists(outfile) |
        file.info(infile)$mtime > file.info(outfile)$mtime) {
        KnitPost(infile, outfile)
    }
}

