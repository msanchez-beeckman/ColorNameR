
#' @importFrom tibble tibble
NULL

#' RHS colors in different color spaces.
#'
#' Dataset containing the coordinates in RGB, CIELab, and CIELCh of the colors
#' defined by the Royal Horticultural Society in its fifth edition (2007).
#'
#' @format A data frame with 892 rows and 10 variables:
#' \describe{
#'   \item{RHS}{the RHS code of the color}
#'   \item{R}{the red component in sRGB}
#'   \item{G}{the green component in sRGB}
#'   \item{B}{the blue component in sRGB}
#'   \item{L}{the lightness component in CIELab (D65 / 10º)}
#'   \item{a}{the red-green component in CIELab (D65 / 10º)}
#'   \item{b}{the blue-yellow component in CIELab (D65 / 10º)}
#'   \item{L2}{the lightness component in CIELCh (D65 / 10º)}
#'   \item{C}{the colorfulness component in CIELCh (D65 / 10º)}
#'   \item{h}{the hue in CIELCh (D65 / 10º)}
#' }
#' @source \url{http://rhscf.orgfree.com/}
"rhs"

#' UPOV names and groups for RHS colors.
#'
#' Dataset containing English, French, German, and Spanish names for the colors
#' defined by the RHS in its sixth edition (2015), alongside their UPOV group
#' number.
#'
#' @format A data frame with 920 rows and 10 variables:
#' \describe{
#'   \item{UPOVGroup}{the UPOV group of the color}
#'   \item{RHS}{the RHS code of the color}
#'   \item{english}{the English name for the color}
#'   \item{français}{the French name for the color}
#'   \item{deutsch}{the German name for the color}
#'   \item{español}{the Spanish name for the color}
#' }
#' @source \url{'https://www.upov.int/edocs/mdocs/upov/en/two_51/twp_3_11.docx}
"upov"
