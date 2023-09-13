generate_fake_data <- function() {
  
  inpatient <- 
    tibble::tibble(UNIQUE_ID = c("12345", "23456", "34567", "45678", "56789", "67890"),
                   campus = c("Children's Memorial Hermann Hospital", 
                              rep("Memorial Hermann - Texas Medical Center", 5)),
                   response = sample(c("Promoter", "Passive", "Detractor"),
                                     size = 6,
                                     replace = TRUE,
                                     prob = c(0.75, 0.15, 0.1)))
  
  pedi_inpatient <- inpatient[1,]
  inpatient_rehab <- inpatient[2:3,]
  
  surveys <- 
    dplyr::bind_cols(survey_name = c("Live - Inpatient",
                                     "Live - Pediatric Inpatient",
                                     "Live - Adult Inpatient Rehab"),
                     responses = dplyr::bind_rows(inpatient |> tidyr::nest(responses = dplyr::everything()),
                                                  pedi_inpatient |> tidyr::nest(responses = dplyr::everything()),
                                                  inpatient_rehab |> tidyr::nest(responses = dplyr::everything())))
  
  return(surveys)
  
}

