test_that("can make simple batch request", {
  chat <- chat_claude("Be as terse as possible; no punctuation")
  resp <- chat$chat("What is 1 + 1?", echo = FALSE)
  expect_match(resp, "2")
  expect_equal(chat$last_turn()@tokens > 0, c(TRUE, TRUE))
})

test_that("can make simple streaming request", {
  chat <- chat_claude("Be as terse as possible; no punctuation")
  resp <- coro::collect(chat$stream("What is 1 + 1?"))
  expect_match(paste0(unlist(resp), collapse = ""), "2")
})

# Common provider interface -----------------------------------------------

test_that("defaults are reported", {
  expect_snapshot(. <- chat_claude())
})

test_that("respects turns interface", {
  chat_fun <- chat_claude

  test_turns_system(chat_fun)
  test_turns_existing(chat_fun)
})

test_that("all tool variations work", {
  chat_fun <- chat_claude

  retry_test(test_tools_simple(chat_fun))
  test_tools_async(chat_fun)
  test_tools_parallel(chat_fun)
  # Claude sometimes returns an empty string
  retry_test(test_tools_sequential(chat_fun, total_calls = 6))
})

test_that("can extract data", {
  chat_fun <- chat_claude

  test_data_extraction(chat_fun)
})

test_that("can use images", {
  chat_fun <- chat_claude

  test_images_inline(chat_fun)
  test_images_remote_error(chat_fun)
})

test_that("can use pdfs", {
  chat_fun <- chat_claude

  test_pdf_local(chat_fun)
})
