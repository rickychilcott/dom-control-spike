class TasksController < ApplicationController
  def clear_cache
    Rails.cache.clear

    redirect_to resources_url
  end

  def generate_models
    Resource.destroy_all

    count = (params[:resource_count] || 1000).to_i
    count.to_i.times { Resource.create name: Faker::Company.catch_phrase }

    resource_ids = Resource.pluck(:id)

    Resource
      .all
      .find_each do |resource|
        random_id = resource_ids.select {|i| i < resource.id }.sample
        resource.update(parent_id: random_id)
      end

    Rails.cache.clear

    redirect_to resources_url
  end
end
