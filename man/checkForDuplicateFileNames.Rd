% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/checkForDuplicateFileNames.R
\name{checkForDuplicateFileNames}
\alias{checkForDuplicateFileNames}
\title{Check non-tabular directory for duplicate files in different leveled folders.
Ex: Duplicate file name in level 1 and level 2.}
\usage{
checkForDuplicateFileNames(dirPath)
}
\arguments{
\item{dirPath}{Full directory path in character format}
}
\value{
An S4 CheckResult object with contents:
}
\description{
Check non-tabular directory for duplicate files in different leveled folders.
Ex: Duplicate file name in level 1 and level 2.
}
\section{Slots}{

\describe{
\item{\code{name}}{Name of this check}

\item{\code{pass}}{TRUE if and only if non-tabular directory contains no
duplicate file names}

\item{\code{msg}}{Character of details when check fails, otherwise empty}

\item{\code{data}}{List of
\itemize{
\item \code{file_names}: File names that are duplicated.
}}
}}

\author{
Roberto Lentini, Logan Lim
}
