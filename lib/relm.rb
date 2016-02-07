module RElm
  # foldp: takes a function (see update), an initial_state, and a signal
  # that merges all the relevant inputs to the program
  def foldp(func, initial_state, signal)
    Foldp.new(func, initial_state, signal)
  end # returns signal of displayable

  # map: takes a function (see view) and a signal of models, and returns
  # a signal of displayable representations
  def map(func, signal)
    Map.new(func, signal)
  end # returns signal of model

  # run: takes a signal of displayable representations and evaluates it
  # repeatedly as signals change value
  def run(signal)
    display = proc {|value| puts value }
    loop do
      display.call(signal.next)
    end
  end # never returns
end

require_relative 'relm/foldp'
require_relative 'relm/map'
require_relative 'relm/filter'
require_relative 'relm/keyboard'
require_relative 'relm/input_signal'
require_relative 'relm/raw_input_signal'
