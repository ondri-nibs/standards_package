#' Compare column labels in the DICT data frame and the column names in the
#' DATA data frame.
#'
#' @param dictDF Dictionary data frame
#' @param dataDF Data data frame
#'
#' @return An S4 CheckResult object containing:
#' @slot name Name of this check
#' @slot pass TRUE if and only if column labels and column names match
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#' - `missing_from_data`: Column labels in the DICT file that are not in the DATA file
#' - `missing_from_dict`: Column names in the DATA file that are not in the DICT file
#'
#' @author Jedid Ahn, Logan Lim
#' @export
#'
compareDICTColumnLabels <- function(dictDF, dataDF){
  flaggedMsgs <- character()

  dictColumnLabels <- dictDF$COLUMN_LABEL
  dataColumnNames <- colnames(dataDF)

  # This is all column labels in the DICT file that are not in the DATA file.
  missingFromData <- setdiff(dictColumnLabels, dataColumnNames)
  # This is all column names in the DATA file that are not in the DICT file.
  missingFromDict <- setdiff(dataColumnNames, dictColumnLabels)

  pass <- T
  if (length(missingFromData) > 0){
    line <- paste("Column labels that are in the DICT file but not in the DATA file:",
                  paste(missingFromData, collapse = ", "))
    flaggedMsgs <- c(flaggedMsgs, line)
    pass <- F
  }

  if (length(missingFromDict) > 0){
    line <- paste("Column labels that are in the DATA file but not in the DICT file:",
                  paste(missingFromDict, collapse = ", "))
    flaggedMsgs <- c(flaggedMsgs, line)
    pass <- F
  }

  return (compareDICTColumnLabelsResult(
    name = "compareDICTColumnLabelsResult",
    pass = pass,
    msg = flaggedMsgs,
    data = list(missing_from_data = missingFromData,
                missing_from_dict = missingFromDict)
    ))
}


#' An S4 subclass of CheckResult for compareDICTColumnLabels.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
compareDICTColumnLabelsResult <- setClass("compareDICTColumnLabelsResult",
                                          contains = "CheckResult")

# [END]
