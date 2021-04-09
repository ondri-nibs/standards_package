#' Check data frame for duplicate column names (case insensitive).
#'
#' @param df A data frame
#'
#' @return An S4 CheckResult object with contents:
#' @slot name Name of this check
#' @slot pass TRUE if and only if data frame contains no duplicate column names
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#' - `duplicated_cols`: Duplicate column names
#'
#' @author Logan Lim, Jedid Ahn
#' @export
#'
checkForColumnNameDuplicates <- function(df){
  flaggedMsgs <- character()
  namesChecked <- character()
  duplicateColumnNames <- c()

  # Convert column names to uppercase for case insensitive comparison.
  columnNames <- toupper(colnames(df))
  pass <- T

  if(!inherits(df, "data.frame")){
    errstr <- paste("Object df supplied to checkForColumnNameDuplicates",
                    "is not a data.frame. Class:", class(df))

    return(checkForColumnNameDuplicatesResult(
      name = "checkForColumnNameDuplicates",
      pass = F,
      msg = errstr,
      data = list()
      ))
  }

  for (name in columnNames){
    if (!(name %in% namesChecked)){
      numberOfDuplicates <- length(which(columnNames == name))

      if (numberOfDuplicates > 1){
        colNums <- grep(name, columnNames)
        line <- paste("Column Name Duplicates:", name, "(case insensitive)",
                      "is a column name that is duplicated at column #'s:",
                      paste(colNums, collapse = ", "))
        flaggedMsgs <- c(flaggedMsgs, line)
        pass <- F

        duplicateColumnNames <- c(duplicateColumnNames, name)
      }

      namesChecked <- c(namesChecked, name)
    }
  }

  return (checkForColumnNameDuplicatesResult(
    name = "checkForColumnNameDuplicates",
    pass = pass,
    msg = flaggedMsgs,
    data = list(duplicated_cols = duplicateColumnNames)
    ))
}


#' An S4 subclass of CheckResult for checkForColumnNameDuplicates.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkForColumnNameDuplicatesResult <- setClass("checkForColumnNameDuplicatesResult",
                                               contains = "CheckResult")

# [END]
