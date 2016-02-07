module RElm
  class Foldp < Struct.new(:func, :initial_state, :signal)
    def initialize(*args)
      super
      @current_state = initial_state
	  @first_time = true
    end

    def next
	  if @first_time
		@first_time = false
		initial_state
	  else
		@current_state = func.call(@current_state, signal.next)
	  end
	end
  end
end
