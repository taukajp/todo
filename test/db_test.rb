# frozen_string_literal: true

require "test_helper"
require "erb"
require "yaml"

class DBTest < Minitest::Test
  def setup
    @config = YAML.safe_load(ERB.new(File.read("lib/config/database.yml")).result)["test"]
    FileUtils.rm_f @config["database"]
    ENV["APP_ENV"] = "test"
    Todo.logger.level = Todo::Logging::LOG_LEVELS[:debug]
  end

  def teardown
    FileUtils.rm_f @config["database"]
  end

  def test_prepare
    Todo::DB.prepare
    assert_path_exists(@config["database"])
  end
end
