class ApplicationController < ActionController::Base
  include DomControl::Rails::ControllerExtensions # not entirely necessary, but helps with gem reloading

  dom_control_check do |key, subject|
    Rails.cache.fetch("domcontrol.check.#{key}.#{subject}.#{current_role}") do
      can?(key, subject)
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
