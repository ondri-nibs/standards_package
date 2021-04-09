#' Check data frame for commas.
#'
#' @param df A data frame
#'
#' @return An S4 CheckResult object with contents:
#' @slot name Name of this check
#' @slot pass TRUE if and only if data frame contains no commas
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#' - `cols_violated`: column numbers associated with comma violation
#'
#' @author Logan Lim, Jedid Ahn
#' @export
#'
checkForCommas <- function(df){
  flaggedMsgs <- character()
  columnNames <- colnames(df)
  colsViolated <- c()

  pass <- T
  for (name in columnNames){
    has_commas_logical <- grepl(",", df[ , name ])
    if (any(has_commas_logical)){
      flaggedMsgs <- c(flaggedMsgs,
                       paste("The column", name, "contains commas at row(s)",
                             paste(which(has_commas_logical), collapse = ", ")))
      colsViolated <- c(colsViolated, grep(name, columnNames))
    }
  }


  if (length(flaggedMsgs) > 0){
    pass <- F
  }

  return(checkForCommasResult(
    name = "checkForCommas",
    pass = pass,
    msg = flaggedMsgs,
    data = list(cols_violated = colsViolated)
    ))
}


#' An S4 subclass of CheckResult for checkForCommas.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkForCommasResult <- setClass("checkForCommasResult",
                                 contains = "CheckResult")

# [END]
