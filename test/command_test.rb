# frozen_string_literal: true

require "test_helper"
require "erb"
require "yaml"

class CommandTest < Minitest::Test
  def setup
    @config = YAML.safe_load(ERB.new(File.read("lib/config/database.yml")).result)["test"]
    FileUtils.rm_f @config["database"]
    ENV["APP_ENV"] = "test"
    Todo.logger.level = Todo::Logging::LOG_LEVELS[:debug]
  end

  def teardown
    FileUtils.rm_f @config["database"]
  end

  def test_version
    assert_output("#{Todo::VERSION}\n") do
      Todo::Command.new.invoke(:version, [], {})
    end
  end

  def test_create
    task = Todo::Command.new.invoke(:create, [], { name: "名前", content: "内容" })
    assert_equal(%w[名前 内容 notyet], [task.name, task.content, task.status])
  end

  def test_update
    task = Todo::Command.new.invoke(:create, [], { name: "名前", content: "内容" })

    task = Todo::Command.new.invoke(:update, [task.id], { name: "名前2", content: "内容2", status: "done" })
    assert_equal(%w[名前2 内容2 done], [task.name, task.content, task.status])
  end

  def test_delete
    task = Todo::Command.new.invoke(:create, [], { name: "名前", content: "内容" })

    Todo::Command.new.invoke(:delete, [task.id], {})
    assert_raises(ActiveRecord::RecordNotFound) do
      Todo::Task.find(task.id)
    end
  end

  def test_list
    Todo::Command.new.invoke(:create, [], { name: "名前", content: "内容" })
    Todo::Command.new.invoke(:create, [], { name: "名前2", content: "内容2" })
    task = Todo::Command.new.invoke(:create, [], { name: "名前3", content: "内容3" })
    Todo::Command.new.invoke(:update, [task.id], { status: "done" })

    tasks = Todo::Command.new.invoke(:list, [], { status: "notyet" })
    assert_equal(2, tasks.size)
  end
end
