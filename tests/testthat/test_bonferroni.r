### library(poolr); library(testthat); Sys.setenv(NOT_CRAN="true")
library(poolr)

source("tolerances.r")

context("Checking bonferroni() function")

test_that("bonferroni() works correctly under independence.", {

  res <- bonferroni(grid2ip.p)

  expect_equivalent(c(res$p), 0.0684710, tolerance = p_tol)
  expect_equivalent(c(res$statistic), 0.0029770, tolerance = stat_tol)

})

test_that("bonferroni() works correctly with effective number of tests.", {

  res_nyh <- bonferroni(grid2ip.p, adjust = "nyholt", R = mvnconv(grid2ip.ld, target = "p", cov2cor = TRUE))
  res_lj  <- bonferroni(grid2ip.p, adjust = "liji", R = mvnconv(grid2ip.ld, target = "p", cov2cor = TRUE))
  res_gao <- bonferroni(grid2ip.p, adjust = "gao", R = mvnconv(grid2ip.ld, target = "p", cov2cor = TRUE))
  res_gal <- bonferroni(grid2ip.p, adjust = "galwey", R = mvnconv(grid2ip.ld, target = "p", cov2cor = TRUE))

  expect_equivalent(c(res_nyh$p), 0.0654940, tolerance = p_tol)
  expect_equivalent(c(res_nyh$statistic), 0.0029770, tolerance = stat_tol)

  expect_equivalent(c(res_lj$p), 0.0625170, tolerance = p_tol)
  expect_equivalent(c(res_lj$statistic), 0.0029770, tolerance = stat_tol)

  expect_equivalent(c(res_gao$p), 0.0684710, tolerance = p_tol)
  expect_equivalent(c(res_gao$statistic), 0.0029770, tolerance = stat_tol)

  expect_equivalent(c(res_gal$p), 0.0595400, tolerance = p_tol)
  expect_equivalent(c(res_gal$statistic), 0.0029770, tolerance = stat_tol)

})

test_that("bonferroni() works correctly with empirically-derived null distributions.", {

  set.seed(1234)
  res <- bonferroni(grid2ip.p, adjust = "empirical", R = grid2ip.ld)

  expect_equivalent(c(res$p), 0.0493951, tolerance = p_tol * emp_sca)
  expect_equivalent(c(res$statistic), 0.0029770, tolerance = stat_tol * emp_sca)
  expect_equivalent(c(res$ci[1]), 0.0452300, tolerance = stat_tol * emp_sca)
  expect_equivalent(c(res$ci[2]), 0.0538250, tolerance = stat_tol * emp_sca)

  set.seed(1234)
  res <- bonferroni(grid2ip.p, adjust = "empirical", R = grid2ip.ld, size = 100000)

  expect_equivalent(c(res$p), 0.0524495, tolerance = p_tol * emp_sca)
  expect_equivalent(c(res$statistic), 0.0029770, tolerance = stat_tol * emp_sca)
  expect_equivalent(c(res$ci[1]), 0.0510758, tolerance = stat_tol * emp_sca)
  expect_equivalent(c(res$ci[2]), 0.0538492, tolerance = stat_tol * emp_sca)

  set.seed(1234)
  res <- bonferroni(grid2ip.p, adjust = "empirical", R = grid2ip.ld, size = 1000000, batchsize = 1000)

  expect_equivalent(c(res$p), 0.0513779, tolerance = p_tol * emp_sca)
  expect_equivalent(c(res$statistic), 0.0029770, tolerance = stat_tol * emp_sca)
  expect_equivalent(c(res$ci[1]), 0.0509461, tolerance = stat_tol * emp_sca)
  expect_equivalent(c(res$ci[2]), 0.0518124, tolerance = stat_tol * emp_sca)

  set.seed(1234)
  res <- bonferroni(grid2ip.p, adjust = "empirical", R = grid2ip.ld, size = c(1000, 10000, 100000), threshold = c(0.10, 0.01))

  expect_equivalent(c(res$p), 0.0483952, tolerance = p_tol * emp_sca)
  expect_equivalent(c(res$statistic), 0.0029770, tolerance = stat_tol * emp_sca)
  expect_equivalent(c(res$ci[1]), 0.0442713, tolerance = stat_tol * emp_sca)
  expect_equivalent(c(res$ci[2]), 0.0527844, tolerance = stat_tol * emp_sca)

})
