#' Check the ^M_ pattern in a data frame and count the number of occurrences
#' of each unique code.
#'
#' @param df A data frame
#'
#' @return An S4 CheckResult object containing:
#' @slot name Name of this check
#' @slot pass TRUE if and only if data frame contains an M_ pattern
#' @slot msg Character of details of the pattern search
#' @slot data List of
#' - `unique_codes`: Vector outlining all unique codes with an ^M_ pattern.
#' - `tally`: Table outlining the number of occurrences of each unique code.
#'
#' @author Logan Lim, Derek Beaton, Jedid Ahn
#' @export
#'
checkM_Pattern <- function(df){
  flaggedMsgs <- character()
  uniqueCodes <- character()
  tally <- character()

  allCodes <- unlist(sapply(df, function(x) x[grep("^M_", x)]))

  if (length(allCodes) == 0){
    line <- paste("The data frame contains no ^M_ pattern. No other results are available.")
    flaggedMsgs <- c(flaggedMsgs, line)
    pass <- F

  }
  else{
    line <- paste("The data frame contains an ^M_ pattern, which occurs a total of",
                  length(allCodes), "times in the data.")
    flaggedMsgs <- c(flaggedMsgs, line)

    uniqueCodes <- unique(allCodes)
    tally <- table(allCodes)
    pass <- T
  }


  return (checkM_PatternResult(
    name = "checkM_Pattern",
    pass = pass,
    msg = flaggedMsgs,
    data = list(unique_codes = uniqueCodes, tally = tally)
    ))
}

#' An S4 subclass of CheckResult for checkM_Pattern.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkM_PatternResult <- setClass("checkM_PatternResult",
                                 contains = "CheckResult")

# [END]
