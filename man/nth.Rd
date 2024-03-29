% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/nth.R
\name{nth}
\alias{nth}
\alias{maxth}
\alias{minth}
\title{Extract the nth value from a vector}
\usage{
nth(v, n = 1)

maxth(v, n = 1)

minth(v, n = 1)
}
\arguments{
\item{v}{A vector}

\item{n}{For\code{nth}, a single integer specifying the position. Default uses \code{1}.
Negative integers index from the end
 (i.e. -1L will return the last value in the vector).
 If a double is supplied, it will be silently truncated.
 For \code{maxth} and \code{minth}, a single integer indicating the nth
 highest or lowest value.}
}
\value{
A single value.
}
\description{
\code{nth} get the value from a vector with its position,
 while \code{maxth} and \code{minth} get the nth highest or lowest value
 from the vector.
}
\examples{

x = 1:10
nth(x, 1)
nth(x, 5)
nth(x, -2)

y = c(10,3,4,5,2,1,6,9,7,8)
maxth(y,3)
minth(y,3)

}
\references{
https://stackoverflow.com/questions/2453326/fastest-way-to-find-second-third-highest-lowest-value-in-vector-or-column/66367996#66367996
}
