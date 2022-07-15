class ApplicationController < ActionController::Base
  include DomControl::Rails::ControllerExtensions # not entirely necessary, but helps with gem reloading

  dom_control_check do |key, subject|
    Rails.cache.fetch("domcontrol.check.#{key}.#{subject}.#{current_role}") do
      can?(key, subject)
    end
  end

  def can?(action, subject)
    sleep(0.001)

    if admin?
      true
    elsif editor?
      subject.id % 6 == 0
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
end
