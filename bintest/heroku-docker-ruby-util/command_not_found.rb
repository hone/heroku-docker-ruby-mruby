require 'open3'
require 'tmpdir'
require_relative '../support/paths'

assert('command not found') do
  output, error, status = Open3.capture3(BIN_PATH, "foo")
  assert_include error, "foo not a valid command"
end
