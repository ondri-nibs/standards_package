#' Check for leading or trailing whitespaces in a data frame.
#'
#' @param df A data frame
#'
#' @return An S4 CheckResult object containing:
#' @slot name Name of this check
#' @slot pass TRUE if and only if data frame contains no whitespaces
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#' - `cols_violated`: Column numbers associated with whitespace violation
#'
#' @author Logan Lim, Jedid Ahn
#' @export
#'
checkForWhiteSpaces <- function(df){
  flaggedMsgs <- character()
  colNums <- c()

  columnNames <- colnames(df)

  for (name in columnNames){
    if (any(grepl("^\\s$", substring(df[ , name ], 1, 1)) |
            grepl("^\\s$", substring(df[ , name ], nchar(df[ , name ]),
                                     nchar(df[ , name ]))))
        ){
      flaggedMsgs <- "The data.frame contains leading or trailing white spaces."
      colNums <- c(colNums, grep(name, columnNames))
    }
  }


  pass <- T
  if (length(flaggedMsgs) > 0){
    pass <- F
  } else {
    flaggedMsgs <- "No leading or trailing whitespaces found."
  }
  return(checkForWhiteSpacesResult(
    name = "checkForWhiteSpaces",
    pass = pass,
    msg = flaggedMsgs,
    data = list(cols_violated = colNums)
    ))
}


#' An S4 subclass of CheckResult for checkForWhiteSpaces.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkForWhiteSpacesResult <- setClass("checkForWhiteSpacesResult",
                                      contains = "CheckResult")

# [END]
