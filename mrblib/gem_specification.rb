module Gem
  class Specification
    attr_accessor :name, :version

    def initialize
      yield(self)
    end

    def method_missing(*)
    end

    def self.parse(contents)
      instance_eval(contents)
    end

  end
end
