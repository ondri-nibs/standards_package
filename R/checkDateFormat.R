#' Check whether an input character vector contains valid date format.
#' A valid date is the following:
#'
#'   YYYYMMMDD, valid years (4 digit number), valid months (JAN to DEC),
#'   and valid days (1-30 or 1-31 depending on the month, 1-28 (for February),
#'   and 1-29 (for February on leap years)).
#'
#' @param dates A character vector of dates.
#'
#' @return An S4 CheckResult object with contents:
#' @slot name Name of this check
#' @slot pass TRUE if and only if all dates are in valid format
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#' - `indices_violated`: Indices associated with date format violation
#'
#' @author Logan Lim, Derek Beaton, Jedid Ahn
#' @export
#'
checkDateFormat <- function(dates){
  flaggedMsgs <- character()
  indices <- c()

  if (class(dates) != "character"){
    line <- "The dates input needs to be a character vector. Cannot proceed with check."
    flaggedMsgs <- c(flaggedMsgs, line)
  }
  else{
    # Exclude and ignore missing codes and blank cells.
    dates <- dates[!grepl("^M_", dates) & !is.na(dates)]

    # Check if the entire column contains missing codes and/or blank cells.
    if (length(dates) == 0){
      line <- "Cannot check date format as all values are missing codes and/or blank cells."
      flaggedMsgs <- c(flaggedMsgs, line)
    }
    else{
      # Convert date strings to date objects.
      dateObjects <- as.Date(dates, format = "%Y%b%d")

      # Check for date objects that turn NA and dates that are not exactly 9 characters long.
      if (any(is.na(dateObjects)) || any(nchar(dates) != 9)){
        indices <- which(is.na(dateObjects) | nchar(dates) != 9)
        line <- paste("The dates either do not contain the correct date format",
                      "YYYYMMMDD or do not contain a valid day, month, or year",
                      "at indices:", paste(indices, collapse = ', '))
        flaggedMsgs <- c(flaggedMsgs, line)
      }
    }

  }


  pass = T
  if (length(flaggedMsgs) > 0){
    pass = F
  }
  return (checkDateFormatResults(
    name = "checkDateFormat",
    pass = pass,
    msg = flaggedMsgs,
    data = list(indices_violated = indices)
    ))
}


#' An S4 subclass of CheckResult for checkDateFormat.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkDateFormatResults <- setClass("checkDateFormatResults",
                                   contains = "CheckResult")

# [END]
