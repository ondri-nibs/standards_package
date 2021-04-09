synth_dictDF <- read.csv("/home/limlogan/baycrest/datapacks/synth_data/JUL26/OND01_ALL_01_NIBS_SYNTHDATA_2020JUL26_DICT.csv")
synth_dataDF <- read.csv("/home/limlogan/baycrest/datapacks/synth_data/JUL26/OND01_ALL_01_NIBS_SYNTHDATA_2020JUL26_DATA.csv")

test_that("ONDRI JUL26/2020 Synth data smoke test", {
  check_res <- checkColumnNameSyntax(df = synth_dataDF[1:9])
  tst_msg <- paste("Smoke test with ONDRI JUL26/2020 Synthetic data for",
                   "the first 9 columns did not pass for checkColumnNameSyntax.",
                   "Offending columns are: ", paste(check_res@data))
  expect(check_res@pass,
         failure_message = tst_msg)
})
