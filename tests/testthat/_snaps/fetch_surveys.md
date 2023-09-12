# fetch_surveys returns a warning when some survey names match

    Code
      x <- fetch_surveys(c("survey_example_1", "survey_example_2", "this wont work"),
      force_request = TRUE)
    Warning <rlang_warning>
      The following `survey_names` were not found in the Qualtrics UI and were skipped:
      x this wont work
    Output
        |                                                                              |                                                                      |   0%  |                                                                              |===================                                                   |  27%  |                                                                              |======================================================================| 100%
    Message <readr_spec_message>
      
      -- Column specification --------------------------------------------------------
      cols(
        .default = col_character(),
        StartDate = col_datetime(format = ""),
        EndDate = col_datetime(format = ""),
        IPAddress = col_logical(),
        Progress = col_double(),
        `Duration (in seconds)` = col_double(),
        Finished = col_logical(),
        RecordedDate = col_datetime(format = ""),
        RecipientLastName = col_logical(),
        RecipientFirstName = col_logical(),
        RecipientEmail = col_logical(),
        ExternalReference = col_logical(),
        LocationLatitude = col_double(),
        LocationLongitude = col_double(),
        UserLanguage = col_logical(),
        Q1_1 = col_double()
      )
      i Use `spec()` for the full column specifications.
    Output
        |                                                                              |                                                                      |   0%  |                                                                              |========================================================              |  80%  |                                                                              |======================================================================| 100%
    Message <readr_spec_message>
      
      -- Column specification --------------------------------------------------------
      cols(
        .default = col_logical(),
        StartDate = col_datetime(format = ""),
        EndDate = col_datetime(format = ""),
        Status = col_character(),
        Progress = col_double(),
        `Duration (in seconds)` = col_double(),
        RecordedDate = col_datetime(format = ""),
        ResponseId = col_character(),
        LocationLatitude = col_double(),
        LocationLongitude = col_double(),
        DistributionChannel = col_character(),
        Q1_1 = col_double(),
        Q2 = col_character(),
        Q3 = col_character(),
        Q4 = col_character(),
        Q5_1 = col_double()
      )
      i Use `spec()` for the full column specifications.

