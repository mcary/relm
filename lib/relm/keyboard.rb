module RElm
  module Keyboard
    module_function
    def arrows
	  keys = {
 		"\e[A" => :up,
		"\e[B" => :down,
		"\e[C" => :right,
		"\e[D" => :left,
	  }
      key_name = proc do |code|
	    keys.fetch(code)
      end
	  is_arrow = proc do |code|
        exit 1 if code == "\u0003" # Ctrl-C
		keys.key? code
	  end
      Map.new(key_name, Filter.new(is_arrow, RawInputSignal.new($stdin)))
    end
  end
end
