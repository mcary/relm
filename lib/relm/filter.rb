module RElm
  class Filter < Struct.new(:func, :signal)
    def next
      nil until func.call(value = signal.next)
      value
    end
  end
end


