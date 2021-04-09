#' Check whether a tabular csv file contains special values such as NaN
#' (not a number), Inf (infinity), -Inf (negative infinity), or NULL (no value).
#'
#' @param filePath Tabular csv file path
#'
#' @return An S4 CheckResult object containing:
#' @slot name Name of this check
#' @slot pass TRUE if and only if file contains no whitespaces
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#' - `cols_violated`: Column numbers associated with special values violation
#'
#' @author Logan Lim, Jedid Ahn
#' @export
#'
checkForSpecialValues <- function(filePath){
  flaggedMsgs <- character()

  # Create data DF with columns of type numeric as of type character.
  tryCatch({
    dataDF <- utils::read.csv(filePath, stringsAsFactors = FALSE,
                              colClasses = "character")
  }, error = function(cond){
    return(checkForSpecialValuesResult(
      name = "checkForSpecialValues",
      pass = F,
      msg = cond$message,
      data = list(cond)
      ))
  })
  dataDF <- convertDataFrame(dataDF)
  columnNames <- colnames(dataDF)
  colNums <- c()

  specialValues <- c("NAN", "INF", "-INF", "NULL")

  for (name in columnNames){
    if (any(is.nan(dataDF[ , name ]) | is.infinite(dataDF[ , name ]) |
            is.null(dataDF[ , name ]) | (toupper(dataDF[ , name ])
                                         %in% specialValues))){
      flaggedMsgs <- paste("The data file contains special values",
                           "(NaN, Inf, -Inf, or NULL).")
      colNums <- c(colNums, grep(name, columnNames))
    }
  }


  pass <- T
  if (length(flaggedMsgs) > 0){
    pass <- F
  } else {
    flaggedMsgs <- paste("No special values (NaN, Inf, -Inf, or NULL) were",
                         "found in file", filePath)
  }
  return(checkForSpecialValuesResult(
    name = "checkForSpecialValues",
    pass = pass,
    msg = flaggedMsgs,
    data = list(cols_violated = colNums)
    ))
}


#' An S4 subclass of CheckResult for checkForSpecialValues.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkForSpecialValuesResult <- setClass("checkForSpecialValues",
                                        contains = "CheckResult")

# [END]
