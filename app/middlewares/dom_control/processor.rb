class DomControl::Processor
  def self.process_response(response)
    puts "foo"
    puts response.inspect
    response
  end
end