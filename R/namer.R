
#' Get information about the closest RHS color to some CIELab coordinates.
#'
#' @param L The lightness L* of the color.
#' @param a The chromatic component a* (red-green).
#' @param b The chromatic component b* (blue-yellow).
#' @return A one-row tibble
#' @importFrom magrittr %>%
#' @export
#' @examples
#' get_closest_color(65, 20, -20)
get_closest_color <- function(L, a, b) {
  rhs %>%
    dplyr::inner_join(upov, by=c("RHS")) %>%
    dplyr::mutate(lab_diff=sqrt((.[["L"]] - !!L )^2 + (.[["a"]] - !!a)^2 + (.[["b"]] - !!b)^2)) %>%
    dplyr::slice_min(lab_diff)
}

#' Name a color given its coordinates in a specified color space.
#'
#' @param color A matrix whose rows specify colors.
#' @param colorspace The color space the coordinates of the colors are in.
#' @param illuminant The reference white, or `NULL` if not needed.
#' @param language The language of the color name, between English, French, German, and Spanish.
#' @return The name of the color, according to the UPOV.
#' @importFrom grDevices convertColor
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
                     fr="français",
                     french="français",
                     français="français",
                     de="deutsch",
                     german="deutsch",
                     deutsch="deutsch",
                     es="español",
                     spanish="español",
                     español="español")
  if (is.null(language)) stop("Unavailable language")
  color %>%
    convertColor(from={{ colorspace }}, from.ref.white={{ illuminant }},
                 to="Lab", to.ref.white="D65") %>%
    purrr::array_branch(1) %>%
    purrr::map_chr(function (c) {
      get_closest_color(c[1], c[2], c[3])[[ {{ language }}]]
    })
}
