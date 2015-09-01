require 'open3'
require 'tmpdir'
require_relative '../support/paths'

assert('install-node') do
  Dir.mktmpdir do |tmp_dir|
    Dir.chdir(tmp_dir) do
      install_path  = "ruby"
      profiled_path = ".profile.d/ruby.sh"

      output, status = Open3.capture2(BIN_PATH, "install-node", "0.12.7", install_path, profiled_path)

      assert_true status.success?, "Process did not exit cleanly"
      assert_true Dir.exist?("#{install_path}/node-0.12.7")
      assert_true File.exist?(profiled_path)
      assert_include `bash -c "source #{profiled_path} && node -v"`, "v0.12.7"
    end
  end
end
