# ================================
# Helper functions for microbiome data
# ================================
# These small functions make the same data-preprocessing steps easy to reuse.
# Each one takes a table with sample IDs and bacterial read counts and
# returns a modified version (relative abundance, filtered, or transformed).

# --------------------------------
# 1. counts_to_relab()
# --------------------------------
# Converts a table of raw counts (e.g., number of reads per taxon/organism per sample)
# into relative abundances (proportion of reads per feature within each sample).
# This lets us compare samples with different sequencing depths.
counts_to_relab <- function(counts_df) {
  
  # Get all feature (bacterial count) columns, skipping the sample ID column
  feature_cols <- setdiff(names(counts_df), "Sample_ID")
  
  # Convert those columns into a numeric matrix for faster math
  mat <- as.matrix(counts_df[, feature_cols])
  
  # Calculate total counts (sum of all features) per sample (row)
  rsums <- rowSums(mat)
  # Avoid dividing by zero if any sample has zero total counts
  rsums[rsums == 0] <- 1
  
  # Divide each value in a row by that row’s total count
  # turns counts into proportions (each row now sums to 1)
  relab <- sweep(mat, 1, rsums, "/")
  
  # Add back the sample IDs and return as a regular data frame
  dplyr::bind_cols(counts_df["Sample_ID"], as.data.frame(relab))
}

# --------------------------------
# 2. filter_features()
# --------------------------------
# Removes features (bacterial counts) that are too rare or too low in abundance.
# relab_threshold: minimum relative abundance to be "present" in a sample.
# prevalence_threshold: minimum fraction of samples where the feature must appear.
filter_features <- function(relab_df, relab_threshold = 0.001, 
                            prevalence_threshold = 0.10) {
  
  feature_cols <- setdiff(names(relab_df), "Sample_ID")
  mat <- as.matrix(relab_df[, feature_cols])
  
  # For each feature (column), compute the proportion of samples
  # where its relative abundance is >= threshold (i.e., “present”)
  prev <- colMeans(mat >= relab_threshold)
  
  # Keep only the features that appear in at least (prevalence_threshold) of samples
  keep <- names(prev[prev >= prevalence_threshold])
  
  # Return the filtered table with Sample_ID plus only the kept features
  dplyr::bind_cols(relab_df["Sample_ID"], as.data.frame(mat[, keep, drop = FALSE]))
}

# --------------------------------
# 3. log_transform()
# --------------------------------
# Applies a log10 transformation to stabilize variance and make plots clearer.
# A small “pseudocount” is added to avoid taking log(0).
log_transform <- function(relab_df, pseudo = 1e-05) {
  
  feature_cols <- setdiff(names(relab_df), "Sample_ID")
  m <- as.matrix(relab_df[, feature_cols])
  
  # Add the pseudocount and take log10
  m2 <- log10(m + pseudo)
  
  # Combine back with the Sample_ID column and return
  dplyr::bind_cols(relab_df["Sample_ID"], as.data.frame(m2))
}
