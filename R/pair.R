swishPair <- function(infRepsArray, condition, pair, fast,
                      nperms=100, pc=5, quiet=FALSE) {
  pair <- checkPair(pair, condition)
  if (fast == 1) {
    lfcArray <- getLog2FCPair(infRepsArray, condition, pair, pc, array=TRUE)
    log2FC <- medianOverMean(lfcArray)
    stat <- getZscore(lfcArray)
    dims <- dim(lfcArray)
    n <- dims[2] # nsamples
  } else {
    log2FC <- getLog2FCPair(infRepsArray, condition, pair, pc)
    stat <- getSignedRank(infRepsArray, condition, pair)
  }
  cond_sign <- ifelse(condition == levels(condition)[1], 1, -1)
  perms <- getPairPerms(cond_sign * pair, nperms)
  nperms <- permsNote(perms, nperms)
  # now just work with the permutations matrix
  perms <- perms$perms
  nulls <- matrix(nrow=nrow(infRepsArray), ncol=nperms)
  if (!quiet) message("generating test statistics over permutations")
  for (p in seq_len(nperms)) {
    if (!quiet) svMisc::progress(p, max.value=nperms, init=(p==1), gui=FALSE)
    # fast code just uses one sample z-score, flips signs per permutation
    if (fast == 1) {
      # convert to 1 and -1 based on finite permutations
      sign_flip <- ifelse(perms[p, 2 * 1:n] == 2 * 1:n, 1, -1)
      # same permutation is used across all genes and inf reps
      nulls[,p] <- getZscore(lfcArray, sign_flip=sign_flip)
    } else {
      nulls[,p] <- getSignedRank(infRepsArray,
                                 condition[perms[p,]],
                                 pair[perms[p,]])
    }
  }
  if (!quiet) message("")
  list(stat=stat, log2FC=log2FC, nulls=nulls)
}

getZscore <- function(lfcArray, sign_flip=NULL) {
  dims <- dim(lfcArray)
  z_mat <- matrix(nrow=dims[1],ncol=dims[3])
  for (k in seq_len(dims[3])) {
    if (is.null(sign_flip)) {
      z_mat[,k] <- rowMeans(lfcArray[,,k]) / sqrt(rowVars(lfcArray[,,k]))
    } else {
      # (nsamp x ngene) * nsamp
      lfc <- t(lfcArray[,,k]) * sign_flip
      z_mat[,k] <- colMeans(lfc) / sqrt(colVars(lfc))
    }
  }
  rowMedians(z_mat)
}

getSignedRank <- function(infRepsArray, condition, pair) {
  dims <- dim(infRepsArray)
  signed_ranks <- array(dim=c(dims[1],dims[2]/2,dims[3]))
  o <- order(condition, pair)
  grp1 <- head(o, length(condition)/2)
  grp2 <- tail(o, length(condition)/2)
  for (k in seq_len(dims[3])) {
    diff <- infRepsArray[,grp2,k] - infRepsArray[,grp1,k]
    signed_ranks[,,k] <- sign(diff) *
      rowRanks(abs(diff) + 0.1 * runif(dims[1]*dims[2]/2),
               ties.method = "average")
  }
  # sums of signed rank, expectation is 0
  W <- apply(signed_ranks, c(1,3), sum)
  rowMeans(W)
}

getLog2FCPair <- function(infRepsArray, condition, pair, pc=5, array=FALSE) {
  dims <- dim(infRepsArray)
  o <- order(condition, pair)
  if (!all(o == seq_along(condition))) {
    infRepsArray <- infRepsArray[,o,]
  }
  n <- dims[2]
  cond1 <- (1):(n/2)
  cond2 <- (n/2 + 1):(n)
  lfcArray <- log2(infRepsArray[,cond2,] + pc) -
              log2(infRepsArray[,cond1,] + pc)
  if (array) {
    return(lfcArray)
  }
  # mean over sample, then median over infReps
  medianOverMean(lfcArray)
}

medianOverMean <- function(lfcArray) {
  # mean over samples
  lfc_mat <- apply(lfcArray, c(1,3), mean)
  # median over inferential replicates
  rowMedians(lfc_mat)
}

# spair = signed pair
getPairPerms <- function(spair, nperms) {
  # samr's version needs downstream postprocessing, so we implement new one
  #perms <- samr:::compute.block.perms(spair, abs(spair), nperms)
  npairs <- max(spair)
  # for 10 or less pairs, we compute the assignments and subset
  if (npairs <= 10) {
    out0 <- permutations(2, npairs, repeats.allowed=TRUE)
    if (nrow(out0) > nperms) {
      idx <- sample(nrow(out0), nperms)
      out <- out0[idx,]
    } else {
      out <- out0
    }
    pair.perms <- t(matrix(seq_along(spair),
                           ncol=nrow(out),
                           nrow=length(spair)))
    for (i in seq_len(nrow(pair.perms))) {
      if (any(out[i,] == 2)) {
        swap <- which(out[i,] == 2)
        for (s in swap) {
          idx <- which(abs(spair) == s)
          pair.perms[i,idx] <- rev(idx)
        }
      }
    }
    # output structured like the samr function
    perms <- list(perms = pair.perms,
                  all.perms.flag = as.integer(nrow(out0) <= nperms),
                  nperms.act = nrow(out))
  } else {
    # otherwise, change the sign of some of the pairs
    pair.perms <- t(matrix(seq_along(spair),
                           ncol=nperms,
                           nrow=length(spair)))
    for (i in seq_len(nrow(pair.perms))) {
      coin.flip <- sample(2, npairs, replace=TRUE)
      if (any(coin.flip == 2)) {
        swap <- which(coin.flip == 2)
        for (s in swap) {
          idx <- which(abs(spair) == s)
          pair.perms[i,idx] <- rev(idx)
        }
      }        
    }
    # output structured like the samr function
    perms <- list(perms = pair.perms,
                  all.perms.flag = 0,
                  nperms.act = nperms)
  }
  perms
}

checkPair <- function(pair, condition) {
  stopifnot(is.numeric(pair) | is.character(pair) | is.factor(pair))
  stopifnot(!anyNA(pair))
  pair <- as.integer(factor(pair))
  if (!all(table(pair, condition) == 1))
    stop("'pair' should have a single sample for both levels of condition")
  pair
}
