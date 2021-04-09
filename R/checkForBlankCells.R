#' Check for blank cells and NA in a data frame.
#'
#' @param df A data frame
#'
#' @return An S4 CheckResult object with contents:
#' @slot name Name of this check
#' @slot pass TRUE if and only if data frame contains no blank cells
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#'  `cols_violated`: column numbers containing a blank cell
#'
#' @author Logan Lim, Jedid Ahn
#' @export
#'
checkForBlankCells <- function(df){
  flaggedMsgs <- character()

  # Check that we have a data.frame
  if(!inherits(df, "data.frame")){
    # Return failing condition
    errstr <- paste("Object df supplied to checkForBlankCells",
                    "is not a data.frame. Class:", class(df))
    return(checkForBlankCellsResult(
      name = "checkForBlankCells",
      pass = F,
      msg = errstr,
      data = list()
      ))
  }

  possibleNAs <- c("NA", "N.A", ".", "N.A.", "N_A", "N/A")

  # Create duplicate df.
  df <- data.frame(lapply(df, as.character), stringsAsFactors = FALSE)
  selection <- colnames(df) == ""
  colnames(df)[ selection ] <- "NO_TITLE"
  columnNames <- colnames(df)
  colNums <- c() # A vector of the column indices containing NA

  # 1) Blank cells.
  for (name in columnNames){
    # A logical vector of which rows are blank
    blankLogical <- nchar(df[ , name ]) == 0 & !is.na(df[ , name ])
    if (any(blankLogical)){
      line <- paste("The data.frame object contains blank cells at column",
                     name, "at row(s)", paste(which(blankLogical), collapse = ', '))

      colNums <- c(colNums, grep(name, columnNames))
      flaggedMsgs <- c(flaggedMsgs, line)
    }
    # 2) NA (any versions) cells.
    # A logical vector of which rows are NA
    naLogical <- is.na(df[ , name ]) | toupper(df[ , name ]) %in% possibleNAs
    if (any(naLogical)){
      line <- paste("The file contains instance(s) of NA at column",
                    name, "at row(s)", paste(which(naLogical), collapse = ', '))
      colNums <- c(colNums, grep(name, columnNames))
      flaggedMsgs <- c(flaggedMsgs, line)
  }

  }

  pass <- T
  if (length(flaggedMsgs) > 0){
    pass <- F
  }
  return(checkForBlankCellsResult(
    name ="checkForBlankCells",
    pass = pass,
    msg = flaggedMsgs,
    data = list(cols_violated = colNums)
    ))
}


#' An S4 subclass of CheckResult for checkForBlankCells.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkForBlankCellsResult <- setClass("checkForBlankCellsResult",
                                     contains="CheckResult")

# [END]
