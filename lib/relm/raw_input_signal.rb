require 'io/console'

module RElm
  class RawInputSignal < InputSignal
    def next
      io.echo = false
      io.raw!

      input = super

      if input == "\e" then
        input << io.read_nonblock(3) rescue nil
        input << io.read_nonblock(2) rescue nil
      end
    ensure
      io.echo = true
      io.cooked!
      return input
    end
  end
end
