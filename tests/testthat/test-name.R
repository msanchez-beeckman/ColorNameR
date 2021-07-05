
test_that("correct names are given in different languages", {
  L <- 93
  a <- -9
  b <- 36
  color1 <- c(L, a, b)
  expect_equal(name(color1), "light yellow green")
  expect_equal(name(color1, language="french"), "vert-jaune clair")
  expect_equal(name(color1, language="german"), "hellgelbgrün")
  expect_equal(name(color1, language="spanish"), "verde amarillento claro")

  L2 <- 69
  a2 <- 4
  b2 <- -31
  color2 <- c(L2, a2, b2)
  expect_equal(name(color2), "light blue")
  expect_equal(name(color2, language="french"), "bleu clair")
  expect_equal(name(color2, language="german"), "hellblau")
  expect_equal(name(color2, language="spanish"), "azul claro")
})

test_that("asking for a color name in an unknown language raises an error", {
  L <- 93
  a <- -9
  b <- 36
  color1 <- c(L, a, b)
  expect_error(name(color1, language="sumerian"))
})

test_that("shorthands for languages work correctly", {
  L <- 93
  a <- -9
  b <- 36
  color1 <- c(L, a, b)
  expect_equal(name(color1, language="en"), name(color1))
  expect_equal(name(color1, language="en"), name(color1, language="english"))
  expect_equal(name(color1, language="fr"), name(color1, language="french"))
  expect_equal(name(color1, language="de"), name(color1, language="german"))
  expect_equal(name(color1, language="es"), name(color1, language="spanish"))
})

test_that("asking for the names of multiple colors returns multiple names", {
  color1 <- c(93, -9, 36)
  color2 <- c(69, 4, -31)
  color3 <- c(45, -20, -30)
  colors <- rbind({{ color1 }}, {{ color2 }}, {{ color3 }})
  expect_equal(name(colors), c("light yellow green", "light blue", "dark green blue"))
})

test_that("the transformation from sRGB to Lab works correctly", {
  colors <- rbind(c(244/255, 234/255, 184/255), c(243/255, 231/255, 103/255))
  expect_equal(name(colors, colorspace="sRGB"), c("light yellow", "medium yellow"))
})

