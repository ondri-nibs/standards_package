#' Check whether a DICT data frame's column labels match in exact order with
#' the column names in the DATA data frame, and that no column labels are
#' duplicated. If not, the column labels corresponding to either of these
#' violations are given through the flagged messages.
#'
#' @param dictDF A data frame representing your data dictionary. Must contain a
#' column \code{dictDF$COLUMN_LABEL} which is your exact columns that you are
#' expecting in \code{dataDF}
#' @param dataDF The data frame whose columns you would like to check against
#' the dictionary data frame
#'
#' @return An S4 CheckResult object with contents:
#' @slot name Name of this check
#' @slot pass TRUE if and only if order is exact and no duplicates are found
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#' - `cols_violated`: Column numbers in the DATA file having names that do
#' not match with their corresponding column label in COLUMN_LABEL column in
#' the DICT file, if any exist
#' - `duplicate_col_labels`: A vector of duplicated column label strings, if
#' any exist
#'
#' @author Jedid Ahn, Logan Lim
#' @export
#'
checkColumnLabels <- function(dictDF, dataDF){
  flaggedMsgs <- character()
  # Get the column names of the data DF for comparison.
  dataColList <- colnames(dataDF)
  # Convert column labels in dict DF to uppercase for case insensitive comparison.
  uppercaseColumnLabels <- toupper(dictDF$COLUMN_LABEL)
  colNums <- NULL

  # 1) COLUMN_LABEL column exists but the number of rows in the DICT file is
  # not equal to the number of columns in the DATA file.
  if (length(dictDF$COLUMN_LABEL) != length(dataColList)){
    line <- paste("The number of column labels in the COLUMN_LABEL column",
                  "in the DICT file is not equal to the number of column",
                  "names in the DATA file.")
    flaggedMsgs <- c(flaggedMsgs, line)
  }

  # 2) Column names in the DATA file do not match with its corresponding column
  # label in COLUMN_LABEL column in the DICT file at the specific index.
  else{
    if (any(dictDF$COLUMN_LABEL != dataColList)){
      colNums <- which(dictDF$COLUMN_LABEL != dataColList)
      line <- paste("The following column #'s in the DATA file have names",
                    "that do not match with their corresponding column label",
                    "in COLUMN_LABEL column in the DICT file:",
                    paste(colNums, collapse = ", "))
      flaggedMsgs <- c(flaggedMsgs, line)
    }
  }


  # 3) Find duplicated column labels (case insensitive) if they exist.
  duplicatedColumnLabels <-
    unique(uppercaseColumnLabels[ duplicated(uppercaseColumnLabels) ])

  if (length(duplicatedColumnLabels) > 0){
    line <- paste("There are column labels in the DICT file that are",
                  "duplicated. They are the following:",
                  paste(duplicatedColumnLabels, collapse = ", "))
    flaggedMsgs <- c(flaggedMsgs, line)

  }


  pass = T
  if (length(flaggedMsgs) > 0){
    pass = F
  }
  return(checkColumnLabelsResult(
    name = "checkColumnLabels",
    pass = pass,
    msg = flaggedMsgs,
    data = list(cols_violated = colNums,
                duplicate_col_labels = duplicatedColumnLabels)
    ))
}


#' An S4 subclass of CheckResult for checkColumnLabels.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkColumnLabelsResult <- setClass("checkColumnLabelsResult",
                                    contains = "CheckResult")

# [END]
