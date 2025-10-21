> **Today:** set up folders, load packages, introduction to R variables
> and data structures, data frames and tibbles, key data manipulation
> verbs (`select`, `filter`, `mutate`, and `arrange`), and some basic
> plots.

# 0. Setup

``` r
# wd = working directory 
getwd() # where are we working from?
```

    ## [1] "/Users/sxmorgan/Desktop/ds_iai/rmd-code-notebooks"

The chunk below is the code from Brightspace to install the required
packages. BEFORE you run it: please make a folder the “Files” tab in the
bottom right of RStudio is a folder where you will work out of for the
assignment. In class we made one called `ds_iai` and opened a new R
Markdown file inside it.

``` r
# 2.1 install the groundhog package and other packages needed for the course
# install.packages('groundhog', version = '3.2.3')
# install.packages('tidyverse', version = '2.0.0')
# install.packages('here', version = '1.0.2')

# 2.2. attach the groundhog package, to activate taking a "snapshot" of versions
library(groundhog)
```

    ## groundhog says: No default repository found, setting to 'http://cran.r-project.org/'

    ## Attached: 'Groundhog' (Version: 3.2.3)

    ## Tips and troubleshooting: https://groundhogR.com

``` r
# 2.3 pick october 1st as a common reference date and install the packages
groundhog.library(c('here','tidyverse'), "2025-10-01")
```

    ## here() starts at /Users/sxmorgan/Desktop/ds_iai

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
    ## [36mSuccessfully attached 'here_1.0.2'[0m
    ## 
    ## [36mSuccessfully attached 'tidyverse_2.0.0'[0m

Some of you had issues with the `groundhog` package. If that’s you:
please forget about the `groundhog` package. As long as you have the
`tidyverse` and `here` packages installed (and your versions aren’t
really old) – you should be fine. Try uncommenting and running the code
below if you’re (still) having issues.

``` r
# if that still doesn't work: just make sure you have the tidyverse and here packages installed
# install.packages('tidyverse', version = '2.0.0')
# install.packages('here', version = '1.0.2')

# and in the very worst case, try without the version argument, and then use sessionInfo() to check what version you use
# library(tidyverse)
# library(here)
# sessionInfo()
```

# 1. Variables and vectors

There are several “types” of variables in R,

- `chr`: characters or “strings”
- `num`: numeric, can be either integers (1, 2, 3) or double (1, 1.21),
  sometimes called a “continuous” variable
- `fct`: factor, a categorical variable which can be chr or num type!
  sometimes called a “discrete” variable
- `lgl`: boolean, value can be either true or false

We’ll explore these more when we look at real clinical patient data in
the next days.

``` r
x <- "hello" # single string, saved as x
y <- c("my", "first", "vector") # vector of strings, saved as y
z <- c(1, 2, 8, 4) # vector of integers (num), saved as z

# how are factors different than numeric vectors
w <- as_factor(z)
# alternatively:
# w <- factor(z, levels = sort(z))
# bonus: how is the line (function) below different from those above, and why would we (generally) prefer those above?
# w <- as.factor(z)

# how to learn about your variables
typeof(x)
```

    ## [1] "character"

``` r
class(x)
```

    ## [1] "character"

``` r
typeof(z)
```

    ## [1] "double"

``` r
length(y)
```

    ## [1] 3

``` r
levels(w)
```

    ## [1] "1" "2" "4" "8"

``` r
# how to find help
?mean
help.search("median")
```

PS: in general, it’s better to give variables informative names! (Not x
and y)

# 2. Operators and functions

Operators and functions are two critical concepts to “do” things in R.
Operators are symbols that perform specific actions, while functions are
named commands that take inputs (called “arguments”) in parentheses, and
do more complex tasks.

We started the coding demo on day 1 with a function – `getwd()`. The
five lines under “\# how to learn about your variables” in the code
chunk above are also functions.

We also discussed a few operators, which you’ll be comfortable with by
the end of the assignment:

- the assignment operator is a backwards arrow used to assign things
  (`variable_name <- variable_value`)
- the pipe operator is used to chain or combine multiple functions can
  either be %\>% or \|\>
- the plus operator is used after a `ggplot()` function has been invoked
  to add plot options (layers, as we’ll call them later)

``` r
# basic functions for numeric vectors
z_mean <- mean(z)
z_med <- median(z)

# print
z_mean
```

    ## [1] 3.75

``` r
z_med
```

    ## [1] 3

``` r
# these both give warnings, why?
mean(y) 
```

    ## Warning in mean.default(y): argument is not numeric or logical: returning NA

    ## [1] NA

``` r
mean(w) 
```

    ## Warning in mean.default(w): argument is not numeric or logical: returning NA

    ## [1] NA

``` r
# putting it all together
weights <- c(23.5, 24.1, 23.8, 24.3)  # <- is the assignment operator
average_weight <- mean(weights)       # mean() is a function
difference <- 24.5 - average_weight   # - is the subtraction operator
```

Tip: one final operator that is less common (not part of this
assignment) but useful to know in R is the :: operator. It is used to
invoke a function from a specific package. For example, instead of
loading the `here` package (`library(here)`) and then calling the
`here()` function, you could just type `here::here()` and R will pull
the right function.

# 3. Data frames and tibbles

Data frames are the most common data structure you’ll encounter doing
real data analysis in R – think of it as the R version of an Excel
table. It is similar to a matrix in that it also has row and column
attributes, but different in that its columns, for example, can be of
multiple data types (only 1 for matrices).

There are several built-in datasets in R: `mtcars` (cars) and `iris`
(flowers) are two of the most popular. In class and in the example we
worked with `mtcars` – complete the chunks below with `iris` for a bit
more of a challenge.

``` r
# We'll start with a built-in dataset (a data.frame)
df <- mtcars
# df <- iris

# prints the first 6 rows of any data frame object
head(df)
```

    ##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
    ## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
    ## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
    ## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
    ## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
    ## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
    ## Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1

``` r
# accession with [row, column] indices, starting at 1, not 0
df[1,1]
```

    ## [1] 21

``` r
# other things to look at 
dim(df)
```

    ## [1] 32 11

``` r
rownames(df)
```

    ##  [1] "Mazda RX4"           "Mazda RX4 Wag"       "Datsun 710"         
    ##  [4] "Hornet 4 Drive"      "Hornet Sportabout"   "Valiant"            
    ##  [7] "Duster 360"          "Merc 240D"           "Merc 230"           
    ## [10] "Merc 280"            "Merc 280C"           "Merc 450SE"         
    ## [13] "Merc 450SL"          "Merc 450SLC"         "Cadillac Fleetwood" 
    ## [16] "Lincoln Continental" "Chrysler Imperial"   "Fiat 128"           
    ## [19] "Honda Civic"         "Toyota Corolla"      "Toyota Corona"      
    ## [22] "Dodge Challenger"    "AMC Javelin"         "Camaro Z28"         
    ## [25] "Pontiac Firebird"    "Fiat X1-9"           "Porsche 914-2"      
    ## [28] "Lotus Europa"        "Ford Pantera L"      "Ferrari Dino"       
    ## [31] "Maserati Bora"       "Volvo 142E"

``` r
# glimpse is a useful function, especially for data frames which do not give an overview of variable types
glimpse(df)
```

    ## Rows: 32
    ## Columns: 11
    ## $ mpg  <dbl> 21.0, 21.0, 22.8, 21.4, 18.7, 18.1, 14.3, 24.4, 22.8, 19.2, 17.8,…
    ## $ cyl  <dbl> 6, 6, 4, 6, 8, 6, 8, 4, 4, 6, 6, 8, 8, 8, 8, 8, 8, 4, 4, 4, 4, 8,…
    ## $ disp <dbl> 160.0, 160.0, 108.0, 258.0, 360.0, 225.0, 360.0, 146.7, 140.8, 16…
    ## $ hp   <dbl> 110, 110, 93, 110, 175, 105, 245, 62, 95, 123, 123, 180, 180, 180…
    ## $ drat <dbl> 3.90, 3.90, 3.85, 3.08, 3.15, 2.76, 3.21, 3.69, 3.92, 3.92, 3.92,…
    ## $ wt   <dbl> 2.620, 2.875, 2.320, 3.215, 3.440, 3.460, 3.570, 3.190, 3.150, 3.…
    ## $ qsec <dbl> 16.46, 17.02, 18.61, 19.44, 17.02, 20.22, 15.84, 20.00, 22.90, 18…
    ## $ vs   <dbl> 0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0,…
    ## $ am   <dbl> 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0,…
    ## $ gear <dbl> 4, 4, 4, 3, 3, 3, 3, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 4, 4, 4, 3, 3,…
    ## $ carb <dbl> 4, 4, 1, 1, 2, 1, 4, 2, 2, 4, 4, 3, 3, 3, 4, 4, 4, 1, 2, 1, 1, 2,…

The tidyverse has its own “class” or type of data frame (named after the
package it comes from) that we discussed: a `tibble`. This is
functionally equivalent to a data frame, but it makes viewing a little
more pleasant (especially in the console), which will become important
once we get into “bigger” data in the coming days.

Data frames have rownames and tibbles don’t! So we have to use a special
command, `rownames_to_column()` when saving one of the built-in datasets
as a variable.

``` r
# why not this?
# cars <- as_tibble(df)

# correct way
cars <- df |> 
  rownames_to_column(var = "car_model") |>
  as_tibble()

# no need to use head() to print a tibble - it always prints the first 10 rows and that's it
cars
```

    ## # A tibble: 32 × 12
    ##    car_model     mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
    ##    <chr>       <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
    ##  1 Mazda RX4    21       6  160    110  3.9   2.62  16.5     0     1     4     4
    ##  2 Mazda RX4 …  21       6  160    110  3.9   2.88  17.0     0     1     4     4
    ##  3 Datsun 710   22.8     4  108     93  3.85  2.32  18.6     1     1     4     1
    ##  4 Hornet 4 D…  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1
    ##  5 Hornet Spo…  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2
    ##  6 Valiant      18.1     6  225    105  2.76  3.46  20.2     1     0     3     1
    ##  7 Duster 360   14.3     8  360    245  3.21  3.57  15.8     0     0     3     4
    ##  8 Merc 240D    24.4     4  147.    62  3.69  3.19  20       1     0     4     2
    ##  9 Merc 230     22.8     4  141.    95  3.92  3.15  22.9     1     0     4     2
    ## 10 Merc 280     19.2     6  168.   123  3.92  3.44  18.3     1     0     4     4
    ## # ℹ 22 more rows

## Core data manipulation functions

Now think back to an Excel table – what are some things you do with one
of those when you’re looking for something? Think of some verbs, imagine
typing those instructions out to someone… The `tidyverse` functions for
manipulating data in R are designed to be intuitive.

The core four from the `dplyr` package within the `tidyverse`:

- `select()` selects whichever columns you tell it, either by name or
  index (number)
- `filter()` filters based on whatever criteria you give it (based on
  the columns you actually have or make)
- `mutate()` changes existing columns or creates new ones (think of
  calculations and transformations, etc)
- `arrange()` arranges or sorts the visual output based on whichever
  column(s) you give it

Often, we will use these in combination with one another, and/or one
after another, which is why the pipe operator (\|\> or %\>%) becomes so
handy.

Fun fact: the pipe operator is possible because the functions we will
learn in the `tidyverse` are standardized to take data frames as the
first argument (input variable). (Confirm this and answer some questions
for your future self by typing `?select` !)

``` r
# select/filter/mutate examples - play around with these!
df_small <- cars |>
  select(car_model, mpg, cyl, hp) |>
  filter(cyl %in% c(4, 6)) |>
  # right now, cyl is a number so we can also do:
  # filter(cyl <= 6) |> 
  mutate(hp_per_cyl = hp / cyl) |>
  arrange(desc(hp))

df_small |> select(car_model, hp_per_cyl, everything())
```

    ## # A tibble: 18 × 5
    ##    car_model      hp_per_cyl   mpg   cyl    hp
    ##    <chr>               <dbl> <dbl> <dbl> <dbl>
    ##  1 Ferrari Dino         29.2  19.7     6   175
    ##  2 Merc 280             20.5  19.2     6   123
    ##  3 Merc 280C            20.5  17.8     6   123
    ##  4 Lotus Europa         28.2  30.4     4   113
    ##  5 Mazda RX4            18.3  21       6   110
    ##  6 Mazda RX4 Wag        18.3  21       6   110
    ##  7 Hornet 4 Drive       18.3  21.4     6   110
    ##  8 Volvo 142E           27.2  21.4     4   109
    ##  9 Valiant              17.5  18.1     6   105
    ## 10 Toyota Corona        24.2  21.5     4    97
    ## 11 Merc 230             23.8  22.8     4    95
    ## 12 Datsun 710           23.2  22.8     4    93
    ## 13 Porsche 914-2        22.8  26       4    91
    ## 14 Fiat 128             16.5  32.4     4    66
    ## 15 Fiat X1-9            16.5  27.3     4    66
    ## 16 Toyota Corolla       16.2  33.9     4    65
    ## 17 Merc 240D            15.5  24.4     4    62
    ## 18 Honda Civic          13    30.4     4    52

# 4. The most important types of plots

Data visualization only got a very brief intro on Day 1. It will get its
own formal introduction on and be the focus of Day 2, so this section
and the next are more preparatory than anything.

First, let’s create a folder (named results or whatever you’d like to
call it) inside of the folder we are working in for the assignment,
using the `here()` function to build up a filepath string.

``` r
# here takes the strings that you give it and pastes them together to make a proper filename for your computer
results_path <- here('results') # one folder
results_path <- here('results','day-1') # subfolder, may need to add recursive=TRUE to dir.create

# bonus: try timestamping your folders
# today() is a function from the lubridate package (not part of core tidyverse) which we can still run thi
# results_path <- here('results', lubridate::today())

# whatever you decide to call it, check that results_path is a real filepath on your computer then create it
dir.create(results_path)
```

    ## Warning in dir.create(results_path):
    ## '/Users/sxmorgan/Desktop/ds_iai/results/day-1' already exists

How to plot our data? First, need to ask what you would like to show
(more on this to come)…

1.  Relationship? =\> scatter plot with `geom_point()`
2.  Distribution? =\> histogram with `geom_histogram()` or
    `geom_density()`
3.  Comparison? =\> boxplot with `geom_boxplot()`
4.  Composition? =\> stacked bar with `geom_bar()`

Check out the cheatsheet for more options and details:
<https://posit.co/wp-content/uploads/2022/10/data-visualization-1.pdf>

In the following chunk, play around with colors and shapes (use the help
to figure out how if needed!)

``` r
# to visualize distribution of numeric variables: geom_histogram
df |>
  ggplot(aes(x = mpg)) +
  geom_histogram(bins = 20) +
  labs(title = "Distribution of MPG")
```

![](D1_companion_guide_files/figure-gfm/chunk-4.1-1.png)<!-- -->

``` r
# to visualize distribution of categorical variables: geom_bar (not stacked)
df |>
  # mutate(am = as_factor(am)) |>
  ggplot(aes(x = am)) +
  geom_bar() +
  labs(title = "Distribution of Transmission Types")
```

![](D1_companion_guide_files/figure-gfm/chunk-4.1-2.png)<!-- -->

``` r
# Boxplot of mpg by cylinders (+ jittered points)
df |>
  ggplot(aes(x = factor(cyl), y = mpg)) +
  geom_boxplot() +
  geom_point() +
  # geom_jitter(width = 0.2, alpha = 0.6) + 
  labs(x = "Cylinders", y = "MPG", title = "MPG by Cylinder Count")
```

![](D1_companion_guide_files/figure-gfm/chunk-4.1-3.png)<!-- -->

``` r
# Scatter (no smoothing)
# in class we colored by cyl, which we made a factor -- try that on your own here
df |>
  ggplot(aes(x = hp, y = mpg)) +
  geom_point() + #scatter plots are ALWAYS geom_point() not geom_jitter()
  labs(x = "Horsepower", y = "MPG", title = "MPG vs Horsepower") +
  theme_minimal()
```

![](D1_companion_guide_files/figure-gfm/chunk-4.1-4.png)<!-- -->

# 5. Save a figure (practice using a project path)

If you’ve completed section 4 above and created a results folder and
some plots, it’s time to save them.

First, saving in our R environments by assigning them to a variable
(none of the plots above are).

Then, using a function called `ggsave()` which takes arguments such as
the plot variable name, a filename variable, width, and height (and more
– check `?ggsave`)

``` r
p <- ggplot(df, aes(hp, mpg)) + geom_point()

name_to_save <- here(results_path, "d1_scatter.png")

ggsave(filename = name_to_save, plot = p, width = 5, height = 5)
```

# Exercises: Penguins (Data Frames & Visualizations)

Tip: you may want to copy these into a new R Markdown document to avoid
lots of scrolling…

Use the same verbs and plotting steps from today: `select()`,
`filter()`, `mutate()`, `arrange()`, and `ggplot()` + `geom_xxx()` +
`labs()`.

It’s OK if plots print messages about removed rows — the dataset has
some missing values.

## 1) Quick scan (structure & missingness)

First, save the `penguins` dataset as a tibble to a variable name of
your choosing. How many rows/columns are in `penguins`? Which variables
are numeric vs. categorical? Which columns visibly include missing (NA)
values?

``` r
head(penguins)
```

    ##   species    island bill_len bill_dep flipper_len body_mass    sex year
    ## 1  Adelie Torgersen     39.1     18.7         181      3750   male 2007
    ## 2  Adelie Torgersen     39.5     17.4         186      3800 female 2007
    ## 3  Adelie Torgersen     40.3     18.0         195      3250 female 2007
    ## 4  Adelie Torgersen       NA       NA          NA        NA   <NA> 2007
    ## 5  Adelie Torgersen     36.7     19.3         193      3450 female 2007
    ## 6  Adelie Torgersen     39.3     20.6         190      3650   male 2007

## 2) Focus on one species (filter, select, arrange)

Keep only Adelie rows; store as `adelie_tbl`. Keep just: `bill_len`,
`bill_dep`, `flipper_len`, `body_mass`, `year`. Sort descending by
`body_mass`.

Question: about how many Adelie penguins are over 4000 g?

``` r
# YOUR CODE HERE
```

## 3) Derived variable (mutate)

In `adelie_tbl`, create `bill_ratio` = `bill_len` / `bill_dep`. Sort by
`bill_ratio` (largest first).

Question: what does a larger `bill_ratio` suggest?

``` r
# YOUR CODE HERE
```

## 4) Relationship plot (scatter)

Make a scatter plot of bill length vs body mass. Color points by
species. Add a clear title and axis labels with labs(). Save your image
to the results folder we made and use a descriptive name.

``` r
# YOUR CODE HERE
```
