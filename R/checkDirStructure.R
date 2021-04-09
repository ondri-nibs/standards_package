#' Check whether or not directory matches specified structure. Also checks a
#' specified set of names in a directory against the list.files output.
#'
#' @param baseDir Base/top-most directory
#' @param dirStructure A character vector of file & directory names with
#' forward slashes.
#' @param recursive TRUE if you wish to parse into subdirectories, otherwise FALSE
#' @param exact When TRUE, the check will only pass if the files and directories
#' in the base folder match exactly. When FALSE, will pass when the base folder
#' contains all of the specified files and directories.
#'
#' @return An S4 CheckResult object with contents:
#' @slot name Name of this check
#' @slot pass TRUE if and only if baseDir matches specified structure as listed
#' in dirStructure
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#' - `fnames`: Vector of file and directory names in the base directory.
#'
#' @author Logan Lim
#' @export

checkDirStructure <- function(baseDir, dirStructure, recursive = T, exact = F){

  fnames <- list.files(baseDir, recursive = recursive, include.dirs = TRUE)
  if(length(fnames) == 0){
    # Means the directory was probably not found or is empty
    return(checkDirStructureResult(
      name = "checkDirStructure",
      pass = F,
      msg = "Empty directory/Directory cannot be found",
      data = list(fnames = fnames)
      ))
  }

  if(exact){
    expected_len <- length(fnames)
  } else{
    expected_len <- length(dirStructure)
  }

  pass <- F
  msg <- ifelse(
    exact,
    paste("Names specified in dirStructure do not match the contents of",
          baseDir),
    paste("Names specified in dirStructure do not contain the contents of",
          baseDir)
    )

  # If the dir structure is the same then the length of there intersection
  # is the length of fnames. If dirStructure is contained in fnames then
  # the length of the intersection will be >= length(dirStructure)
  if(length(intersect(fnames, dirStructure) >= expected_len)){
    pass <- T
    msg <- ifelse(exact,
      paste("Names in directory", baseDir,
            "match structure specified in dirStructure."),
      paste("Names in directory", baseDir,
            "contain the names specified in dirStructure."))
  }

  return(checkDirStructureResult(
    name = "checkDirStructure",
    pass = pass,
    msg = msg,
    data = list(fnames = fnames)
    ))
}


#' An S4 subclass of CheckResult for checkDirStructure.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
checkDirStructureResult <- setClass("checkDirStructureResult",
                                    contains = "CheckResult")
