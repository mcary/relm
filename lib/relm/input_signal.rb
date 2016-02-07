module RElm
  class InputSignal < Struct.new(:io)
    def next
      io.getc
    end
  end
end
