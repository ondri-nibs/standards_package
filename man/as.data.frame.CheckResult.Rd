% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/CheckResult.R
\name{as.data.frame.CheckResult}
\alias{as.data.frame.CheckResult}
\title{Returns CheckResult as data.frame}
\usage{
\method{as.data.frame}{CheckResult}(...)
}
\arguments{
\item{...}{CheckResult objects

This function turns a list of CheckResult objects into a data.frame with
columns corresponding to the slots of CheckResults
CheckResult@data is not included in this data.frame since it can be a list
of arbitrary types. To get CheckResult@data use the get.data(CheckResult) method.}
}
\description{
Returns CheckResult as data.frame
}
