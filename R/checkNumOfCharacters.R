#' Check whether a data frame contains less than k characters in each cell.
#'
#' @param df A data frame
#' @param k Optional parameter signifying the max number of characters allowed.
#' Default is 200 characters.
#'
#' @return An S4 CheckResult object containing:
#' @slot name Name of this check
#' @slot pass TRUE if and only if data frame contains less than k characters
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#' - `cols_violated`: Column numbers associated with number of characters violation
#'
#' @author Jedid Ahn, Logan Lim
#' @export
#'
checkNumOfCharacters <- function(df, k = 200){
  flaggedMsgs <- character()
  columnNames <- colnames(df)
  colNums <- c()

  # Convert to empty character if NA's found to proceed with check.
  if (any(is.na(df))){
    df[is.na(df)] <- ""
  }

  for (name in columnNames){
    offendingItems <- nchar(df[ , name ]) > k
    if (any(offendingItems)){
      flaggedMsgs <- c(flaggedMsgs,
                       paste("The data.frame has content that contains more than",
                             k, "characters at column", name, "index",
                             which(offendingItems)))
      colNums <- c(colNums, grep(name, columnNames))
    }
  }


  pass <- T
  if (length(flaggedMsgs) > 0){
    pass <- F
  }
  return(checkNumOfCharactersResult(
    name = "checkNumOfCharactersResult",
    pass = pass,
    msg = flaggedMsgs,
    data = list(cols_violated = colNums)
    ))
}


#' An S4 subclass of CheckResult for checkNumOfCharacters.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkNumOfCharactersResult <- setClass("checkNumOfCharactersResult",
                                       contains = "CheckResult")

# [END]
