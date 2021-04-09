# Import synthetic ONDRI data set
synth_dictDF <- read.csv("/home/limlogan/baycrest/datapacks/synth_data/JUL26/OND01_ALL_01_NIBS_SYNTHDATA_2020JUL26_DICT.csv")
synth_dataDF <- read.csv("/home/limlogan/baycrest/datapacks/synth_data/JUL26/OND01_ALL_01_NIBS_SYNTHDATA_2020JUL26_DATA.csv")

test_that("ONDRI JUL26/2020 Synth data and dictionary", {
  expect(checkColumnLabels(dictDF = synth_dictDF[1:9,], dataDF = synth_dataDF[,1:9])@pass,
         failure_message = "Smoke test with ONDRI JUL26/2020 Synth data and dictionary did not pass for checkColumnLabels")
})
