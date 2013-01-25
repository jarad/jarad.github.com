#' This R script will process all R mardown files (those with in_ext file extention,
#' .Rmd by default) in the current working directory. Files with a status of
#' 'processed' will be converted to markdown (with out_ext file extention, '.md'
#' by default). It will change the published parameter to 'true' and change the
#' status parameter to 'publish'.
#' 
#' @param dir the directory to process R Markdown files.
#' @param out_ext the file extention to use for processed files.
#' @param in_ext the file extention of input files to process.
#' @return nothing.
#' @author Jason Bryer <jason@bryer.org>, Jarad Niemi <
convertRMarkdown <- function(dir=getwd(), images.dir=dir, images.url='/images/',
           out_ext='.md', in_ext='.Rmd') {
  require(knitr, quietly=TRUE, warn.conflicts=FALSE)
  files <- list.files(path=dir, pattern=in_ext, ignore.case=TRUE)
  for(f in files) {
    message(paste("Processing ", f, sep=''))
    content <- readLines(f)
    frontMatter <- which(substr(content, 1, 3) == '---')
    if(length(frontMatter) == 2) {
      statusLine <- which(substr(content, 1, 7) == 'status:')
      publishedLine <- which(substr(content, 1, 10) == 'published:')
      if(statusLine > frontMatter[1] & statusLine < frontMatter[2]) {
        status <- unlist(strsplit(content[statusLine], ':'))[2]
        status <- sub('[[:space:]]+$', '', status)
        status <- sub('^[[:space:]]+', '', status)
        if(tolower(status) == 'process') {
          #This is a bit of a hack but if a line has zero length (i.e. a
          #black line), it will be removed in the resulting markdown file.
          #This will ensure that all line returns are retained.
          content[nchar(content) == 0] <- ' '
          message(paste('Processing ', f, sep=''))
          content[statusLine] <- 'status: publish'
          content[publishedLine] <- 'published: true'
          outFile <- paste(substr(f, 1, (nchar(f)-(nchar(in_ext)))), out_ext, sep='')
          render_markdown(strict=TRUE)
          opts_knit$set(out.format='markdown')
          opts_knit$set(base.dir=images.dir)
          opts_knit$set(base.url=images.url)
          try(knit(text=content, output=outFile), silent=FALSE)
        } else {
          warning(paste("Not processing ", f, ", status is '", status, 
                  "'. Set status to 'process' to convert.", sep=''))
        }
      } else {
        warning("Status not found in front matter.")
      }
    } else {
      warning("No front matter found. Will not process this file.")
    }
  }
  invisible()
}
