test_that("audit_panel identifies balanced panels", {
  df <- tibble::tibble(
    district = c("A", "A", "B", "B"),
    year = c(2020, 2021, 2020, 2021),
    wage = c(100, 110, 90, 95)
  )

  audit <- audit_panel(df, id = district, time = year)

  expect_s3_class(audit, "unifyr_panel_audit")
  expect_equal(audit$n_units, 2)
  expect_equal(audit$n_periods, 2)
  expect_equal(audit$expected_cells, 4)
  expect_equal(audit$missing_cells, 0)
  expect_equal(audit$duplicate_cells, 0)
  expect_true(audit$balanced)
})


test_that("audit_panel identifies missing cells", {
  df <- tibble::tibble(
    district = c("A", "A", "B"),
    year = c(2020, 2021, 2020),
    wage = c(100, 110, 90)
  )

  audit <- audit_panel(df, id = district, time = year)

  expect_equal(audit$missing_cells, 1)
  expect_false(audit$balanced)

  missing <- missing_cells(audit)

  expect_equal(nrow(missing), 1)
  expect_equal(missing$district, "B")
  expect_equal(missing$year, 2021)
})


test_that("audit_panel identifies duplicate cells", {
  df <- tibble::tibble(
    district = c("A", "A", "B", "B", "B"),
    year = c(2020, 2021, 2020, 2021, 2021),
    wage = c(100, 110, 90, 95, 96)
  )

  audit <- audit_panel(df, id = district, time = year)

  expect_equal(audit$duplicate_cells, 1)
  expect_false(audit$balanced)

  duplicates <- duplicate_cells(audit)

  expect_equal(nrow(duplicates), 1)
  expect_equal(duplicates$district, "B")
  expect_equal(duplicates$year, 2021)
  expect_equal(duplicates$n, 2)
})


test_that("flag_panel_issues adds duplicate flags without removing rows", {
  df <- tibble::tibble(
    district = c("A", "A", "B", "B", "B"),
    year = c(2020, 2021, 2020, 2021, 2021),
    wage = c(100, 110, 90, 95, 96)
  )

  flagged <- flag_panel_issues(df, id = district, time = year)

  expect_equal(nrow(flagged), nrow(df))
  expect_true("unifyr_row_id" %in% names(flagged))
  expect_true("unifyr_id_time_n" %in% names(flagged))
  expect_true("unifyr_duplicate_cell" %in% names(flagged))

  expect_equal(sum(flagged$unifyr_duplicate_cell), 2)
  expect_equal(attr(flagged, "unifyr_id"), "district")
  expect_equal(attr(flagged, "unifyr_time"), "year")
})


test_that("complete_panel adds missing id-time cells with an audit trail", {
  df <- tibble::tibble(
    district = c("A", "A", "B"),
    year = c(2020, 2021, 2020),
    wage = c(100, 110, 90)
  )

  completed <- complete_panel(df, id = district, time = year)

  expect_equal(nrow(completed), 4)
  expect_true("unifyr_original_row" %in% names(completed))
  expect_true("unifyr_completed_cell" %in% names(completed))
  expect_true("unifyr_audit_action" %in% names(completed))

  expect_equal(sum(completed$unifyr_completed_cell), 1)
  expect_equal(attr(completed, "unifyr_completed_cells"), 1)

  added <- completed[completed$unifyr_completed_cell, ]

  expect_equal(added$district, "B")
  expect_equal(added$year, 2021)
  expect_true(is.na(added$wage))
})


test_that("complete_panel refuses to complete panels with duplicate id-time cells", {
  df <- tibble::tibble(
    district = c("A", "A", "B", "B", "B"),
    year = c(2020, 2021, 2020, 2021, 2021),
    wage = c(100, 110, 90, 95, 96)
  )

  expect_error(
    complete_panel(df, id = district, time = year),
    "cannot complete a panel with duplicate id-time cells"
  )
})
