
class GraphCreator
  def self.call(...) = new(...).call

  def initialize(label_data:, data:, output:)
    @label_data = label_data
    @data = data
    @g = Gruff::Line.new
    @output = output
  end

  def call
    g.labels = (0...label_data.length).zip(label_data).to_h
    g.data output[0...-4], data
    g.write(output)
  end

  private

  attr_reader :label_data, :data, :g, :output

end

