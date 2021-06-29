
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ColorNameR

<!-- badges: start -->

<!-- badges: end -->

While color coordinates in a space such as RGB or CIELab are useful to
represent colors, a descriptive name is sometimes more appropriate to
distinguish them in a qualitative way. ColorNameR is a small library
that provides a `name()` function

## Installation

You can install the development version of ColorNameR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("msanchez-beeckman/ColorNameR")
```

## Example

``` r
library(ColorNameR)
library(tibble)
library(ggplot2)
library(RColorBrewer)

# palette_colors <- grDevices::palette.colors(15, palette="R4")
palette_colors <- brewer.pal(12, "Paired")
names(palette_colors) <- palette_colors

tibble(color=palette_colors, value=1L) %>%
  dplyr::mutate(name=name(t(col2rgb(.data[["color"]])) / 255, colorspace="sRGB")) %>%
  ggplot(aes(x=color, y=value)) +
    geom_col(aes(fill=color)) +
    geom_label(aes(label=name), position=position_stack(vjust = 0.5)) +
    scale_fill_manual(values=palette_colors) +
    coord_flip()
```

<img src="man/figures/README-example-1.png" width="100%" />
