#' Compare a vector of file names (such as the FILENAME column in the level 3
#' FILELIST file) and the literal contents of a directory (such as the level 3
#' DATAFILES folder) and check whether they match exactly.
#'
#' @param fileNamesVec Character vector of participant file names
#' @param dirPath Directory path of participant files
#'
#' @return An S4 CheckResult object containing:
#' @slot name Name of this check
#' @slot pass TRUE if and only if all participant files exist in vector
#' of participant file names
#' @slot msg Character of details when check fails, otherwise empty
#' @slot data List of
#' - `missing_from_vec`: File names in the participant files folder that are
#' not in the vector of participant file names.
#' - `missing_from_dir`: File names in the vector of participant file names
#' that are not in the participant files folder.
#'
#' @author Jedid Ahn, Jeremy Tanuan
#' @export
#'
compareParticipantFileNames <- function(fileNamesVec, dirPath){
  flaggedMsgs <- character()
  missingFromVec <- character()
  missingFromDir <- character()

  if (class(fileNamesVec) != "character"){
    line <- paste("The file names vector needs to be a character vector.",
                  "Cannot proceed with check.")
    flaggedMsgs <- c(flaggedMsgs, line)
  }
  else if (class(dirPath) != "character"){
    line <- paste("The directory path needs to be a character class.",
                  "Cannot proceed with check.")
    flaggedMsgs <- c(flaggedMsgs, line)
  }
  else{
    # Get the MISSING file name and DICT file name if either exist.
    exclusionFiles <- c(getFileName(dirPath, "FILELIST.csv"),
                        getFileName(dirPath, "MISSING.csv"),
                        getFileName(dirPath, "DICT.csv"))

    fileNames <- list.files(path = dirPath)
    participantFileNames <- setdiff(fileNames, exclusionFiles)

    # This is all file names in the participant files folder that are not
    # in the vector of participant file names.
    missingFromVec <- setdiff(participantFileNames, fileNamesVec)
    # This is all file names in the vector of participant file names that are
    # not in the participant files folder.
    missingFromDir <- setdiff(fileNamesVec, participantFileNames)

    pass <- T
    if (length(missingFromVec) > 0){
      line <- paste("File names that are in the participant files folder but",
                    "not in the vector of participant file names:",
                    paste(missingFromVec, collapse = ", "))
      flaggedMsgs <- c(flaggedMsgs, line)
      pass <- F
    }

    if (length(missingFromDir) > 0){
      line <- paste("File names that are in the vector of participant file",
                    "names but not in the participant files folder:",
                    paste(missingFromDir, collapse = ", "))
      flaggedMsgs <- c(flaggedMsgs, line)
      pass <- F
    }
  }

  return (compareParticipantFileNameResults(
    name = "compareParticipantFileNames",
    pass = pass,
    msg = flaggedMsgs,
    data = list(missing_from_vec = missingFromVec,
                missing_from_dir = missingFromDir)))
}

#' An S4 subclass of CheckResult for compareParticipantFileNames.
#'
#' @inherit CheckResult
#' @seealso `CheckResult`
#'
compareParticipantFileNameResults <- setClass("compareParticipantFiles",
                                             contains = "CheckResult")


#' HELPER FUNCTION: Return the file name of a tabular file depending on
#' its type.
#'
#' @param dirPath Directory path
#' @param fileType File type such as DATA, DICT, README, or MISSING
#'
#' @return Full file name of file type
#'
#' @author Jedid Ahn
#'
getFileName <- function(dirPath, fileType){
  dirFileNames <- list.files(path = dirPath)
  dirFileTypes <- sapply(strsplit(dirFileNames, "_"), utils::tail, 1)
  fileName <- (dirFileNames)[ dirFileTypes == fileType ]
  return (fileName)
}

# [END]
