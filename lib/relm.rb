module RElm
  def foldp(func, initial_state, signal)
    Foldp.new(func, initial_state, signal)
  end

  def map(func, signal)
    Map.new(func, signal)
  end

  def run(signal)
    display = proc {|value| puts value }
    loop do
      display.call(signal.next)
    end
  end
end

require_relative 'relm/foldp'
require_relative 'relm/map'
require_relative 'relm/filter'
require_relative 'relm/keyboard'
require_relative 'relm/input_signal'
require_relative 'relm/raw_input_signal'
