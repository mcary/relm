# This is the same code as in the example in the README.

require_relative 'lib/relm'

view = proc do |model|
  model.choices.map do |choice|
    if model.selected?(choice)
      "[#{choice}]"
    else
      choice
    end
  end.join(" ")
end

update = proc do |model, signal_value|
  case signal_value
  when :left then model.shift_left
  when :right then model.shift_right
  else model # no change
  end
end

class MyModel < Struct.new(:selection, :choices)
  def initialize(*args)
    super
    raise ArgumentError unless choices.include? selection
  end

  def shift_left
    shift -1
  end

  def shift_right
    shift +1
  end

  def selected?(choice)
    choice == selection
  end

  private

  def shift(amt)
    new_index = (choices.index(selection) + amt) % choices.length
    new_selection = choices[new_index]
    self.class.new(new_selection, choices)
  end 
end

initial_state = MyModel.new(:a, [:a, :b, :c, :d])

include RElm
merged_signals = Keyboard.arrows
program = map(view, foldp(update, initial_state, merged_signals))
run(program)
