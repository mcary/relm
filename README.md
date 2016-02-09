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

* `view`: A proc that takes a model (representing the program's
  current state) and returns a displayable representation
* `update`: A proc that takes a model (representing the program's
  previous state) and the current value of an input signal.  It returns
  a model (representing the program's new current state).
* `initial_state`: The starting model that represents the program's state
* `merged_signals`: Inputs from sources relevant to the program

The model most be immutable; `update` should create a *new* model,
optionally with structural sharing.

The library provides:

* `map`: Takes a function (see `view`) and a signal, and returns a
  signal whose values are the result of calling the function on each
  value of the input signal
* `foldp`: Takes a function (see `update`), an `initial_state`, and a
  signal that merges all the relevant inputs to the program.  Returns
  a signal that is initially `initial_state` and subsequently the
  result of calling the function on the previous state and the value
  of the input signal
* `run`: Takes a signal of displayable representations and evaluates it
  repeatedly, displaying the value as it changes

Example
-------
    
You can run this example in example.rb:

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

Program Design Tips
-------------------

* Functions should be pure in that they return the same value for the same
  inputs with no visible side-effects
* Functions can "cheat" with side-effects such as logging
* Try to keep as much of your logic in these functions.  They are easier to
  test and reason about with referential transparency.  Keep the signals on the
  periphery.
* Avoid mutating data structures.  Use a library like Hampster for structural
  sharing if efficiency is an issue.

Next Steps
----------

* Provide more built-in signals
* Implement `RElm::merge`, which takes two signals and combines them
  into one using something like `IO.select`
* Allow `run` to take an optional `displayer` proc to display the
  current displayable representation.  Currently run always just calls
  `puts`, but it could update an UI and repaint, for example.
* Setup Gemfile and .gemspec
* Ruby-ify the API a bit more, for example by moving funtion callbacks
  to last position so they can accept a block more easily
* Illustate benefits to testability
* Short-circuit recomputation when signal values are unchanged
* Add support for async, but with an initial value
* Add support for external APIs (IO-bound, like HTTP requests), either via
  async or a special callback-based API.
* A way to bind new signals to UI elements (like channels?)
* Explore: JSON pushed over websocket as the displayable model
