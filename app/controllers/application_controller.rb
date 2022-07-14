class ApplicationController < ActionController::Base

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
