upov_rhs_translation <- readr::read_csv("data/upov.csv")
rhs_cielab_translation <- readr::read_csv("data/rhs.csv")

get_closest_color <- function(L_, a_, b_) {
  rhs_cielab_translation %>%
    dplyr::inner_join(upov_rhs_translation, by=c("RHS")) %>%
    dplyr::mutate(lab_diff=sqrt((.$L - L_)^2 + (.$a - a_)^2 + (.$b - b_)^2)) %>%
    dplyr::slice_min(lab_diff)
}
