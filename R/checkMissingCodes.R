#' Check whether a vector contains valid missing codes wherever a
#' cell starts with "M_".
#'
#' @param dataVec A vector of data, such as a row or a column in a data frame.
#' @param validMissingCodes An optional vector of valid missing codes, with
#' the default value representing ONDRI missing codes.
#'
#' @return An S4 CheckResult object containing:
#' @slot name Name of this check
#' @slot pass TRUE if and only if vector contains valid missing codes
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#' - `indices_violated`: Indices associated with missing code violation
#'
#' @author Logan Lim, Derek Beaton, Jedid Ahn
#' @export
#'
checkMissingCodes <- function(dataVec,
                              validMissingCodes = c("M_CB", "M_PI", "M_VR",
                                                    "M_AE", "M_DNA", "M_TE",
                                                    "M_NP", "M_ART", "M_TBC",
                                                    "M_OTHER")){
  flaggedMsgs <- character()
  allCodes <- dataVec[grep("^M_", dataVec)]
  indices <- c()

  if (class(dataVec) != "character"){
    line <- "The input needs to be a character vector. Cannot proceed with check."
    flaggedMsgs <- c(flaggedMsgs, line)
  }
  else{
    if (any(!(allCodes %in% validMissingCodes))){
      indices_sub <- which(!(allCodes %in% validMissingCodes))
      indices <- which(dataVec %in% allCodes[indices_sub])
      line <- paste("There exists invalid missing codes at indices:",
                    paste(indices, collapse = ', '))
      flaggedMsgs <- c(flaggedMsgs, line)
    }
  }


  pass = T
  if (length(flaggedMsgs) > 0){
    pass = F
  }
  return (checkMissingCodesResult(name = "checkMissingCodes",
    pass = pass,
    msg = flaggedMsgs,
    data = list(indices_violated = indices)))
}

#' An S4 subclass of CheckResult for checkMissingCodes.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkMissingCodesResult <- setClass("checkMissingCodesResult",
                                    contains = "CheckResult")

# [END]
