module RElm
  class Map < Struct.new(:func, :signal)
    def next
      func.call(signal.next)
    end
  end
end
