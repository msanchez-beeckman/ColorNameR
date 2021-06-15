
test_that("correct names are given in different languages", {
  L <- 93
  a <- -9
  b <- 36
  expect_equal(name_color(L, a, b), "light yellow green")
  expect_equal(name_color(L, a, b, "french"), "vert-jaune clair")
  expect_equal(name_color(L, a, b, "german"), "hellgelbgrün")
  expect_equal(name_color(L, a, b, "spanish"), "verde amarillento claro")

  L2 <- 69
  a2 <- 4
  b2 <- -31
  expect_equal(name_color(L2, a2, b2), "light blue")
  expect_equal(name_color(L2, a2, b2, "french"), "bleu clair")
  expect_equal(name_color(L2, a2, b2, "german"), "hellblau")
  expect_equal(name_color(L2, a2, b2, "spanish"), "azul claro")
})

test_that("asking for a color name in an unknown language raises an error", {
  L <- 93
  a <- -9
  b <- 36
  expect_error(name_color(L, a, b, "sumerian"))
})

test_that("shorthands for languages work correctly", {
  L <- 93
  a <- -9
  b <- 36
  expect_equal(name_color(L, a, b, "en"), name_color(L, a, b))
  expect_equal(name_color(L, a, b, "en"), name_color(L, a, b, "english"))
  expect_equal(name_color(L, a, b, "fr"), name_color(L, a, b, "french"))
  expect_equal(name_color(L, a, b, "fr"), name_color(L, a, b, "français"))
  expect_equal(name_color(L, a, b, "de"), name_color(L, a, b, "german"))
  expect_equal(name_color(L, a, b, "de"), name_color(L, a, b, "deutsch"))
  expect_equal(name_color(L, a, b, "es"), name_color(L, a, b, "spanish"))
  expect_equal(name_color(L, a, b, "es"), name_color(L, a, b, "español"))
})

