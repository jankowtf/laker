% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/io_read.R
\name{read_curated}
\alias{read_curated}
\title{Read from curated layer}
\usage{
read_curated(con = con_fs_arrow(), constructor)
}
\arguments{
\item{con}{\link{connection} Arrow connection to data lake layer}

\item{constructor}{}
}
\value{

}
\description{
Convenience wrapper around \code{con} chain with suitable constructor
}
