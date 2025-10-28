# ================================
# Advanced helper functions for microbiome data
# ================================
# These small functions make the same data-preprocessing steps easy to reuse.
# Each one takes a table with sample IDs and bacterial read counts and
# returns a modified version (relative abundance, filtered, or transformed).

# --------------------------------
# 4. compute_gfc()
# --------------------------------
# Computes the generalized fold change (gFC)
# Input: label names and a data frame\
# from j's https://github.com/zellerlab/crc_meta/blob/master/src/marker_analysis.R
# q.p <- quantile(log10(x+log.n0), probs=seq(.1, .9, .05))
# q.n <- quantile(log10(y+log.n0), probs=seq(.1, .9, .05))
# fc[f, s] <- sum(q.p - q.n)/length(q.p)
compute_gfc <- function(df, 
                        case = "CRC", 
                        control = "CTR") {
  x <- df$log10_rel_ab[df$Condition == case]      # case values
  y <- df$log10_rel_ab[df$Condition == control]   # control values
  q_case <- quantile(x, probs = seq(0.1, 0.9, 0.05))
  q_control <- quantile(y, probs = seq(0.1, 0.9, 0.05))
  gfc <- sum(q_case - q_control) / length(q_case)
  return(gfc)
}

# DEMO ? easy to go from above and explain how it works (worth showing browser() ?)
compute_wilcoxon <- function(df, 
                             case = "CRC", 
                             control = "CTR") {
  x <- df$log10_rel_ab[df$Condition == case]      # case values
  y <- df$log10_rel_ab[df$Condition == control]   # control values
  pvalue <- wilcox.test(log10_rel_ab ~ Condition, data=df)$p.value
  return(pvalue)
}


# --------------------------------
# 5. run_pca()
# --------------------------------
# Performs PCA on feature data to reduce dimensionality.
# Returns PC coordinates, variance explained, and the full PCA object.
run_pca <- function(data_wide) {
  
  # Extract feature columns (everything except Sample_ID)
  feature_cols <- setdiff(names(data_wide), "Sample_ID")
  feature_mat <- as.matrix(data_wide[, feature_cols])
  
  # Run PCA (scale = TRUE standardizes features)
  pca_result <- prcomp(feature_mat, scale. = TRUE, center = TRUE)
  
  # Extract coordinates (PC scores) for samples
  coords <- as.data.frame(pca_result$x[, 1:2])  # first 2 PCs
  coords$Sample_ID <- data_wide$Sample_ID
  
  # Calculate variance explained by each PC
  var_explained <- pca_result$sdev^2 / sum(pca_result$sdev^2) * 100
  
  # Return results as a list
  return(list(
    coords = coords,
    var_explained = var_explained[1:2],
    full_result = pca_result
  ))
}