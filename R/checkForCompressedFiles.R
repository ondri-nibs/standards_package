#' Check if a directory contains compressed files.
#'
#' @param dirPath Full directory path in character format
#'
#' @return An S4 CheckResult object with contents:
#' @slot name Name of this check
#' @slot pass TRUE if and only if directory contains no compressed files
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data Empty list
#'
#' @author Roberto Lentini, Logan Lim
#' @export
#'
checkForCompressedFiles <- function(dirPath){
  # creating a list of the file extensions found in folder
  flaggedMsgs <- character()
  extType <- c()

  FileNames <- list.files(path = dirPath)
  # list of common compressed files
  compressedFiles <- c("zip", "tar", "gz", "tar.gz")

  for (item in FileNames){
    ext <- xfun::file_ext(item)
    extType <- c(ext, extType)
  }

  # Warning message if there is a compressed file in the folder
  for (ext in extType){
    if (any(ext %in% compressedFiles)){
      flaggedMsgs <- paste("Warning: Directory - Compressed Files",
                           basename(dirPath),
                           "Directory contains a compressed file.")
      break
    }
  }


  pass <- T
  if (length(flaggedMsgs) > 0){
    pass <- F
  }
  return(checkForCompressedFilesResult(
    name ="checkForCompressedFiles",
    pass = pass,
    msg = flaggedMsgs,
    data = list()
    ))
}


#' An S4 subclass of CheckResult for checkForCompressedFiles.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkForCompressedFilesResult <- setClass("checkForCompressedFilesResult",
                                          contains = "CheckResult")

# [END]
