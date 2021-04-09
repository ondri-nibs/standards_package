#' Check data frame for proper column name syntax.
#'
#' Check whether a data frame contains proper encapsulation, such
#' that all data cells DO NOT have the following:
#'   1) Double quotes on 1 side only.
#'   2) Double quotes within a data cell.
#'   3) No single quotes unless it is an apostrophe.
#'
#' @param df A data frame
#'
#' @return An S4 CheckResult object with contents:
#' @slot name Name of this check
#' @slot pass TRUE if and only if data frame contains no quote violations
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#' - `cols_violated`: Column numbers associated with encapsulation violation
#'
#' @author Jedid Ahn, Logan Lim
#' @export
#'
checkForEncapsulation <- function(df){
  flaggedMsgs <- character()
  columnNames <- colnames(df)

  # Make sure we are getting a data frame
  if(!inherits(df, "data.frame")){
    errstr = paste("Argument 'df' supplied to checkForEncapsulation",
                   "is not a data.frame. Class:", class(df))
    return(checkForEncapsulationResult(
      name = "checkForEncapsulation",
      pass = F,
      msg = errstr,
      data = list()
      ))
  }
  pass <- T
  colsViolated <- c()

  for (name in columnNames){
    # 1) Check for double quotes on 1 side only.
    if (any(xor(grepl("^\"$", substring(df[ , name ], 1, 1)),
                grepl("^\"$", substring(df[ , name ], nchar(df[ , name ]),
                                        nchar(df[ , name ])))))
        ){
      indices <- which(xor(grepl("^\"$", substring(df[ , name ], 1, 1)),
                           grepl("^\"$", substring(df[ , name ], nchar(df[ , name ]),
                                                   nchar(df[ , name ])))))

      line <- paste("Content in column", name, "has double quotes on 1 side",
                    "only at indices:", indices)
      flaggedMsgs <- c(flaggedMsgs, line)
      colsViolated <- c(colsViolated, grep(name, columnNames))
    }


    # 2) Check for double quotes within data cell.
    if (any(grepl("\"", substring(df[ , name ], 2, nchar(df[ , name ]) - 1)))){
      indices <- which(grepl("\"", substring(df[ , name ], 2, nchar(df[ , name ]) - 1)))

      line <- paste("Content in column", name, "has double quotes at indices:",
                    indices)
      flaggedMsgs <- c(flaggedMsgs, line)
      colsViolated <- c(colsViolated, grep(name, columnNames))
    }


    # 3) Check for single quotes within data cell.
    if (any(grepl("'", substring(df[ , name ], 2, nchar(df[ , name ]) - 1)))){
      indices <- which(grepl("'", substring(df[ , name ], 2, nchar(df[ , name ]) - 1)))

      line <- paste("Content in column", name, "has single quotes at the",
                    "following indices:", indices,
                    "Single quotes are allowed but not recommended,",
                    "unless it is an apostrophe.")
      flaggedMsgs <- c(flaggedMsgs, line)
      colsViolated <- c(colsViolated, grep(name, columnNames))
    }
  }


  if (length(flaggedMsgs) > 0){
    pass <- F
  }
  return (checkForEncapsulationResult(
    name = "checkForEncapsulation",
    pass = pass,
    msg = flaggedMsgs,
    data = list(cols_violated = colsViolated)
    ))
}


#' An S4 subclass of CheckResult for checkForEncapsulation.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkForEncapsulationResult <- setClass("checkForEncapsulationResult",
                                        contains = "CheckResult")

# [END]
