# frozen_string_literal: true

require "test_helper"
require "erb"
require "yaml"

class TaskTest < Minitest::Test
  def setup
    @config = YAML.safe_load(ERB.new(File.read("lib/config/database.yml")).result)["test"]
    FileUtils.rm_f @config["database"]
    ENV["APP_ENV"] = "test"
    Todo.logger.level = Todo::Logging::LOG_LEVELS[:debug]
    Todo::DB.prepare
  end

  def teardown
    FileUtils.rm_f @config["database"]
  end

  def test_create
    task = Todo::Task.create!({ name: "名前", content: "内容" }).reload
    assert_equal(%w[名前 内容 notyet], [task.name, task.content, task.status])
  end

  def test_create_validate_name
    assert_raises(ActiveRecord::RecordInvalid) do
      Todo::Task.create!({ name: "名前", content: nil })
    end

    assert_raises(ActiveRecord::RecordInvalid) do
      Todo::Task.create!({ name: nil, content: "内容" })
    end
  end

  def test_update
    task = Todo::Task.create!({ name: "名前", content: "内容" }).reload

    task.update!({ name: "名前2", content: "内容2", status: "done" })
    assert_equal(%w[名前2 内容2 done], [task.name, task.content, task.status])
  end

  def test_delete
    task = Todo::Task.create!({ name: "名前", content: "内容" }).reload

    task.destroy
    assert_raises(ActiveRecord::RecordNotFound) do
      Todo::Task.find(task.id)
    end
  end

  def test_search
    Todo::Task.create!({ name: "名前", content: "内容", status: "done" })
    Todo::Task.create!({ name: "名前2", content: "内容2", status: "done" })
    Todo::Task.create!({ name: "名前3", content: "内容3", status: "notyet" })

    tasks = Todo::Task.where(status: "done")
    assert_equal(2, tasks.size)
  end
end
