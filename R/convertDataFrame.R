#' Convert the initial data frame to make values consistent to allow for
#' easier analyzation.
#'
#' @param df Initial data frame
#'
#' @return df Converted data frame
#'
#' @author Jedid Ahn, Logan Lim
#'
convertDataFrame <- function(df){
  # Step 1: Get any column names that are blank, and convert all to "NO_TITLE".
  selection <- colnames(df) == ""
  colnames(df)[ selection ] <- "NO_TITLE"

  # Step 2: Get any cells that contain the value "NA", and convert all to "".
  selection <- (is.na(df))
  df[ selection ] <- ""

  return (df)
}
