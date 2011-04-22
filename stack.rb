#!/usr/bin/env ruby
#encoding: utf-8
class Stack
  def initialize
   @stack = []
  end
  def push(item)
    return @stack.push item
  end
  def pop
    return @stack.pop
  end
  def count
    @stack.length
  end
end