class ApplicationController < ActionController::Base
  include DomControl::Rails::ControllerExtensions # not entirely necessary, but helps with gem reloading

  def dom_control_cache_key(check)
    [:domcontrol, :check, check.key, check.resource, current_role].join(".")
  end

  dom_control_check do |check|
    cache_key = dom_control_cache_key(check)

    check.value =
      Rails.cache.fetch(cache_key) do
        can?(check.key, check.resource)
      end
  end

  dom_control_check_multi do |checks|
    cache_keys = checks.map { |check| dom_control_cache_key(check) }
    cache_checks = Rails.cache.read_multi(*cache_keys)

    checks.each do |check|
      cache_key = dom_control_cache_key(check)
      check.value = cache_checks[cache_key]
    end
  end

  def can?(action, subject)
    sleep(check_speed.to_f) if check_speed.present?

    if admin?
      true
    elsif editor?
      subject_id = if subject.is_a? String
        subject.split('_').compact.last&.to_i
      else
        subject.id
      end

      subject_id % 6 == 0
    else
      false
    end
  end

  def admin?
    current_role == :admin
  end

  def editor?
    current_role == :editor
  end

  def guest?
    current_role == :guest
  end

  VALID_ROLES = [:admin, :editor, :guest]
  def current_role
    session[:role] = params[:role] if params[:role]&.to_sym.in?(VALID_ROLES)

    session[:role] ||= :guest
    session[:role].to_sym
  end

  helper_method :can?, :admin?, :editor?, :guest?, :current_role

  def check_speed
    @check_speed ||= (params[:check_speed] || session[:check_speed])&.to_f
  end
  after_action do
    session[:check_speed] = check_speed.to_f
  end
  helper_method :check_speed
end
