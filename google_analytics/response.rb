class Response
  attr_reader :ga_response
  def initialize(ga_response)
    @ga_response = ga_response
  end

  def to_h
    ga_response.to_h
  end
end