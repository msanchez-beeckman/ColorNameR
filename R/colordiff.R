
#' Get the CIE76 color difference between two CIELab values.
#'
#' @param lab_color1 A vector with three components corresponding to a Lab value.
#' @param lab_color2 A vector with three components corresponding to another Lab value.
#' @return The CIE76 color difference between the two given values.
#' @references Sharma, G., & Bala, R. (Eds.). (2017). Digital color imaging handbook. CRC press.
cie76 <- function(lab_color1, lab_color2) {
  diff <- lab_color1 - lab_color2
  base::sqrt(sum(diff^2))
}

#' Get the CIE94 color difference between two CIELab values.
#'
#' @param lab_color1 A vector with three components corresponding to a Lab value.
#' @param lab_color2 A vector with three components corresponding to another Lab value.
#' @param k_L Weighting factor for the L component.
#' @param k_C Weighting factor for the C component.
#' @param k_H Weighting factor for the H component.
#' @param K1 Application dependent weighting factor.
#' @param K2 Application dependent weighting factor.
#' @param symmetric If TRUE, use the symmetric version of the formula.
#' @return The CIE94 color difference between the two given values.
#' @references Sharma, G., & Bala, R. (Eds.). (2017). Digital color imaging handbook. CRC press.
cie94 <- function(lab_color1, lab_color2, k_L=1, k_C=1, k_H=1, K1=0.045, K2=0.015, symmetric=FALSE) {
  L1 <- lab_color1[1]
  a1 <- lab_color1[2]
  b1 <- lab_color1[3]
  L2 <- lab_color2[1]
  a2 <- lab_color2[2]
  b2 <- lab_color2[3]

  delta_L <- L1 - L2
  C1 <- base::sqrt(a1^2 + b1^2)
  C2 <- base::sqrt(a2^2 + b2^2)
  delta_C <- C1 - C2
  delta_a <- a1 - a2
  delta_b <- b1 - b2
  delta_H <- base::sqrt(delta_a^2 + delta_b^2 - delta_C^2)

  S_L <- 1
  S_C <- 1 + K1 * base::ifelse(symmetric, base::sqrt(C1 * C2), C1)
  S_H <- 1 + K2 * base::ifelse(symmetric, base::sqrt(C1 * C2), C1)

  term1 <- delta_L / (k_L * S_L)
  term2 <- delta_C / (k_C * S_C)
  term3 <- delta_H / (k_H * S_H)
  base::sqrt(term1^2 + term2^2 + term3^2)
}

#' Get the CIEDE2000 color difference between two CIELab values.
#'
#' @param lab_color1 A vector with three components corresponding to a Lab value.
#' @param lab_color2 A vector with three components corresponding to another Lab value.
#' @param k_L Weighting factor for the L component.
#' @param k_C Weighting factor for the C component.
#' @param k_H Weighting factor for the H component.
#' @return The CIEDE2000 color difference between the two given values.
#' @references Sharma, G., Wu, W., & Dalal, E. N. (2005). The CIEDE2000 color-difference formula: Implementation notes, supplementary test data, and mathematical observations. Color Research & Application: Endorsed by Inter-Society Color Council, The Colour Group (Great Britain), Canadian Society for Color, Color Science Association of Japan, Dutch Society for the Study of Color, The Swedish Colour Centre Foundation, Colour Society of Australia, Centre Français de la Couleur, 30(1), 21-30.
ciede2000 <- function(lab_color1, lab_color2, k_L=1, k_C=1, k_H=1) {
  L1 <- lab_color1[1]
  a1 <- lab_color1[2]
  b1 <- lab_color1[3]
  L2 <- lab_color2[1]
  a2 <- lab_color2[2]
  b2 <- lab_color2[3]

  C1 <- base::sqrt(a1^2 + b1^2)
  C2 <- base::sqrt(a2^2 + b2^2)
  C_bar <- (C1 + C2) / 2
  G <- (1 - base::sqrt(C_bar^7 / (C_bar^7 + 25^7))) / 2
  a1p <- (1 + G) * a1
  a2p <- (1 + G) * a2
  C1p <- base::sqrt(a1p^2 + b1^2)
  C2p <- base::sqrt(a2p^2 + b2^2)
  h1p <- base::atan2(b1, a1p) %% (2*base::pi)
  h2p <- base::atan2(b2, a2p) %% (2*base::pi)

  delta_Lp <- L2 - L1
  delta_Cp <- C2p - C1p
  delta_hp <- base::ifelse(C1p * C2p != 0,
                           base::ifelse(base::abs(h2p - h1p) <= base::pi,
                                        h2p - h1p,
                                        h2p - h1p + base::sign(h1p - h2p) * 2 * base::pi),
                           0)
  delta_Hp <- 2 * base::sqrt(C1p * C2p) * base::sin(delta_hp / 2)

  Lp_bar <- (L1 + L2) / 2
  Cp_bar <- (C1p + C2p) / 2
  hp_bar <- base::ifelse(C1p * C2p != 0,
                         base::ifelse(base::abs(h2p - h1p) <= base::pi,
                                      (h1p + h2p) / 2,
                                      -(h1p + h2p + base::sign(2 * base::pi - h1p - h2p) * 2 * base::pi) / 2),
                         h1p + h2p)

  deg2rad <- base::pi / 180
  rad2deg <- 1 / deg2rad
  Tp <- (1 - 0.17 * base::cos(hp_bar - 30 * deg2rad)
         + 0.24 * base::cos(2 * hp_bar)
         + 0.32 * base::cos(3 * hp_bar + 6 * deg2rad)
         - 0.20 * base::cos(4 * hp_bar - 63 * deg2rad))
  delta_theta <- 30 * deg2rad * base::exp(- ((hp_bar * rad2deg - 275) / 25)^2)
  R_C <- 2 * base::sqrt(Cp_bar^7 / (Cp_bar^7 + 25^7))
  S_L <- 1 + ((0.015 * (Lp_bar - 50)^2) / base::sqrt(20 + (Lp_bar - 50)^2))
  S_C <- 1 + 0.045 * Cp_bar
  S_H <- 1 + 0.015 * Cp_bar * Tp
  R_T <- - base::sin(2 * delta_theta) * R_C

  term1 <- delta_Lp / (k_L * S_L)
  term2 <- delta_Cp / (k_C * S_C)
  term3 <- delta_Hp / (k_H * S_H)
  term4 <- R_T * term2 * term3

  base::sqrt(term1^2 + term2^2 + term3^2 + term4)
}

#' Get the color difference between values in the CIELab color space.
#'
#' @param color A matrix whose rows specify color coordinates in the CIELab color space.
#' @param reference A reference color.
#' @param metric The color metric, between CIE76, CIE94, and CIEDE2000.
#' @param ... Weighting factors `k_L`, `k_C`, `k_H`, `K1`, and/or `K2` for CIE94 and CIEDE2000, if applicable. Also, `symmetric=TRUE` to use a symmetric version of CIE94.
#' @return The color difference between the two given values.
#' @references Sharma, G., & Bala, R. (Eds.). (2017). Digital color imaging handbook. CRC press.
#' Sharma, G., Wu, W., & Dalal, E. N. (2005). The CIEDE2000 color-difference formula: Implementation notes, supplementary test data, and mathematical observations. Color Research & Application: Endorsed by Inter-Society Color Council, The Colour Group (Great Britain), Canadian Society for Color, Color Science Association of Japan, Dutch Society for the Study of Color, The Swedish Colour Centre Foundation, Colour Society of Australia, Centre Français de la Couleur, 30(1), 21-30.
#' @export
#' @examples
#' colordiff(rbind(c(50, 2.6772, -79.7751),
#'                 c(50, 3.1571, -77.2803),
#'                 c(50, 2.8361, -74.0200)), c(50, 0, -82.7485))
#' colordiff(rbind(c(50, 2.6772, -79.7751),
#'                 c(50, 3.1571, -77.2803),
#'                 c(50, 2.8361, -74.0200)), c(50, 0, -82.7485), metric="CIE94")
#' colordiff(rbind(c(50, 2.6772, -79.7751),
#'                 c(50, 3.1571, -77.2803),
#'                 c(50, 2.8361, -74.0200)), c(50, 0, -82.7485), metric="CIE94", symmetric=TRUE)
colordiff <- function(color, reference, metric="CIEDE2000", ...) {
  distance <- switch(tolower(metric),
                     cie76=cie76,
                     cie94=cie94,
                     ciede2000=ciede2000)
  if (is.null(distance)) stop("The available metrics are 'CIE76', 'CIE94', and 'CIEDE2000'")
  if (is.vector(color)) color <- rbind(color)

  color %>%
    purrr::array_branch(1) %>%
    purrr::map_dbl(function(c) {
      distance(reference, c, ...)
    })
}
