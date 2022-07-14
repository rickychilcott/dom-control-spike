class TasksController < ApplicationController
  def clear_cache
    Rails.cache.clear

    redirect_to resources_url
  end

  def generate_models
    Resource.delete_all

    count = (params[:resource_count] || 1_000).to_i

    new_resources =
      count.times.map do |index|
        Resource
          .new(name: Faker::Company.catch_phrase)
          .attributes
          .merge(updated_at: Time.now, created_at: Time.now)
      end
    Resource.insert_all(new_resources)

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
