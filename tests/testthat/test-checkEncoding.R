
test_that("ONDRI JUL26/2020 Synth data smoke test", {
  check_res <- checkEncoding("/home/limlogan/baycrest/datapacks/synth_data/JUL26/OND01_ALL_01_NIBS_SYNTHDATA_2020JUL26_DATA.csv")
  tst_msg <- paste("Smoke test with ONDRI JUL26/2020 Synthetic data for",
                   "checkEncoding. The encoding probabilities were:", paste(check_res@data))
  expect(check_res@pass,
         failure_message = tst_msg)
})
