#Analysis blood metabolomic data
install.packages("tidyverse")
library(tidyverse)
library(dplyr)
#getwd()

#data <-read.csv("metaResults.csv",TRUE,",")
#print(data)


#Read the biomarker concentration file
df_nmr_results <- readr::read_csv(file = "c:\\Users\\compu\\Downloads\\metabolomics_data\\metaResults.csv",
                                  #remone not only NA(not available data=missing data)but also TAG string as na
                                  na = c("NA", "TAG"),
                                  col_types = cols(.default = col_double(),Sample_id = col_character()))
names(df_nmr_results)

df_nmr_results <- 
  df_nmr_results %>%
  dplyr::select(
    .data$Sample_id,
    tidyselect::any_of(
      ggforestplot::df_NG_biomarker_metadata$machine_readable_name
    )
  )

# Assume that your data frame, containing alternative biomarker names, is called 
# df_nmr_results_alt_names

install.packages("purrr")
install.packages("magrittr")
library(magrittr)
install.packages("dplyr")
library(dplyr)
install.packages("usethis")
install.packages("devtools")
library(devtools)

R.version
devtools::install_github("NightingaleHealth/ggforestplot", force = TRUE)
install.packages('Rcpp')
devtools::install_github("NightingaleHealth/ggforestplot", build_vignettes = TRUE, force = TRUE)
install.packages("forestplot")

install.packages("ggforestplot")
library(ggforestplot)

library(dplyr)



alt_names <- 
  names(df_nmr_results)

new_names <- 
  alt_names %>% 
  purrr::map_chr(function(id) {
    # Look through the alternative_ids
    hits <-
      purrr::map_lgl(
        df_NG_biomarker_metadata$alternative_names,
        ~ id %in% .
      )
    
    # If one unambiguous hit, return it.
    if (sum(hits) == 1L) {
      return(df_NG_biomarker_metadata$machine_readable_name[hits])
      # If not found, give a warning and pass through the input.
    } else {
      warning("Biomarker not found: ", id, call. = FALSE)
      return(id)
    } 
  })

# Name the vector with the new names  
names(alt_names) <- new_names

# Rename your result data frame with machine_readable_names 
df_nmr_results_alt_names <- 
  df_nmr_results %>% 
  rename(!!alt_names)


# Read the clinical_data.csv data file
df_clinical_data <- readr::read_csv(
  # Enter the correct location for your file below
  file = "/path/to/file/clinical_data.csv") %>%
  # Rename the identifier column to Sample_id as in the NMR result file
  rename(Sample_id = identifier) %>% 
  # Harmonize the id entries in clinical data with the ids in the NMR data 
  mutate(Sample_id = paste0(
    "ResearchInstitutionProjectLabId_", 
    as.numeric(Sample_id)
  ))

# Join NMR result file with the clinical data using column "Sample_id"
df_full_data <- dplyr::left_join(
  x = df_nmr_results,
  y = df_clinical_data,
  by = "Sample_id"
)


# Join NMR result file with the clinical data using column "Sample_id"
df_full_data <- dplyr::left_join(
  x = df_nmr_results,
  y = df_clinical_data,
  by = "Sample_id"
)


df_full_data %>% 
  # Add a column to mark obese/non-obese subjects
  mutate(obesity = ifelse(BMI >= 30, yes = "Obese", no = "Not obese")) %>% 
  # Filter out subjects with missing values (if any)
  filter(!is.na(obesity)) %>% 
  # Box plots for each group
  ggplot(aes(y = GlycA, x = obesity, color = obesity)) +
  geom_boxplot() + 
  # Remove x axis title 
  theme(axis.title.x = element_blank())


# Extract names of NMR biomarkers
nmr_biomarkers <- dplyr::intersect(
  ggforestplot::df_NG_biomarker_metadata$machine_readable_name,
  colnames(df_nmr_results)
)

# NMR biomarkers here should be 250
stopifnot(length(nmr_biomarkers) == 250)

# Select only variables to be used for the model and collapse to a long data 
# format
df_long <-
  df_full_data %>%
  # Select only model variables
  dplyr::select(tidyselect::all_of(nmr_biomarkers), gender, baseline_age, BMI) %>%
  # Log-transform and scale biomarkers
  dplyr::mutate_at(
    .vars = dplyr::vars(tidyselect::all_of(nmr_biomarkers)),
    .funs = ~ .x %>% log1p() %>% scale %>% as.numeric()
  ) %>%
  # Collapse to a long format
  tidyr::gather(
    key = biomarkerid,
    value = biomarkervalue,
    tidyselect::all_of(nmr_biomarkers)
  )

# Estimate sex- and age-adjusted associations of metabolite to BMI
df_assoc_per_biomarker_bmi <-
  ggforestplot::discovery_regression(
    df_long = df_long,
    model = "lm",
    formula =
      formula(
        biomarkervalue ~ BMI + factor(gender) + baseline_age
      ),
    key = biomarkerid,
    predictor = BMI
  ) %>% 
  # Join this dataset with the grouping data in order to choose a different 
  # biomarker naming option
  left_join(
    select(
      df_NG_biomarker_metadata, 
      name,
      biomarkerid = machine_readable_name
    ), 
    by = "biomarkerid")

head(df_assoc_per_biomarker_bmi)

ggforestplot::df_NG_biomarker_metadata %>% 
  pull(group) %>% 
  unique()













