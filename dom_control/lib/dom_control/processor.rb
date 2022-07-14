class DomControl::Processor
  def self.process_response(response)
    status, headers, body = response
    return response unless headers["Content-Type"].start_with?("text/html")

    # TODO: currently assumes the body contains a ActionDispatch::Response::RackBody
    [status, headers, [process_html(body.body)]]
  end

  def self.process_html(html, check: ->(key, resource) { true })
    doc = Nokogiri::HTML(html)
    doc.xpath('.//domcontrol').map do |node|
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