#' Check data frame for proper column name syntax.
#' This includes: \cr 1) Containing alphanumeric characters and underscores
#' only. \cr 2) Starting with an alpha character only. \cr 3) All letters
#' being fully capitalized.
#'
#' @param df A data frame
#'
#' @return An S4 CheckResult object with contents:
#' @slot name Name of this check
#' @slot pass TRUE if and only if all column names contain valid syntax
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#' - `cols_violated`: Column numbers which violate syntax rules
#'
#' @author Jedid Ahn, Logan Lim
#' @export
#'
checkColumnNameSyntax <- function(df){
  flaggedMsgs <- character()
  columnNames <- colnames(df)
  allColNums <- c()

  # Check if any column names do not contain alphanumeric and underscores only.
  if (!all(grepl("^[a-zA-Z0-9_]+$", columnNames))){
    colNums <- which(!grepl("^[a-zA-Z0-9_]+$", columnNames))
    line <- paste("The following column #'s have names that need to contain",
                  "alphanumeric characters and underscores only:",
                  paste(colNums, collapse = ", "))
    flaggedMsgs <- c(flaggedMsgs, line)
    allColNums <- c(allColNums, colNums)
  }


  # Check if any column names do not start with an alpha character.
  if (!all(grepl("^[[:alpha:]]$", substring(columnNames, 1, 1)))){
    colNums <- which(!grepl("^[[:alpha:]]$", substring(columnNames, 1, 1)))
    line <- paste("The following column #'s have names that need to start",
                  "with an alpha character:",
                  paste(colNums, collapse = ", "))
    flaggedMsgs <- c(flaggedMsgs, line)
    allColNums <- c(allColNums, colNums)
  }

  # Check if any column names are not fully capitalized.
  uppercaseColumnNames <- toupper(columnNames)
  if (any(uppercaseColumnNames != columnNames)){
    colNums <- which(uppercaseColumnNames != columnNames)
    line <- paste("The following column #'s have names that contain lowercase",
                  "letters. It is recommended that all of its letters be",
                  "fully capitalized:", paste(colNums, collapse = ", "))
    flaggedMsgs <- c(flaggedMsgs, line)
    allColNums <- c(allColNums, colNums)
  }


  pass = T
  if (length(flaggedMsgs) > 0){
    pass = F
  }

  return (checkColumnNameSyntaxResult(
    name = "checkColumnNameSyntax",
    pass = pass,
    msg = flaggedMsgs,
    data = list(cols_violated = allColNums)
    ))
}


#' An S4 subclass of CheckResult for checkColumnNameSyntax.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkColumnNameSyntaxResult <- setClass("checkColumnNameSyntaxResult",
                                        contains = "CheckResult")

# [END]
