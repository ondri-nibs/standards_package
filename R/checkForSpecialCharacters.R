#' Check for special characters in a data frame.
#'
#' @param df A data frame
#'
#' @return An S4 CheckResult object containing:
#' @slot name Name of this check
#' @slot pass TRUE if and only if data frame contains no special characters
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#' - `cols_violated`: Column numbers associated with special character violation
#'
#' @author Logan Lim, Derek Beaton, Jedid Ahn
#' @export
#'
checkForSpecialCharacters <- function(df){
  flaggedMsgs <- character()
  colNums <- c()
  columnNames <- colnames(df)

  # Convert all column classes to character.
  df_char <- data.frame(sapply(df, as.character), stringsAsFactors = FALSE)
  df_char[is.na(df_char) | df_char == ""] <- "BLANK"

  for (name in columnNames){
    if (any(!grepl("^[a-zA-Z0-9_.()-/=:; ]+$", df_char[ , name]))){
      rows <- grep("^[a-zA-Z0-9_.()-/=:; ]+$", df_char[ , name], invert = TRUE)
      line <- paste("The data.frame object contains special characters that",
                    "are prohibited at column", name, "at row(s)",
                    paste(rows, collapse = ', '))
      colNums <- c(colNums, grep(name, columnNames))
      flaggedMsgs <- c(flaggedMsgs, line)
    }
  }


  pass = T
  if (length(flaggedMsgs) > 0){
    pass = F
  }
  return (checkForSpecialCharactersResult(
    name = "checkForSpecialCharacters",
    pass = pass,
    msg = flaggedMsgs,
    data = list(cols_violated = colNums)
    ))
}


#' An S4 subclass of CheckResult for checkForSpecialCharacters.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkForSpecialCharactersResult <- setClass("checkForSpecialCharactersResult",
                                            contains = "CheckResult")

# [END]
