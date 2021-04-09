

# NOTES ABOUT CheckResult & General design --------------------------------

# The basic heuristic I want to go for is:
# checkFunction(.) -> CheckResult
# Each function should have it's own CheckResult subclass though, so
#   we can freely manipulate the data returned by the check.

# The data slot will be a list of arbitrary elements
#   HOWEVER, every class that contains CheckResult must implement a *data.of*
#   generic function that gives this data as a data.frame that ALWAYS
#   CONTAINS THE SAME COLUMNS, regardless if there is data or not in the object.
#   e.g. data.of(checkEncoding(dfFile))
# Will also contain a has.data generic function that returns TRUE if the check
#   has returned some type of data.

#


# CLASS DEFINITION --------------------------------------------------------

#' The base class for the results of a check function.
#'
#' @slot name *character.* Name of the check function that returned this object.
#' @slot pass *logical.* Whether or not the check passed/failed.
#' @slot msg *character.* A message associated with pass/fail value. Gives more
#'     information after the check.
#' @slot data *list.* Any assorted data returned from the check.
#'
#' @import methods
#' @export
CheckResult <- setClass("CheckResult",
    slots = list(name = "character",
                 pass = "logical",
                 msg = "character",
                 data = "list")
)

# HAS.DATA GENERIC --------------------------------------------------------
setGeneric("has.data", valueClass = "logical",
          def = function(check.res){
            standardGeneric("has.data")
          })

has.data.CheckResult <- function(check.res){
  return (length(check.res@data) > 0)
}

setMethod("has.data",
          def = has.data.CheckResult,
          signature = c(check.res = "CheckResult"))


# GET.DATA GENERIC --------------------------------------------------------

setGeneric("get.data", valueClass = "data.frame",
          def = function(check.res){
            standardGeneric("get.data")
          })

# From a single CheckResult object, return the data slot as a data.frame
# We assume that every object inheriting CheckResult will override this when necessary
get.data.CheckResult <- function(check.res){
  if(!is(check.res, "CheckResult")){
    errstr = paste("Object check.res of get.data must be and only be",
                   "a CheckResult object. Was given an object of type:",
                   class(check.res))
    stop(errstr)
  }
  return(data.frame(check.res@data, stringsAsFactors = FALSE))
}


setMethod("get.data",
          def = get.data.CheckResult,
          signature = c(check.res = "CheckResult"))

#' Returns CheckResult as data.frame
#'
#' @param ... CheckResult objects
#'
#' This function turns a list of CheckResult objects into a data.frame with
#' columns corresponding to the slots of CheckResults
#' CheckResult@data is not included in this data.frame since it can be a list
#' of arbitrary types. To get CheckResult@data use the get.data(CheckResult) method.

#' @export
#'
as.data.frame.CheckResult <- function(...){
  check.results <- list(...)

  res.df <- data.frame()
  # This should be a data.frame of (name, pass, msg, data)
  colnames(res.df) <- slotNames("CheckResult")
  res.df$pass <- sapply(check.results, function(x) x@name)
  res.df$msg <- sapply(check.results, function(x) x@pass)
  res.df$pass <- sapply(check.results, function(x) x@msg)

  return (res.df)
}

#' Throw an error if check fails
#'
#' @param check.res Check function
#'
#' If CheckResult@pass is FALSE, then throw an error with message =
#' CheckResult@msg If check.res is an object from [combineChecks] then an error
#' will be thrown if any of them fail. Also throws error if object is not of
#' type CheckResult. Otherwise, return check.res.
#' @export
stopIfFail <- function(check.res){
  if(!inherits(check.res, "CheckResult")){
    stop("ondristandards::stopIfFail cannot be used with an object that is not of type CheckResult.")
  }
  did_not_pass <- !check.res@pass
  if(any(did_not_pass)){
    errstr <- paste("The following check has failed:",
                    check.res@name[which(did_not_pass)],
                    "\nMessage:", check.res@msg[which(did_not_pass)])
    stop(errstr)
  }
  return(check.res)
}

#' 'Concatenate' CheckResult objects for compound checks.
#'
#' @param ... CheckResult objects
#'
#' @return New CheckResult objects with slots that are a concatenation of
#' slots of multiple CheckResult objects.
#' If one CheckResult object is given, then it is given back.
#' If two or more are given, their `name`, `pass`, `msg`, `data` slots are
#' all combined into single vectors on one returned CheckResult object
#'
#' @export
combineChecks <- function(...){
  check.res <- list(...)
  # Make sure these are all CheckResult objects
  for (c.res in check.res){
    if(!inherits(c.res, "CheckResult")){
      errstr <- "Not all objects passed to combineChecks are of type CheckResult."
      stop(errstr)
    }
  }

  # Collect all of the data of the individual checks
  data <- list()
  name <- c()
  pass <- c()
  msg <- c()
  if(length(check.res) != 0){
    for (c.res in check.res) {
      name <- c(name, c.res@name)
      pass <- c(pass, c.res@pass)
      msg <- c(msg, paste(c.res@msg))
      data[[paste0(c.res@name, "@data")]] <- ifelse(length(c.res@data) == 0,
                                                  list(), c.res@data)
    }
  } else{
    return(CheckResult(name = "", pass = F, msg = "", data = list()))
  }

  return(CheckResult(name = name, pass = pass, msg = msg, data = data))

}
