class DomControl::Processor
  def self.process_response(request_env, response)
    status, headers, body = response
    return response unless headers["Content-Type"].start_with?("text/html")

    # TODO: currently assumes the body contains a ActionDispatch::Response::RackBody
    [
      status,
      headers,
      [
        process_html(
          body.body,
          check_multi: request_env['dom_control.check_multi'],
          check: request_env['dom_control.check']
        )
      ]
    ]
  end

  def self.process_html(html, check_multi: nil, check: nil)
    check_multi ||= DomControl.config.check_multi
    check ||= DomControl.config.check

    ActiveSupport::Notifications.instrument "dom_control.process_html" do
      doc = Nokogiri::HTML(html)
      nodes = doc.search('.//domcontrol')

      # Build Node Checks from DomControl nodes
      node_checks = nodes.map { |node| NodeCheck.new(node: node) }

      # do (optional) multi check
      check_multi.call(node_checks) if check_multi

      # resolve remaining single checks
      node_checks.each do |node_check|
        if node_check.unset_value?
          check.call(node_check)
        end
      end

      # remove nodes
      node_checks.each do |node_check|
        if node_check.remove?
          node_check.node.remove
        end
      end

      # generate html
      doc.to_html
    end
  end

  NodeCheck = Struct.new(:node, :value, keyword_init: true) do
    def key
      node['check'] || node['unless']
    end

    def resource
      node['resource']
    end

    def expected_value
      node['check'].present?
    end

    def remove?
      value != expected_value
    end

    def unset_value?
      value.nil?
    end
  end
end
