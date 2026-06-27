test_that("audit_report prints a report and returns audit invisibly", {
  audit <- audit_panel(example_panel, id = id, time = year)

  expect_output(
    out <- audit_report(audit),
    "unifyr Panel Audit Report"
  )

  expect_s3_class(out, "unifyr_panel_audit")
})

test_that("audit_report requires an audit object", {
  expect_error(
    audit_report(example_panel),
    "must be an object created by"
  )
})
