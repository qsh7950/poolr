
tippett <- function(p, adjust = "none", pca.method = NULL, R = NULL, size = 10000, seed = NULL, ...) {
   if (adjust == "none") {
      k <- length(p)
      pooled.p <- 1 - (1 - min(p))^k
   } else if (adjust == "m.eff") {
      eff <- meff(R = R, method = pca.method)
      pooled.p <- 1 - (1 - min(p))^eff
   } else if (adjust == "empirical") {
      k <- length(p)
      tmp.p <- 1 - (1 - min(p))^k
      method <- "tippett"
      
      emp.dist <- empirical(p = p, R = R, method = method, size = size, seed = seed)
      pooled.p <- sum(emp.dist <= tmp.p) / length(emp.dist)
   }
   
   if(pooled.p > 1) {pooled.p <- 1}
   res <- list(p = pooled.p, adjust = paste0(adjust, " "))
   return(res)
}