% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/alevin-EC.R
\name{alevinEC}
\alias{alevinEC}
\title{Construct a sparse matrix of transcript compatibility counts from alevin 
output}
\usage{
alevinEC(
  paths,
  tx2gene,
  multigene = FALSE,
  ignoreTxVersion = FALSE,
  ignoreAfterBar = FALSE,
  quiet = FALSE
)
}
\arguments{
\item{paths}{`Charachter` or `character vector`, path specifying the 
location of the `bfh.txt` files generated with alevin-fry.}

\item{tx2gene}{A `dataframe` linking transcript identifiers to their 
corresponding gene identifiers. Transcript identifiers must be in a column 
`isoform_id`. Corresponding gene identifiers must be in a column `gene_id`.}

\item{multigene}{`Logical`, should equivalence classes that are compatible 
with multiple genes be retained? Default is `FALSE`, removing such ambiguous
equivalence classes.}

\item{ignoreTxVersion}{logical, whether to split the isoform id on the '.' 
character to remove version information to facilitate matching with the
isoform id in `tx2gene` (default FALSE).}

\item{ignoreAfterBar}{logical, whether to split the isoform id on the '|' 
character to facilitate matching with the isoform id in `tx2gene` 
(default FALSE).}

\item{quiet}{`Logical`, set `TRUE` to avoid displaying messages.}
}
\value{
A list with two elements. The first element `counts` is a sparse 
count matrix with equivalence class identifiers in the rows and barcode 
identifiers followed by an underscore and a sample identifier in the columns. 
The second element `tx2gene_matched` allows for linking the equivalence class
identifiers to their respective transcripts and genes.
}
\description{
Constructs a UMI count matrix with equivalence class identifiers
in the rows and barcode identifiers in the columns. The count matrix is 
generated from one or multiple `bfh.txt` files that have been created by 
running alevin-fry with the --dumpBFH flag. Alevin-fry - 
\url{https://doi.org/10.1186/s13059-019-1670-y}
}
\section{Details}{

The resulting count matrix uses equivalence class identifiers as rownames.
These can be linked to respective transcripts and genes using the 
`tx2gene_matched` element of the output. Specifically, if the equivalence 
class identifier reads 1|2|8, then the equivalence class is compatible with
the transcripts and their respective genes in rows 1, 2 and 8 of 
`tx2gene_matched`.
}

\author{
Jeroen Gilis
}
