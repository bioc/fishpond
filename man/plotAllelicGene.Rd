% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helper-allelic.R
\name{plotAllelicGene}
\alias{plotAllelicGene}
\title{Plot allelic counts in a gene context using Gviz}
\usage{
plotAllelicGene(
  y,
  gene,
  db,
  region = NULL,
  symbol = NULL,
  genome = NULL,
  tpmFilter = 1,
  isoPropFilter = 0.05,
  countFilter = 10,
  pc = 1,
  transcriptAnnotation = "symbol",
  labels = list(a2 = "a2", a1 = "a1"),
  qvalue = TRUE,
  log2FC = TRUE,
  ideogram = FALSE,
  cov = NULL,
  covFacetIsoform = FALSE,
  allelicCol = c("dodgerblue", "goldenrod1"),
  isoformCol = "firebrick",
  statCol = "black",
  gridCol = "grey80",
  baselineCol = "black",
  titleCol = "black",
  titleAxisCol = "black",
  titleBgCol = "white",
  geneBorderCol = "darkblue",
  geneFillCol = "darkblue",
  genomeAxisCol = "black",
  innerFontCol = "black",
  ...
)
}
\arguments{
\item{y}{a SummarizedExperiment (see \code{swish})}

\item{gene}{the name of the gene of interest, requires
a column \code{gene_id} in the metadata columns of the
rowRanges of y}

\item{db}{either a TxDb or EnsDb object to use for the gene model}

\item{region}{GRanges, the region to be displayed in the Gviz plot.
if not specified, will be set according to the gene plus 20%
of the total gene extent on either side}

\item{symbol}{alternative to \code{gene}, to specify
the gene of interest according to a column \code{symbol}
in the metadata columns of the rowRanges of y}

\item{genome}{UCSC genome code (e.g. \code{"hg38"},
if not specified it will use the \code{GenomeInfoDb::genome()}
of the rowRanges of \code{y}}

\item{tpmFilter}{minimum TPM value (mean over samples) to keep a feature}

\item{isoPropFilter}{minimum percent of isoform proportion to keep a feature}

\item{countFilter}{minimum count value (mean over samples) to keep a feature}

\item{pc}{pseudocount to avoid dividing by zero in allelic proportion calculation}

\item{transcriptAnnotation}{argument passed to Gviz::GeneRegionTrack
(\code{"symbol"}, \code{"gene"}, \code{"transcript"}, etc.)}

\item{labels}{list, labels for a2 (non-effect) and a1 (effect) alleles}

\item{qvalue}{logical, whether to inclue qvalue track}

\item{log2FC}{logical, whether to include log2FC track}

\item{ideogram}{logical, whether to include ideogram track}

\item{cov}{character specifying a factor or integer variable to use
to facet the allelic proportion plots, should be a column in
\code{colData(y)}}

\item{covFacetIsoform}{logical, if \code{cov} is provided,
should it also be used to facet the isoform proportion track,
in addition to the allelic proportion track}

\item{allelicCol}{the colors of the points and lines for allelic proportion}

\item{isoformCol}{the colors of the points and lines for isoform proportion}

\item{statCol}{the color of the lollipops for q-value and log2FC}

\item{gridCol}{the color of the grid in the data tracks}

\item{baselineCol}{the color of the horizontal baseline for q-value and lo2gFC}

\item{titleCol}{font color of the side titles (track labels)}

\item{titleAxisCol}{axis color of the side titles (track labels)}

\item{titleBgCol}{background color of the side titles (track labels)}

\item{geneBorderCol}{the color of the borders and font in gene region track}

\item{geneFillCol}{the color of the fill in the gene region track}

\item{genomeAxisCol}{line color of the genome axis track}

\item{innerFontCol}{font color of genome axis track, ideogram, and
allelic proportion legend}

\item{...}{additional arguments passed to \code{Gviz::plotTracks()}}
}
\value{
nothing, a plot is displayed
}
\description{
Plot allelic data (allelic proportions, isoform propostions)
in a gene context leveraging the Gviz package. See the allelic
vignette for example usage. TPM and count filters are used by
default to clean up the plot of features with minimal signal;
note that the isoform proportion displayed at the bottom of the
plot is among the features that pass the filtering steps.
If the function is not responding, it is likely due to issues
connecting to UCSC servers to draw the ideogram, in this case
set \code{ideogram=FALSE}.
}
\references{
The methods for allelic expression analysis are described in:

Euphy Wu, Noor P. Singh, Kwangbom Choi, Mohsen Zakeri, Matthew
Vincent, Gary A. Churchill, Cheryl L. Ackert-Bicknell, Rob Patro,
Michael I. Love.
"Detecting isoform-level allelic imbalance accounting for
inferential uncertainty" bioRxiv (2022)
\url{https://doi.org/10.1101/2022.08.12.503785}

This function makes use of the Gviz package that is described in:

Hahne, F., Ivanek, R. (2016). Visualizing Genomic Data
Using Gviz and Bioconductor.
In: Mathé, E., Davis, S. (eds) Statistical Genomics.
Methods in Molecular Biology, vol 1418. Humana Press,
New York, NY. \url{https://doi.org/10.1007/978-1-4939-3578-9_16}
}
