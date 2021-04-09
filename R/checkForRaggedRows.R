#' Check whether a tabular csv file contains ragged rows.
#'
#' @param filePath Tabular csv file path
#'
#' @return An S4 CheckResult object containing:
#' @slot name Name of this check
#' @slot pass TRUE if and only if file contains no ragged rows
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data Empty list (for now)
#'
#' @author Logan Lim, Derek Beaton, Jedid Ahn
#' @export
#'
checkForRaggedRows <- function(filePath){
  flaggedMsgs <- character()
  seps <- rep(",", length(filePath))

  ### THIS IS NOT A THOROUGH VALIDATION TOOL. WE NEED SOMETHING TO CHECK FOR CONSISTENT QUOTING...
  ## no header so I can read the whole file.
  tryCatch.res <- tryCatch(file.in <- utils::read.table(text = readLines(filePath, warn = FALSE), sep = seps,
                                                 colClasses = "character",
                                                 header = F, quote = "\""),
                           error = function(e) e, warning = function(w) w)

  ## by reading the data in this way, it will catch when quotes are inconsistently used.
  if (class(tryCatch.res)[1] != "data.frame"){
    if (methods::is(tryCatch.res) == "simpleWarning" | methods::is(tryCatch.res) == "simpleError"){
      line <- paste("The file contains ragged rows; please verify.")
      flaggedMsgs <- c(flaggedMsgs, line)
    }
  }


  pass = T
  if (length(flaggedMsgs) > 0){
    pass = F
  }
  return (checkForRaggedRowsResult(
    name = "checkForRaggedRows",
    pass = pass,
    msg = flaggedMsgs,
    data = list()
    ))
}


#' An S4 subclass of CheckResult for checkForRaggedRows.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkForRaggedRowsResult <- setClass("checkForRaggedRowsResult",
                                     contains = "CheckResult")

# [END]
