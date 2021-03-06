% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/checkColumnLabels.R
\name{checkColumnLabels}
\alias{checkColumnLabels}
\title{Check whether a DICT data frame's column labels match in exact order with
the column names in the DATA data frame, and that no column labels are
duplicated. If not, the column labels corresponding to either of these
violations are given through the flagged messages.}
\usage{
checkColumnLabels(dictDF, dataDF)
}
\arguments{
\item{dictDF}{A data frame representing your data dictionary. Must contain a
column \code{dictDF$COLUMN_LABEL} which is your exact columns that you are
expecting in \code{dataDF}}

\item{dataDF}{The data frame whose columns you would like to check against
the dictionary data frame}
}
\value{
An S4 CheckResult object with contents:
}
\description{
Check whether a DICT data frame's column labels match in exact order with
the column names in the DATA data frame, and that no column labels are
duplicated. If not, the column labels corresponding to either of these
violations are given through the flagged messages.
}
\section{Slots}{

\describe{
\item{\code{name}}{Name of this check}

\item{\code{pass}}{TRUE if and only if order is exact and no duplicates are found}

\item{\code{msg}}{Character of details when check fails, otherwise empty}

\item{\code{data}}{List of
\itemize{
\item \code{cols_violated}: Column numbers in the DATA file having names that do
not match with their corresponding column label in COLUMN_LABEL column in
the DICT file, if any exist
\item \code{duplicate_col_labels}: A vector of duplicated column label strings, if
any exist
}}
}}

\author{
Jedid Ahn, Logan Lim
}
