class TasksController < ApplicationController
  def clear_cache
    Rails.cache.clear

    redirect_to resources_url
  end
end
