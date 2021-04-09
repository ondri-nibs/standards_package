#' Check whether a tabular csv file is encoded in the broadly accepted formats
#' of ASCII or UTF-8; UTF-8 is preferred and suggested.
#'
#' @param filePath Tabular csv file path
#'
#' @return An S4 CheckResult object with contents:
#' @slot name Name of this check
#' @slot pass TRUE if and only if all encoding in file is valid
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#' - `encoding_probabilities`: Encoding probabilities of the file, if
#' encoding guess was performed.
#' - `cols_w_no_ASCII`: Column numbers with ASCII violations.
#'
#' @author Logan Lim, Derek Beaton, Jedid Ahn
#' @export
#'
checkEncoding <- function(filePath){
  flaggedMsgs <- character()
  cols_w_no_ASCII <- c()

  enc_guess_failed <- F
  # Make sure we know file is found and nothing goes wrong with readr::guess_encoding
  failed_readr_result <- tryCatch({
    enc.guess.res <- readr::guess_encoding(filePath) # If it's not ASCII or UTF-8 it's an error.
    probabilityMatrix <- as.matrix(enc.guess.res)

  }, error = function(cond){
    # Stop the check, make sure user gets the error message
    enc_guess_failed <- T
    checkEncodingResult(
      name = "checkEncoding",
      pass = F,
      msg = cond$message,
      data = list(cond)
      )
  })
  if(inherits(failed_readr_result, "checkEncodingResult")){
    return(failed_readr_result)
  }

  if (!all(enc.guess.res$encoding %in% c("ASCII","UTF-8"))){
    probabilityValues <- character()
    for (index in 1:nrow(probabilityMatrix)){
      probabilityValues <- c(probabilityValues,
                             paste(paste(probabilityMatrix[ index , ]),
                                   collapse = ": "))
    }

    line <- paste("Probability of the", filePath, "file not exclusively ASCII or UTF-8.",
                  "The encoding probabilities are:",
                  paste(probabilityValues, collapse = ", "))
    flaggedMsgs <- c(flaggedMsgs, line)
  }

  # NEW: Provide precise locations of ASCII and UTF-8 check violations.
  df <- utils::read.csv(filePath, stringsAsFactors = FALSE,
                        colClasses = c("character"))
  columnNames <- colnames(df)
  for (name in columnNames){
    if (any(which(stringi::stri_enc_mark(df[ , name]) != "ASCII"))){
      line <- paste("The data.frame object contains non-ASCII characters at column",
                    name, "at row(s)",
                    paste(which(stringi::stri_enc_mark(df[ , name]) != "ASCII"),
                          collapse = ', '))
      cols_w_no_ASCII <- c(cols_w_no_ASCII, grep(name, columnNames))
      flaggedMsgs <- c(flaggedMsgs, line)
    }
  }


  pass = T
  if (length(flaggedMsgs) > 0){
    pass = F
  }
  return (checkEncodingResult(name = "checkEncoding",
    pass = pass,
    msg = flaggedMsgs,
    data = list(encoding_probabilities = enc.guess.res,
                cols_w_no_ASCII = cols_w_no_ASCII)))
}


#' An S4 subclass of CheckResult for checkEncoding.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkEncodingResult <- setClass("checkEncodingResult",
                                contains = "CheckResult")

# [END]
