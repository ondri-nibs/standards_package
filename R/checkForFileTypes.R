#' Check for specific file types in directories.
#'
#' @param fileExt Character vector of file types to look for
#' @param dirPath Full directory path
#' @param recursive TRUE if you wish to parse into subdirectories, otherwise FALSE
#'
#' @return An S4 CheckResult object with contents:
#' @slot name Name of this check
#' @slot pass TRUE if and only if file types in fileExt are found in directory
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#' - `matched_names`: File names that match file types given in fileExt
#'
#' @author Jedid Ahn, Logan Lim
#' @export
#'
checkForFileTypes <- function(fileExt, dirPath, recursive = F){
  matchedNames <- c()

  tryCatch({
    fnames <- list.files(path = dirPath, recursive = recursive)
  }, error = function(cond){
    return(checkForFileTypesResult(
      name ="checkForFileTypesNames",
      pass = F,
      msg = cond$message,
      data = list(cond)
      ))
  })

  # If the last token satisfies the file
  for (name in fnames){
    ftokens <- unlist(strsplit(name, "\\."))
    if(utils::tail(ftokens,1) == fileExt){
      matchedNames <- c(matchedNames, name)
    }
  }


  if(length(matchedNames) == 0){
    msg <- paste("No files of type", fileExt, "found in directory", dirPath)
    return (checkForFileTypesResult(
      name = "checkForFileTypesResult",
      pass = F,
      msg = msg,
      data = list()
      ))
  } else {
    msg <- paste("Files found for type", fileExt, "in directory", dirPath)
    return (checkForFileTypesResult(
      name = "checkForFileTypesResult",
      pass = T,
      msg = msg,
      data = list(matched_names = matchedNames)
      ))
  }
}


#' An S4 subclass of CheckResult for checkForFileTypes.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkForFileTypesResult <- setClass("checkForFileTypesResult",
                                    contains = "CheckResult")

# [END]
