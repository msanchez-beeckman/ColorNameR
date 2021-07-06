
#' Get information about the closest RHS color to some CIELab coordinates.
#'
#' @param L The lightness L* of the color.
#' @param a The chromatic component a* (red-green).
#' @param b The chromatic component b* (blue-yellow).
#' @param metric The color distance to use.
#' @return A one-row tibble.
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @export
#' @examples
#' get_closest_color(65, 20, -20)
get_closest_color <- function(L, a, b, metric="CIEDE2000") {
  ColorNameR::rhs_color_values_2007 %>%
    dplyr::inner_join(ColorNameR::rhs_color_names_2015, by=c("RHS")) %>%
    dplyr::mutate(lab_diff=ColorNameR::colordiff(cbind(.data[["L"]], .data[["a"]], .data[["b"]]), c({{ L }}, {{ a }}, {{ b }}), metric={{ metric}})) %>%
    dplyr::slice_min(.data[["lab_diff"]], with_ties=FALSE)
}

#' Name a color given its coordinates in a specified color space.
#'
#' @param color A matrix whose rows specify colors.
#' @param colorspace The color space the coordinates of the colors are in.
#' @param illuminant The reference white, or `NULL` if not needed.
#' @param language The language of the color name, between English, French, German, and Spanish.
#' @return The name of the color, according to the UPOV.
#' @details
#' The available color spaces are `"XYZ"`, `"sRGB"`, `"Apple RGB"`, `"CIE RGB"`, `"Luv"`, and `"Lab"` (default).
#' If the color space is an RGB variant, the coordinates must take values between 0 and 1.
#' @export
#' @examples
#' name(c(65, 20, -20))
#' name(c(65, 20, -20), language="Spanish")
#' name(c(65, 20, -20), language="es")
#' name(c(244/255, 234/255, 184/255), colorspace="sRGB")
#' name(rbind(c(65, 20, -20), c(69, 4, -31)))
name <- function(color, colorspace="Lab", illuminant=NULL, language="english") {
  language <- switch(tolower(language),
                     en="english",
                     english="english",
                     fr="french",
                     french="french",
                     de="german",
                     german="german",
                     es="spanish",
                     spanish="spanish")
  if (is.null(language)) stop("Unavailable language")
  color %>%
    grDevices::convertColor(from={{ colorspace }}, from.ref.white={{ illuminant }},
                            to="Lab", to.ref.white="D65") %>%
    purrr::array_branch(1) %>%
    purrr::map_chr(function(c) {
      get_closest_color(c[1], c[2], c[3])[[ {{ language }}]]
    })
}
