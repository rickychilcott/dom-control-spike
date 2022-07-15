module DomControl::Rails::ViewHelpers
  def dom_control(opts={})
    opts[:resource] = DomControl.resource_id(opts[:resource]) if opts[:resource]

    if opts[:check].blank? && opts[:unless].blank?
      raise "You must pass either :check or :unless option to `dom_control`"
    end

    content_tag(:domcontrol, opts.compact) do
      yield
    end
  end
end