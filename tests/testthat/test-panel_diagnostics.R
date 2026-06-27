test_that("audit_summary returns a one-row tibble", {
  df <- tibble::tibble(
    district = c("A", "A", "B"),
    year = c(2020, 2021, 2020),
    wage = c(100, 110, 90)
  )

  audit <- audit_panel(df, id = district, time = year)
  summary <- audit_summary(audit)

  expect_s3_class(summary, "tbl_df")
  expect_equal(nrow(summary), 1)
  expect_equal(summary$n_units, 2)
  expect_equal(summary$n_periods, 2)
  expect_equal(summary$missing_cells, 1)
  expect_false(summary$balanced)
})


test_that("panel_gaps returns missing id-time combinations", {
  df <- tibble::tibble(
    district = c("A", "A", "B", "C", "C"),
    year = c(2020, 2021, 2020, 2020, 2022),
    wage = c(100, 110, 90, 80, 85)
  )

  gaps <- panel_gaps(df, id = district, time = year)

  expect_s3_class(gaps, "tbl_df")
  expect_equal(nrow(gaps), 4)
  expect_true(all(c("district", "year") %in% names(gaps)))
})


test_that("gap_summary reports missing periods by unit", {
  df <- tibble::tibble(
    district = c("A", "A", "B", "C", "C"),
    year = c(2020, 2021, 2020, 2020, 2022),
    wage = c(100, 110, 90, 80, 85)
  )

  summary <- gap_summary(df, id = district, time = year)

  expect_s3_class(summary, "tbl_df")
  expect_true("panelbuild_missing_periods" %in% names(summary))
  expect_equal(summary$panelbuild_missing_periods[summary$district == "B"], 2)
  expect_equal(summary$panelbuild_missing_periods[summary$district == "A"], 1)
  expect_equal(summary$panelbuild_missing_periods[summary$district == "C"], 1)
})


test_that("panel_duplicates returns duplicate id-time combinations", {
  df <- tibble::tibble(
    district = c("A", "A", "B", "B", "B", "C", "C", "C"),
    year = c(2020, 2021, 2020, 2021, 2021, 2020, 2020, 2021),
    wage = c(100, 110, 90, 95, 96, 80, 81, 85)
  )

  duplicates <- panel_duplicates(df, id = district, time = year)

  expect_s3_class(duplicates, "tbl_df")
  expect_equal(nrow(duplicates), 2)
  expect_true(all(c("district", "year", "n") %in% names(duplicates)))
})


test_that("duplicate_summary reports duplicate cells by unit", {
  df <- tibble::tibble(
    district = c("A", "A", "B", "B", "B", "C", "C", "C"),
    year = c(2020, 2021, 2020, 2021, 2021, 2020, 2020, 2021),
    wage = c(100, 110, 90, 95, 96, 80, 81, 85)
  )

  summary <- duplicate_summary(df, id = district, time = year)

  expect_s3_class(summary, "tbl_df")
  expect_true("panelbuild_duplicate_cells" %in% names(summary))
  expect_true("panelbuild_duplicate_extra_rows" %in% names(summary))

  expect_equal(summary$panelbuild_duplicate_cells[summary$district == "B"], 1)
  expect_equal(summary$panelbuild_duplicate_extra_rows[summary$district == "B"], 1)

  expect_equal(summary$panelbuild_duplicate_cells[summary$district == "C"], 1)
  expect_equal(summary$panelbuild_duplicate_extra_rows[summary$district == "C"], 1)
})
