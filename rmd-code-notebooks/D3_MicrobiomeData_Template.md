# 0. Setup

``` r
groundhog::groundhog.library(c("tidyverse","here"), "2025-10-01")
```

    ## groundhog says: No default repository found, setting to 'http://cran.r-project.org/'

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.1.4     ✔ readr     2.1.5
    ## ✔ forcats   1.0.1     ✔ stringr   1.5.2
    ## ✔ ggplot2   4.0.0     ✔ tibble    3.3.0
    ## ✔ lubridate 1.9.4     ✔ tidyr     1.3.1
    ## ✔ purrr     1.1.0     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
    ## here() starts at /Users/sxmorgan/Desktop/ds_iai
    ## 
    ## [36mSuccessfully attached 'tidyverse_2.0.0'[0m
    ## 
    ## [36mSuccessfully attached 'here_1.0.2'[0m

``` r
# if that doesn't work, uncomment and try:
# library(tidyverse)
# library(here)
```

> **Today:** load **raw bacterial counts**, compute **relative
> abundance**, apply **prevalence/abundance filters**, learn
> **log10(x+1e-05)** transform, join count and metadata tables, make
> clear comparisons of bacterial relative abundances between groups of
> interest (e.g. CRC-CTR).

# 0. Create folders

``` r
# ASSUMING that here() returns whatever folder you are working out of for the assignment -- if it doesn't, FIRST navigate to and set your working directory properly! (and/or alter the code below as required to read in the metadata and count tables).

# If you want futher practice reading from an organized/hierarchical folder structure, you can create subfolders in the assignment folder for code and data. In the code folder, add the helper_day3.r script and add any .tsv files to the data folder. 
# here() # if correct, proceed
# dir.create("data")
# dir.create("code")

# If you struggled with file so far, don't worry. We prefer you focus on the learning objectives, so feel free to keep everything related to this assignment in one folder (scripts, Rmds, data, etc). We just want you to know how to read in a file we give you, we don't care how you store and access it.
```

# 1. Load data

This chunk assumes you have a subfolder named “data” in whatever folder
you are working out of for the assignment (which should be returned when
you call the here() function – if not, navigate to and set your working
directory! and/or alter the code below to read in the metadata and count
tables).

``` r
# read in files
# meta <- read_tsv( ) 
# counts <- read_tsv( )
```

# 2. Load helper functions

``` r
# load custom functions from helper_day3 script into global environment
# source( )
```

# 3. Data transformation and pre-processing

Aim: Apply common pre-processing transformations to microbiome count
data.

Steps: use the `counts_to_relab()` helper function to convert `counts`
to relative abundances and save it as `relab`. Then apply the indicated
filtering criteria using the `filter_features()` helper function.
Finally, apply a log10 transform with `log_transform()`.

Question: how many columns are there before and after filtering? What
about bacteria? (Answer: 855 and 136, 854 and 135, respectively)

``` r
# working with wide/"untidy" data so we can better see the impact of new transformations

# convert counts to proportions 
# relab <-

# check impact on counts

# filter choices: relab_threshold = 0.001, prevalence_threshold = 0.05
# relab_filt <- 

# check dimension before and after

# log transformation
# relab_log <- 

# check impact on relative abundances
```

# 4. Reshaping data frames

Aim: Learn how to build an annotated tidy data frame suitable for
visualization.

Steps: From `relab_filt`, make a long, tidy data frame. Add a column
that log10 transforms the relative abundances with a pseudocount of
1e-05. Join the metadata table by the common Sample_ID column.

Joining and pivoting are two concepts we introduce here, worth
practicing if you want/need to work with data someday:
<https://github.com/gadenbuie/tidyexplain?tab=readme-ov-file#mutating-joins>

``` r
# we can use mutate with a hard-coded pseudocount and bypass our function, if our data is tidy...

# dat_annot <- relab_filt |>
  # make long and tidy
  # log transfrom (mutate)
  # join metadata table
  # reorder columns if you like

# head(dat_annot)
```

# 4. Visualizing data: composition and comparison

Aim: learn how to sort, filter, and plot data based on quantities we
calculate (e.g. mean relative abundance per taxon).

Steps: calculate the mean relative abundance per taxon using
`summarize(mean_val = ...)` (tip: `group_by(genus)` first). Filter out
the reads/abundances which were not assigned a bacterial taxon during
profiling. Find the 10 genera with the highest mean relative abundance
across the Yang dataset. Plot these in CRC vs CTR boxplots WITH points
overlaid (hint: two different geom_s). Use `+ facet_wrap(~ genus)` to
make 1 plot for each of the top 10 you identify.

``` r
# get a list of top N bacteria by (raw) mean relative abundance (NOT log transformed)
# topN <- dat_annot |>
  # calculate the mean relative abundance per taxon (summarize across samples/observations)
  # sort the rows from largest (top) to smallest
  # filter out the unassigned fraction
  # look at top 10
  # pull genus names

# save a tibble with all data for only the topN genera
# dat_top <- 

# plot case-control boxplots (with points) of top 10 most abundant bacteria 
# dat_top |>
```

# 5. Exercises

## Exercise 1 — Threshold sensitivity

- Repeat prevalence filtering with **0.05**, **0.10**, **0.20** (keep
  relab_threshold fixed at `0.001`).
- Make a small tibble reporting the number of retained features at each
  setting.
- Write a sentence summarizing the impact of prevalence filtering.

``` r
# YOUR CODE HERE
```

## Exercise 2 — Filter/focus on different group of bacteria

- Look at all 4 Eubacterium taxa. (Hint: use
  `filter(str_detect(genus, 'Eubacterium'))`)
- Make **boxplot + point graphs** of their values by `Condition`.
- Write 2–3 sentences interpreting the pattern.

``` r
# YOUR CODE HERE
```

## Exercise 3 — Top taxa by prevalence

- Calculate the prevalence per taxon (sum of values that are not 0
  divided by the total number of values), similar to how we calculated
  the mean abundances
- Describe the prevalences in a sentence or two using some statistical
  summaries.
- What is the most prevalent bacteria? Do a google search and record
  something you learned about it.

``` r
# YOUR CODE HERE
```

## Exercise 4 — Top taxa per sample (new plot type)

- Build a stacked **bar plot** of the **top 10 taxa**, maybe across a
  **subset of samples** (you decide how to select or filter).
- Save the figure to `results/`.

``` r
# YOUR CODE HERE
```
