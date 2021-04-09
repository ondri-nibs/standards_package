#' Compare the file names in the README file and the files in the directory
#' containing the README file.
#'
#' @param readmeDF README data frame
#' @param dirPath Full directory path containing data package files
#'
#' @return An S4 CheckResult object containing:
#' @slot name Name of this check
#' @slot pass TRUE if and only if file names and directory files match
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#' - `missing_from_dir`: File names in the directory that are not in the README file
#' - `missing_from_csv`: File names in the README file that are not in the directory
#'
#' @author Jedid Ahn, Logan Lim, Jeremy Tanuan
#' @export
#'
compareREADMEFileNames <- function(readmeDF, dirPath){
  flaggedMsgs <- character()

  readmeFileNames <- readmeDF$FILE

  dirFileNames <- list.files(path = dirPath)
  dirFileTypes <- sapply(strsplit(dirFileNames, "_"), utils::tail, 1)
  exclusionFiles <- (dirFileNames)[ dirFileTypes == "README.csv" ]

  tryCatch({
    dirFileNames <- setdiff(list.files(path = dirPath), exclusionFiles)
  }, error = function(cond){
    return(compareREADMEFileNamesResult(
      name = "compareREADMEFileNames",
      pass = F,
      msg = cond$message,
      data = list(err = cond)))
  })

  # This is all file names in the directory that are not in the README file.
  missingFromCSV <- setdiff(dirFileNames, readmeFileNames)
  # This is all file names in the README file that are not in the directory.
  missingFromDir <- setdiff(readmeFileNames, dirFileNames)

  if (length(missingFromCSV) > 0){
    line <- paste("File or folder names that are in the directory but not in",
                  "the README file:", paste(missingFromCSV, collapse = ", "))
    flaggedMsgs <- c(flaggedMsgs, line)
  }


  pass <- T
  if (length(missingFromDir) > 0){
    line <- paste("File or folder names that are in the README file but not in",
                  "the directory:", paste(missingFromDir, collapse = ", "))
    flaggedMsgs <- c(flaggedMsgs, line)
    pass <- F
  }

  return (compareREADMEFileNamesResult(
    name = "compareREADMEFileNames",
    pass = pass,
    msg = flaggedMsgs,
    data = list(missing_from_dir = missingFromDir,
                missing_from_csv = missingFromCSV)
    ))
}


#' An S4 subclass of CheckResult for compareREADMEFileNames.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
compareREADMEFileNamesResult <- setClass("compareREADMEFileNames",
                                         contains = "CheckResult")

# [END]
