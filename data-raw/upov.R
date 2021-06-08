
upov_url = 'https://www.upov.int/edocs/mdocs/upov/en/two_51/twp_3_11.docx'

upov <-
  docxtractr::read_docx(upov_url) %>%
  docxtractr::docx_extract_tbl(7) %>%
  dplyr::rename(UPOVGroup = UPOVGroup.No., RHS = No..RHS, english = English)

usethis::use_data(upov)
