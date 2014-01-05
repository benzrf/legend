class Range
	def overlap?(other)
		include? other.first or include? other.last
	end
end

DIRECTIONS = [:north, :south, :east, :west]
OPPOSITES  = {north: :south, south: :north,
							east: :west, west: :east}

class Symbol
	def flip
		OPPOSITES[self]
	end
end

module Positioned
	def max_x
		x + x_size
	end

	def max_y
		y + y_size
	end

	def x_range
		x..max_x
	end

	def y_range
		y..max_y
	end

	def collide?(other)
		if other.respond_to? :to_ary
			other = other.to_ary
			x_range.include? other[0] and y_range.include? other[1]
		else
			x_range.overlap? other.x_range and y_range.overlap? other.y_range
		end
	end

	def direction_from(other)
		if other.respond_to? :to_ary
			other = other.to_ary
			ox, oy, omax_x, omax_y = other + other
		else
			ox, oy, omax_x, omax_y = other.x, other.y, other.max_x, other.max_y
		end
		distances = {north: omax_y - y, south: max_y - oy,
							 east: max_x - ox, west: omax_x - x}
		# we want the greatest one since other might not be perfectly
		# aligned in the less-differing axis; i.e.,
		# [x=10, y=10, ox=9, oy=0] is clearly north and not east
		distances.max_by(&:last).first
	end

	def direction_to(other)
		direction_from(other).flip
	end

	def collide!(other)
		return unless kind_of? EventTarget # TODO: create EventTarget...
		event_data = {}
		event_data[:room] = room
	end
end

# vim:set tabstop=2 shiftwidth=2 noexpandtab:
