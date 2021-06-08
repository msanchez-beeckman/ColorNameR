
rhs_urls = c('https://web.archive.org/web/20200128184152/http://rhscf.orgfree.com/a.html',
             'https://web.archive.org/web/20200128184157/http://rhscf.orgfree.com/b.html',
             'https://web.archive.org/web/20200128184324/http://rhscf.orgfree.com/c.html',
             'https://web.archive.org/web/20210211205226/http://rhscf.orgfree.com/d.html')

read_rhs <- function(rhs_url) {
  rvest::read_html(rhs_url) %>%
    rvest::html_table() %>%
    .[[1]] %>%
    dplyr::slice(-(1:2)) %>%
    dplyr::transmute(RHS=X1,
                     R=as.integer(X4), G=as.integer(X5), B=as.integer(X6),
                     L=as.integer(X8), a=as.integer(X9), b=as.integer(X10),
                     L2=as.integer(X12), C=as.integer(X13), h=as.integer(X14))
}

rhs <-
  purrr::map(rhs_urls, read_rhs) %>%
  purrr::reduce(dplyr::full_join)

usethis::use_data_raw("rhs")
