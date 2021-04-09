synth_dataDF <- read.csv("/home/limlogan/baycrest/datapacks/synth_data/JUL26/OND01_ALL_01_NIBS_SYNTHDATA_2020JUL26_DATA.csv")

test_that("ONDRI Synth JUL 2020 should pass", {
  check.res <- checkForBlankCells(synth_dataDF)
  expect_true(check.res@pass)
})

test_that("Dataframe with one column, one NA does not pass", {
  blank_df <- data.frame(SUBJECT=c(NA))
  check.res <- checkForBlankCells(blank_df)
  expect_false(check.res@pass)
})

test_that("Not inputing a data.frame fails", {
  expect_false(checkForBlankCells("")@pass)
})
