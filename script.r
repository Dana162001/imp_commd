options(repos = c(CRAN = "https://cran.rstudio.com/"))

#if (!require("devtools", quietly = TRUE))
 #   install.packages("devtools")
#devtools::install_github("SONGDONGYUAN1994/scDesign3")

library(tidyr)
library(scDesign3)
library(SingleCellExperiment)
library(ggplot2)
library(dplyr)
library(viridis)
theme_set(theme_bw())

#example_sce <- readRDS('/work/rwth1209/dana_projects/R/scDesign3/data/2022PK2_clustered.rds')
#print(example_sce)

example_sce <- readRDS("/work/rwth1209/dana_projects/R/scDesign3/data/sce_2022PK2_clustered.rds")
print(example_sce)

#example_sce <- example_sce[1:10, ]

# set.seed(123)
# example_simu <- scdesign3(
#     sce = example_sce,
#     assay_use = "counts",
#     celltype = "merged",
#     pseudotime = NULL,
#     spatial = NULL,
#     other_covariates = NULL,
#     mu_formula = NULL,
#     sigma_formula = "1",
#     family_use = "nb",
#     n_cores = 2,
#     usebam = FALSE,
#     corr_formula = "1",
#     copula = "gaussian",
#     DT = TRUE,
#     pseudo_obs = FALSE,
#     return_model = FALSE,
#     nonzerovar = FALSE
#   )

set.seed(123)
example_simu <- scdesign3(
    sce = example_sce,
    assay_use = "counts",
    celltype = "merged",
    pseudotime = NULL,
    spatial = NULL,
    other_covariates = NULL,
    mu_formula = 'merged',
    sigma_formula = "1",
    family_use = "nb",
    n_cores = 2,
    usebam = FALSE,
    corr_formula = "1",
    copula = "gaussian",
    DT = TRUE,
    pseudo_obs = FALSE,
    return_model = FALSE,
    nonzerovar = FALSE
  )

logcounts(example_sce) <- log1p(counts(example_sce))
simu_sce <- example_sce
counts(simu_sce) <- example_simu$new_count
logcounts(simu_sce) <- log1p(counts(simu_sce))

# Convert sparse matrix to a dense matrix
dense_counts <- as.matrix(counts(example_sce))

# Apply log1p transformation and create a data frame
VISIUM_dat_test <- data.frame(t(log1p(dense_counts)))

# Convert the data frame to a tibble
VISIUM_dat_test <- as_tibble(VISIUM_dat_test)

# Add spatial information to the tibble using mutate() and across()
VISIUM_dat_test <- VISIUM_dat_test %>%
  mutate(across(everything(), list(~ .), .names = "{.col}_Expression")) %>%
  mutate(X = colData(example_sce)$spatial1, Y = colData(example_sce)$spatial2)

# Pivot the data to long format
VISIUM_dat_test <- pivot_longer(VISIUM_dat_test, -c("max_x", "max_y"), names_to = "Gene", values_to = "Expression")

# Add the "Method" column with the value "Reference"
VISIUM_dat_test <- mutate(VISIUM_dat_test, Method = "Reference")
In this approach, we use across() with mutate() to apply the same transformation to all columns in VISIUM_dat_test (the expression values) while keeping the original column names and adding the suffix "_Expression." Then, we add the spatial information (X and Y columns) to the tibble, and the rest of the code remains unchanged.

This should fix the previous error, and you should be able to successfully add the spatial information to the VISIUM_dat_test tibble and pivot the data to long format.









#VISIUM_dat_test <- data.frame(t(log1p(counts(example_sce)))) %>% as_tibble() %>% dplyr::mutate(X = colData(example_sce)$spatial1, Y = colData(example_sce)$spatial2) %>% tidyr::pivot_longer(-c("X", "Y"), names_to = "Gene", values_to = "Expression") %>% dplyr::mutate(Method = "Reference")
VISIUM_dat_scDesign3 <- data.frame(t(log1p(counts(simu_sce)))) %>% as_tibble() %>% dplyr::mutate(X = colData(simu_sce)$spatial1, Y = colData(simu_sce)$spatial2) %>% tidyr::pivot_longer(-c("X", "Y"), names_to = "Gene", values_to = "Expression") %>% dplyr::mutate(Method = "scDesign3")
VISIUM_dat <- bind_rows(VISIUM_dat_test, VISIUM_dat_scDesign3) %>% dplyr::mutate(Method = factor(Method, levels = c("Reference", "scDesign3")))

VISIUM_dat %>% filter(Gene %in% rownames(example_sce)[1:5]) %>% ggplot(aes(x = X, y = Y, color = Expression)) + geom_point(size = 0.5) + scale_colour_gradientn(colors = viridis_pal(option = "magma")(10), limits=c(0, 8)) + coord_fixed(ratio = 1) + facet_grid(Method ~ Gene )+ theme_gray()