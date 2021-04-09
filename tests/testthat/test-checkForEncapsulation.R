synth_dataDF <- read.csv(synth_data_path)

test_that("ONDRI JUL26/2020 Synth data encapsulation", {
  check.res <- checkForEncapsulation(synth_data_DF)
  expect_equal(check.res@pass, TRUE)
})
