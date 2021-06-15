
#' Get information about the closest RHS color to some CIELab coordinates.
#'
#' @param L The lightness L* of the color.
#' @param a The chromatic component a* (red-green).
#' @param b The chromatic component b* (blue-yellow).
#' @return A one-row tibble
#' @export
#' @importFrom magrittr %>%
#' @examples
#' get_closest_color(65, 20, -20)
get_closest_color <- function(L, a, b) {
  rhs %>%
    dplyr::inner_join(upov, by=c("RHS")) %>%
    dplyr::mutate(lab_diff=sqrt((.[["L"]] - !!L )^2 + (.[["a"]] - !!a)^2 + (.[["b"]] - !!b)^2)) %>%
    dplyr::slice_min(lab_diff)
}

#' Name a color given its coordinates in the CIELab color space.
#'
#' @param L The lightness L* of the color.
#' @param a The chromatic component a* (red-green).
#' @param b The chromatic component b* (blue-yellow).
#' @param language The language of the color name, between English, French, German, and Spanish.
#' @return The name of the color, according to the UPOV.
#' @export
#' @examples
#' name_color(65, 20, -20)
#' name_color(65, 20, -20, "spanish")
#' name_color(65, 20, -20, "es")
name_color <- function(L, a, b, language="english") {
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
  get_closest_color(L, a, b)[[{{ language }}]]
}
