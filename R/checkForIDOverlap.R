#' Check for participant ID overlap between 2 data frames. In ONDRI case,
#' the participant IDs in the DATA and MISSING files should be checked for
#' potential overlap.
#'
#' @param df1 Data frame 1, such as a DATA data frame
#' @param df2 Data frame 2, such as a MISSING data frame
#'
#' @return An S4 CheckResult object containing:
#' @slot name Name of this check
#' @slot pass TRUE if and only if no participant IDs overlap
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#' - `overlapping_ids`: Vector of participant IDs that overlap.
#'
#' @author Jedid Ahn
#' @export
#'
checkForIDOverlap <- function(df1, df2){
  flaggedMsgs <- character()

  if (!("SUBJECT" %in% colnames(df1) & "SUBJECT" %in% colnames(df2))){
    if (!("SUBJECT" %in% colnames(df1))){
      line <- paste("SUBJECT column not found in first data frame input.",
                    "Cannot move forward with check.")
      flaggedMsgs <- c(flaggedMsgs, line)
    }

    if (!("SUBJECT" %in% colnames(df2))){
      line <- paste("SUBJECT column not found in second data frame input.",
                    "Cannot move forward with check.")
      flaggedMsgs <- c(flaggedMsgs, line)
    }
  }
  else{
    overlappingIDs <- intersect(df1$SUBJECT, df2$SUBJECT)
  }


  if (length(overlappingIDs) == 0){
    overlappingIDs <- NULL
    pass <- T
  }
  else{
    line <- paste("The following participant IDs overlap between both data frames:",
                  paste(overlappingIDs, collapse = ", "))
    flaggedMsgs <- c(flaggedMsgs, line)
    pass <- F
  }

  return (checkForIDOverlapResults(
    name = "checkForIDOverlapResults",
    pass = pass,
    msg = flaggedMsgs,
    data = list(overlapping_ids = overlappingIDs)
  ))
}


#' An S4 subclass of CheckResult for checkForIDOverlap.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkForIDOverlapResults <- setClass("checkForIDOverlapResults",
                                     contains = "CheckResult")

# [END]
