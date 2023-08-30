# heRmann 0.0.0.9000

A collection of functions for the Consumer Experience Analytics (CXA) team at Memorial Hermann Health System. Previously found in [riekelib](https://markjrieke.github.io/riekelib/). 

* `deduplicate_ip()`: remove inpatient rehab and pediatric inpatient responses from the inpatient survey file.
* `fetch_surveys()`: fetch survey responses from Qualtrics based on the survey name in the Qualtrics UI.
* `fix_campus_names()`: reformat campus names to a more readable format.
* `fix_survey_names()`: reformat survey names to a more readable format.
* `qnps()`: find a quantile Net Promoter Score based on an observed number of promoters, passives, and detractors.
* `rnps()`: generate random draws of Net Promoter Score based on an observed number of promoters, passives, and detractors.
* `read_recodes()`: read in the most recent set of recodes from a version-controlled source.
* `set_recode_path()`: store a path to version-controlled recodes in your .Renviron.
