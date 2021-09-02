context("correlation")
library(SummarizedExperiment)
library(fishpond)

test_that("swish can detect correlations with log counts", {

  set.seed(1)

  y <- makeSimSwishData(m=500, n=20, null=TRUE)
  nms <- c("counts",paste0("infRep",1:20))
  lambda1 <- exp(seq(4, 5, length.out=20))
  lambda2 <- rev(lambda1)
  y$condition <- sort(runif(20,0,0.1))
  for (a in nms) {
    assays(y)[[a]][1,] <- rpois(20,lambda1)
    assays(y)[[a]][2,] <- rpois(20,lambda2)
  }
  y <- scaleInfReps(y, quiet=TRUE)
  y <- labelKeep(y)
  y <- computeInfRV(y)

  y <- swish(y, x="condition", cor="spearman", nperms=30)
  #hist(mcols(y)$pvalue)
  #plot(-log10(mcols(y)$pvalue[1:30]))
  mcols(y)[1:2,]
  mcols(y)[1,"log2FC"]
  coef(lm(log2(lambda1) ~ y$condition))[[2]]
  #plotInfReps(y, idx=1, x="condition")

  y <- swish(y, x="condition", cor="pearson", nperms=30)
  #hist(mcols(y)$pvalue)
  #plot(-log10(mcols(y)$pvalue[1:30]))
  mcols(y)[1:2,]

  # correlation with a log fold change
  
  set.seed(5)

  y <- makeSimSwishData(m=500, n=20, null=TRUE)
  nms <- c("counts",paste0("infRep",1:20))
  lambda1 <- exp(seq(4, 5, length.out=10))
  lambda2 <- rev(lambda1)
  ar <- log2(lambda1/lambda2) # the allelic ratio for gene 1
  y$condition <- factor(rep(c("a2","a1"),each=10), levels=c("a2","a1"))
  y$pair <- rep(1:10,2)
  cov <- sort(runif(10,0,0.1)) # the numeric covariate
  y$cov <- rep(cov,2)
  plot(y$cov[1:10], ar)  
  for (a in nms) {
    assays(y)[[a]][1,] <- rpois(20,c(lambda2,lambda1))
    assays(y)[[a]][2,] <- rpois(20,c(lambda1,lambda2))
  }

  y <- scaleInfReps(y, quiet=TRUE)
  y <- labelKeep(y)
  y <- computeInfRV(y)

  y <- swish(y, x="condition", pair="pair",
             cov="cov", cor="pearson", nperms=30)
  #hist(mcols(y)$pvalue)
  #plot(-log10(mcols(y)$pvalue[1:30]))
  mcols(y)[1:2,]

  y <- swish(y, x="condition", pair="pair",
             cov="cov", cor="spearman", nperms=30)
  #hist(mcols(y)$pvalue)
  #plot(-log10(mcols(y)$pvalue[1:30]))
  mcols(y)[1:2,]
  
  #plotInfReps(y, 1, x="cov", cov="condition",
  #            legend=TRUE, legendPos="top")
    
})