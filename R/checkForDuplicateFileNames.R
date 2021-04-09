#' Check non-tabular directory for duplicate files in different leveled folders.
#' Ex: Duplicate file name in level 1 and level 2.
#'
#' @param dirPath Full directory path in character format
#'
#' @return An S4 CheckResult object with contents:
#' @slot name Name of this check
#' @slot pass TRUE if and only if non-tabular directory contains no
#' duplicate file names
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#' - `file_names`: File names that are duplicated.
#'
#' @author Roberto Lentini, Logan Lim
#' @export
#'
checkForDuplicateFileNames <- function(dirPath){
  flaggedMsgs <- character()
  basenameList <- c()
  fileNames <- c()

  # List of all the file names found in the package
  tryCatch({
    allFileNames <- list.files(path = dirPath, recursive = TRUE)

  }, error = function(cond){
    return(checkForDuplicateFileNamesResult(
      name = "checkForDuplicateFileNames",
      pass = F,
      msg = cond$message,
      data = list(cond)
      ))
  })

  # Warning message if there is a duplicate file name in the folder
  for (file in allFileNames){
    basenameList <- c(basename(file), basenameList)
    occurrenceTable <- table(basenameList)
  }

  for (name in names(occurrenceTable)){
    if (occurrenceTable[name] > 1){
      line <- paste("Please note that the file name", name, "is used multiple times.")
      flaggedMsgs <- c(flaggedMsgs, line)
      fileNames <- c(fileNames, name)
      }
  }


  pass <- T
  if (length(flaggedMsgs) > 0){
    pass <- F
  }
  return (checkForDuplicateFileNamesResult(
    name = "checkForDuplicateFileNames",
    pass = pass,
    msg = flaggedMsgs,
    data = list(file_names = fileNames)
    ))
}


#' An S4 subclass of CheckResult for checkForDuplicateFileNames.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkForDuplicateFileNamesResult <- setClass("checkForDuplicateFileNamesResult",
                                             contains = "CheckResult")

# [END]
