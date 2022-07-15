require "active_support/core_ext/integer/time"

Rails.application.configure do
  def autoreload_gem(gemname)
    gem_path = Rails.root.join(gemname)

    # Create a Zeitwerk class loader for each gem
    gem_lib_path = gem_path.join('lib').join(gem_path.basename) # i.e. '.../format_gem/lib/format_gem'
    gem_loader = Zeitwerk::Registry.loader_for_gem(gem_lib_path, warn_on_extra_files: false)
    gem_loader.enable_reloading
    gem_loader.setup

    # Create a file watcher that will reload the gem classes when a file changes
    file_watcher = ActiveSupport::FileUpdateChecker.new(gem_path.glob('**/*')) do
      puts "file changed"
      gem_loader.reload
    end

    config.to_prepare do
      puts "to prepare"
      file_watcher.execute_if_updated
    end

    Rails.application.reloaders << Class.new do
      def initialize(file_watcher)
        @file_watcher = file_watcher
      end

      def updated?
        @file_watcher.execute_if_updated
      end
    end.new(file_watcher)
  end

  autoreload_gem 'dom_control'


  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if true # Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    # config.cache_store = :memory_store
    config.cache_store = :redis_cache_store, { url: ENV['REDIS_URL'] || "redis://localhost:6379" }
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true
end
