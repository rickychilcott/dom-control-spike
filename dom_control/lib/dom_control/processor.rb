class DomControl::Processor
  def self.process_response(request_env, response)
    status, headers, body = response
    return response unless headers["Content-Type"].start_with?("text/html")

    # TODO: currently assumes the body contains a ActionDispatch::Response::RackBody
    [status, headers, [process_html(body.body, check: request_env['dom_control.check'])]]
  end

  def self.process_html(html, check: nil)
    check ||= DomControl.config.check

    ActiveSupport::Notifications.instrument "dom_control.process_html" do
      doc = Nokogiri::HTML(html)
      nodes = doc.search('.//domcontrol')
      nodes.each do |node|
        if node['check']
          key       = node['check']
          resource  = node['resource']
          value     = check.call(key, resource)

          node.remove if value == false
        elsif node['unless']
          key       = node['unless']
          resource  = node['resource']
          value     = check.call(key, resource)

          node.remove if value == true
        end
      end
      doc.to_html
    end
  end
end
