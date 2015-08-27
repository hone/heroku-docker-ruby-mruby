module Gem
  class Version
    include Comparable

    VERSION_PATTERN = '[0-9]+(?>\.[0-9a-zA-Z]+)*(-[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?' # :nodoc:
    ANCHORED_VERSION_PATTERN = /\A\s*(#{VERSION_PATTERN})?\s*\z/ # :nodoc:

    def initialize(version)
      @version  = version
      @segments = nil
    end

    def version
      @version.dup
    end

    def segments
      @segments ||= @version.scan(/[0-9]+|[a-z]+/i).map do |s|
        /^\d+$/ =~ s ? s.to_i : s
      end
    end

    def <=>(other)
      return unless Gem::Version === other
      return 0 if @version == other.version

      lhsegments = segments
      rhsegments = other.segments

      lhsize = lhsegments.size
      rhsize = rhsegments.size
      limit  = (lhsize > rhsize ? lhsize : rhsize) - 1

      i = 0

      while i <= limit
        lhs, rhs = lhsegments[i] || 0, rhsegments[i] || 0
        i += 1

        next      if lhs == rhs
        return -1 if String  === lhs && Numeric === rhs
        return  1 if Numeric === lhs && String  === rhs

        return lhs <=> rhs
      end

      return 0
    end
  end
end
