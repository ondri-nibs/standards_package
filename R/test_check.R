
checkMatrixIsNonsingular <- function(mat){
  if (!("matrix" %in% class(mat))) {
    msg <- list(
      pass=FALSE,
      note=c("The input 'mat' is not a matrix. Attached: class(mat)"),
      data=c(class(mat)))
    return(msg)
  }

  tryCatch({
      # Some lines that would cause an error
      # read.csv("AShosjdioaisjd")
      # eigen(c(1,10,10))
      solve(mat)
    },
    error = function(cond){
      message("This is an error.")
      message(cond)
    },
    warning = function(cond){
      message("This is a warning.")
      message(cond)
    }
  )
}
