synth_dataDF <- read.csv("/home/limlogan/baycrest/datapacks/synth_data/JUL26/OND01_ALL_01_NIBS_SYNTHDATA_2020JUL26_DATA.csv")

test_that("ONDRI Synth JUL2020 data passes", {
  expect_true(checkForCommas(synth_dataDF)@pass)
})

test_that("Data frame with columns with commas should not pass", {
  commas_df <- data.frame(matrix(1:6, ncol = 2, nrow = 3))
  colnames(commas_df) <- c("A", "B")
  commas_df <- lapply(commas_df, as.character)
  commas_df$A[2] <- ", "
  expect_false(checkForCommas(commas_df)@pass)
})
