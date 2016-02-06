RElm - Functional-Reactive programming for Ruby
===============================================

RElm is a library for the functional-reactive style of programming,
inspired by the Elm programming language, which targets that style.

Program Structure
-----------------

The top-level flow of most programs would be expressed as:

    include RElm
    program = map(view, foldp(update, initial_state, merged_signals))
    run(program)

Where the program provides:

* view: proc takes a model (a representation of program's current
  state) and returns a displayable representation
* update: proc takes a model and the current value of an input signal
  and returns a model
  for the next state of the program
* initial_state: the starting model
* merged_signals: inputs from sources relevant to the program

The library provides:

* map: takes a function (see view) and a signal of models, and returns
  a signal of displayable representations
* foldp: takes a function (see update), an initial_state, and a signal
  that merges all the relevant inputs to the program
* run: takes a signal of displayable representations and evaluates it
  repeatedly as signals change value

Example
-------
    
    def view(model)
      model.choices.map do |choice|
        if model.selected?(choice)
          "[#{choice}]"
        else
          choice
        end
      end.join(" ")
    end

    def update(model, signal_value)
      case signal_value
      when :left then model.shift_left
      when :right then model.shift_right
      else model # no change
      end
    end

    class MyModel < Struct.new(:selection, :choices)
      def initialize(*args)
        super
        raise unless choices.include? selection
      end

      def shift_left
        shift -1
      end

      def shift_right
        shift +1
      end
   
      private

      def shift(amt)
        new_selection = (choices.index(selection) + amt) % choices.length
        self.class.new(new_selection, choices)
      end 
    end

    model = MyModel.new(:a, [:a, :b, :c, :d])

    merged_signals = Keyboard.arrows
