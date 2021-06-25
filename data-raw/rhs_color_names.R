
upov_url = 'https://www.upov.int/edocs/mdocs/upov/en/two_51/twp_3_11.docx'

rhs_color_names <-
  docxtractr::read_docx(upov_url) %>%
  docxtractr::docx_extract_tbl(7) %>%
  dplyr::rename(UPOVGroup = UPOVGroup.No., RHS = No..RHS,
                english = English, french = français, german = deutsch,
                spanish = español)

readr::write_csv(rhs_color_names, 'data-raw/rhs_color_names.csv')
usethis::use_data(rhs_color_names)
