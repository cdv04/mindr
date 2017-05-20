#' mindr()
#' Convert markdown or rmarkdown files to mindmap files.
#' @param title character. The title of the output file.
#' @param inputformat character. Its value can be:
#' - 'markdown' (default)
#' - 'mindmap'
#' @param remove_curly_bracket logical.
#' @param folder character. The folder which contains the input file(s).
#'
#' @return a mindmap file,which can be viewed by mindmap software, such as FreeMind or Xmind.
#' @export
#'
#' @examples
#' mindr()
mindr <- function(title = 'my title', folder = 'mm', inputformat = 'markdown', remove_curly_bracket = FALSE) {
  if (inputformat == 'markdown') {
  header <- outline(folder, remove_curly_bracket, inputformat)
  ncc <- sapply(header, function(x) nchar(strsplit(x, split = ' ')[[1]][1]))
  mmtext <- substr(header, ncc + 2, nchar(header))
  mm <- '<map version="1.0.1">'
  mm[2] <- paste0('<node TEXT="', title, '">')
  diffncc <- diff(ncc)
  for (i in 1:length(diffncc)) {
    if (diffncc[i] == 1) mm[i+2] <- paste0('<node TEXT="', mmtext[i], '">')
    if (diffncc[i] == 0) mm[i+2] <- paste0('<node TEXT="', mmtext[i], '"></node>')
    if (diffncc[i] < 0) mm[i+2] <- paste0('<node TEXT="', mmtext[i], '">', paste0(rep('</node>', -diffncc[i] + 1), collapse = ''))
  }
  mm[length(ncc) + 2] <- paste0('<node TEXT="', mmtext[length(ncc)], '">', paste0(rep('</node>', ncc[length(ncc)]), collapse = ''))
  mm[length(ncc) + 3] <- '</node></map>'
  writeLines(text = mm, 'mm.mm', useBytes = TRUE)
  } else if (inputformat == 'mindmap') {
    message('This function is still under construction. Please come later.')
  } else {
    message('"inputformat" must be either "markdown" or "mindmap"!')
  }
}

#' Outline
#' Extract headers of markdown or rmarkdown files as an outline
#' @param remove_curly_bracket logical.
#' @param folder character. The folder which contains the input file(s).
#' @param inputformat character. Its value can be:
#' - 'markdown' (default)
#' - 'mindmap'
#' @param savefile logical
#' @param savefilename character. Valid when savefile == TRUE
#'
#' @return outline of a markdown document or book.
#' @export
#'
#' @examples
#' outline()
outline <- function(folder = 'mm', remove_curly_bracket = FALSE, inputformat = 'markdown', savefile = FALSE, savefilename = 'outline.md') {
  if (inputformat == 'markdown') {
    md <- NULL
    for (filename in dir(folder, full.names = TRUE)) md <- c(md, readLines(filename, encoding = 'UTF-8'))
    headerloc <- grep('^#+', md)
    codeloc <- grep('^```', md)
    # exclude the lines begining with # but in code
    header <- md[headerloc[!sapply(headerloc, function(x) sum(x > codeloc[seq(1, length(codeloc), by = 2)] & x < codeloc[seq(2, length(codeloc), by = 2)])) == 1]]
    if (remove_curly_bracket) header <- gsub(pattern = '\\{.*\\}', '', header)
    if (savefile) writeLines(text = header, savefilename, useBytes = TRUE)
    return(header)
  } else if (inputformat == 'mindmap') {
    message('This function is still under construction. Please come later.')
  } else {
    message('"inputformat" must be either "markdown" or "mindmap"!')
  }
}