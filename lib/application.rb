# frozen_string_literal: true

require "sinatra/base"
require "sinatra/reloader"
require "rack-flash"

require "todo"

module Todo
  class Application < Sinatra::Base
    enable :sessions

    use Rack::MethodOverride
    use Rack::Flash

    configure do
      ENV["APP_ENV"] = ENV.fetch("RACK_ENV")
      Todo.logger.level = Todo::Logging::LOG_LEVELS[:debug] if %w[development test].include?(ENV["APP_ENV"])
      DB.prepare
    end

    configure :development do
      register Sinatra::Reloader
    end

    helpers do
      def error_class(obj, name)
        "text-red-700 bg-red-50 border-red-400 hover:border-red-500 focus:border-red-500 placeholder-red-300" if obj.errors.key?(name)
      end

      def errors_tag(obj, name)
        obj.errors.full_messages_for(name).map do |message|
          %(<p class="text-red-700">#{message}</p>)
        end.join
      end

      def options_for_task_status(task)
        Task.statuses.keys.map do |key|
          selected = task.status == key ? " selected" : ""
          %(<option value="#{key}"#{selected}>#{key.upcase}</option>)
        end.join
      end
    end

    not_found do
      erb :not_found
    end

    get "/" do
      redirect "/tasks"
    end

    get "/tasks" do
      @tasks = Task.order("created_at desc")
      @status = params[:status]
      @tasks = @tasks.where(status: @status) if @status

      erb :"tasks/index"
    end

    get "/tasks/new" do
      @task = Task.new

      erb :"tasks/new"
    end

    post "/tasks" do
      Task.create!(name: params[:name], content: params[:content])

      flash[:notice] = "Task was successfully created."
      redirect "/tasks"
    rescue ActiveRecord::RecordInvalid => e
      @task = e.record

      erb :"tasks/new"
    end

    get "/tasks/:id/edit" do |id|
      @task = Task.find(id)

      erb :"tasks/edit"
    rescue ActiveRecord::RecordNotFound
      error 404
    end

    patch "/tasks/:id" do |id|
      task = Task.find(id)
      task.update!(
        name: params[:name],
        content: params[:content],
        status: params[:status]
      )

      flash[:notice] = "Task was successfully updated."
      redirect "/tasks"
    rescue ActiveRecord::RecordInvalid => e
      @task = e.record

      erb :"tasks/edit"
    rescue ActiveRecord::RecordNotFound
      error 404
    end

    delete "/tasks/:id" do |id|
      task = Task.find(id)
      task.delete

      flash[:notice] = "Task was successfully destroyed."
      redirect "/tasks"
    rescue ActiveRecord::RecordNotFound
      error 404
    end
  end
end
