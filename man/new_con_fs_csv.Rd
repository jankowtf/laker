% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/classes_con.R
\name{new_con_fs_csv}
\alias{new_con_fs_csv}
\title{Internal constructor}
\usage{
new_con_fs_csv(x)
}
\arguments{
\item{x}{(\link{con_fs}) File system path that inherits from \link{con_fs}}
}
\value{

}
\description{
Internal constructor
}
\examples{
(x <- new_con_fs_csv("a/b/c"))
x \%>\% class()
}
