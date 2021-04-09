#' Check that directory names use alphanumerics and underscores, and make
#' sure first character is not a digit or underscore.
#'
#' Check that all strings are named strictly using alphanumeric characters
#' and underscores. In addition, check that the strings names do not start
#'  with digits or underscores.
#'
#' @param dirNames A character vector of names that we want to check.
#'
#' @return An S4 CheckResult object with contents:
#' @slot name Name of this check
#' @slot pass TRUE if and only if all directory names contain valid syntax
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#' - `names_violated`: Names that failed the check as character vector
#'
#' @author Jedid Ahn, Logan Lim
#' @export
#'
checkDirNames <- function(dirNames){
  flaggedMsgs <- character()
  namesViolated <- c()

  # Test #1: Alphanumeric characters and underscores only.
  if (!all(grepl("^[a-zA-Z0-9_]+$", dirNames))){
    indices <- which(!grepl("^[a-zA-Z0-9_]+$", dirNames))
    line <- paste("The following names contain characters other than",
                  "alphanumeric and underscores:",
                            paste(dirNames[indices], collapse = ", "))
    flaggedMsgs <- c(flaggedMsgs, line)
    namesViolated <- c(namesViolated, dirNames[indices])
  }

  # Test #2: Directory name does not start with digits or underscores.
  if (!all(grepl("^[[:alpha:]]$", substring(dirNames, 1, 1)))){
    indices <- which(!grepl("^[[:alpha:]]$", substring(dirNames, 1, 1)))
    line <- paste("The following names start with digits or underscores:",
                  paste(dirNames[indices], collapse = ", "))
    flaggedMsgs <- c(flaggedMsgs, line)
    namesViolated <- c(namesViolated, dirNames[indices])
  }

  # Test #3: Message that uppercase letters only are preferred.
  # Check if any column names are not fully capitalized.
  uppercaseDirNames <- toupper(dirNames)
  if (any(uppercaseDirNames != dirNames)){
    indices <- which(uppercaseDirNames != dirNames)
    line <- paste("The following names contain lowercase letters.",
                  paste(dirNames[indices], collapse = ", "))
    flaggedMsgs <- c(flaggedMsgs, line)
    namesViolated <- c(namesViolated, dirNames[indices])
  }


  pass <- T
  if (length(flaggedMsgs) > 0){
    pass <- F
  }
  return(checkDirNamesResult(
    name = "checkDirNames",
    pass = pass,
    msg = flaggedMsgs,
    data = list(names_violated = namesViolated)
    ))
}


#' An S4 subclass of CheckResult for checkDirNames.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkDirNamesResult <- setClass("checkDirNamesResult",
                                contains = "CheckResult")

# [END]
