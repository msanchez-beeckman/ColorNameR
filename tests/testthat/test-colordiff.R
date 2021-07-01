
test_that("the distances that CIE76 returns are correct", {
  color1 <- c(50, 2.6772, -79.7751)
  color2 <- c(50, 3.1571, -77.2803)
  color3 <- c(50, 2.8361, -74.0200)
  colors <- rbind({{ color1 }}, {{ color2 }}, {{ color3 }})
  reference <- c(50, 0, -82.7485)
  expected <- c(4.0011, 6.3142, 9.1777)
  expect_equal(round(colordiff(colors, reference, metric="CIE76"), 4), expected)
})

test_that("the distances that CIE94 returns are correct", {
  color1 <- c(50, 2.6772, -79.7751)
  color2 <- c(50, 3.1571, -77.2803)
  color3 <- c(50, 2.8361, -74.0200)
  colors <- rbind({{ color1 }}, {{ color2 }}, {{ color3 }})
  reference <- c(50, 0, -82.7485)
  expected_notsym <- c(1.3653, 1.8527, 2.2719)
  expected_sym <- c(1.3801, 1.8932, 2.3620)
  expect_equal(round(colordiff(colors, reference, metric="CIE94"), 4), expected_notsym)
  expect_equal(round(colordiff(colors, reference, metric="CIE94", symmetric=TRUE), 4), expected_sym)
})

test_that("the distances that CIEDE2000 returns are correct", {
  color1 <- c(50, 2.6772, -79.7751)
  color2 <- c(50, 3.1571, -77.2803)
  color3 <- c(50, 2.8361, -74.0200)
  colors <- rbind({{ color1 }}, {{ color2 }}, {{ color3 }})
  reference <- c(50, 0, -82.7485)
  expected <- c(2.0425, 2.8615, 3.4412)
  expect_equal(round(colordiff(colors, reference), 4), expected)
})

test_that("CIE76 is symmetric", {
  color <- c(50, 2.6772, -79.7751)
  reference <- c(50, 0, -82.7485)
  expect_equal(colordiff(color, reference, metric="CIE76"), colordiff(reference, color, metric="CIE76"))
})

test_that("CIE94 is not symmetric, unless told to", {
  color <- c(50, 2.6772, -79.7751)
  reference <- c(50, 0, -82.7485)
  expect_false(colordiff(color, reference, metric="CIE94") == colordiff(reference, color, metric="CIE94"))
  expect_equal(colordiff(color, reference, metric="CIE94", symmetric=TRUE), colordiff(reference, color, metric="CIE94", symmetric=TRUE))
})

test_that("CIEDE2000 is symmetric", {
  color <- c(50, 2.6772, -79.7751)
  reference <- c(50, 0, -82.7485)
  expect_equal(colordiff(color, reference), colordiff(reference, color))
})
