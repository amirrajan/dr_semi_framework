require "/app/serialize.rb"

module LDP
  class Color
    def initialize(red: 0, green: 0, blue: 0, alpha: 255)
      @red = red.clamp(0, 255)
      @green = green.clamp(0, 255)
      @blue = blue.clamp(0, 255)
      @alpha = alpha.clamp(0, 255)
    end

    attr_reader :red, :green, :blue, :alpha

    WHITE = Color.new(red: 255, green: 255, blue: 255)
    BLACK = Color.new
    RED = Color.new(red: 255)
    GREEN = Color.new(green: 255)
    BLUE = Color.new(blue: 255)

    attr_reader :WHITE, :BLACK, :RED, :GREEN, :BLUE

    def with_red(red: @red)
      Color.new(red.clamp(0, 255), @green, @blue, @alpha)
    end

    def with_green(green: @green)
      Color.new(@red, green.clamp(0, 255), @blue, @alpha)
    end

    def with_blue(blue: @blue)
      Color.new(@red, @green, blue.clamp(0, 255), @alpha)
    end

    def with_alpha(alpha: @alpha)
      Color.new(@red, @green, @blue, alpha.clamp(0, 255))
    end

    def set_red!(red:)
      @red = red.clamp(0, 255)
      self
    end

    def set_green!(green:)
      @green = green.clamp(0, 255)
      self
    end

    def set_blue!(blue:)
      @blue = blue.clamp(0, 255)
      self
    end

    def set_alpha!(alpha:)
      @alpha = alpha.clamp(0, 255)
      self
    end

    include Serialize
  end

  class Primitive
    def initialize(x_pos: 0, y_pos: 0, color: Color::BLACK)
      @x_pos = x_pos
      @y_pos = y_pos
      @red = color.red
      @green = color.green
      @blue = color.blue
      @alpha = color.alpha
    end

    def make_new(x_pos: @x_pos, y_pos: @y_pos, color: @color)
      self.class.new(x_pos: x_pos, y_pos: y_pos, color: color)
    end

    def set_color!(color: @color)
      @red = color.red
      @green = color.green
      @blue = color.blue
      @alpha = color.alpha
      self
    end

    def set_pos!(x_pos: @x_pos, y_pos: @y_pos)
      @x_pos = x_pos#.clamp(0, 1280)
      @y_pos = y_pos#.clamp(0, 720)
      self
    end

    attr_reader :x_pos, :y_pos, :red, :green, :blue, :alpha

    alias x x_pos
    alias y y_pos
    alias r red
    alias g green
    alias b blue
    alias a alpha

    include Serialize
  end

  class Solid < Primitive
    def primitive_marker
      :solid
    end

    def initialize(x_pos: 0, y_pos: 0, width: 0, height: 0, color: Color::BLACK)
      super(x_pos: x_pos, y_pos: y_pos, color: color)
      @width = width
      @height = height
    end

    attr_reader :width, :height

    alias w width
    alias h height

    include Serialize
  end

  class StaticSolid < Solid
    def primitive_marker
      :static_solid
    end

    def initialize(x_pos: 0, y_pos: 0, width: 0, height: 0, color: Color::BLACK)
      super(x_pos: x_pos, y_pos: y_pos, width: width, height: height, color: color)
      $gtk.args.outputs.static_solids << self
    end
  end

  class Label < Primitive
    def primitive_marker
      :label
    end

    def initialize(x_pos: 0, y_pos: 0, text: "", color: Color::BLACK, font: "font.ttf", size: 0, alignment: 0)
      super(x_pos: x_pos, y_pos: y_pos, color: color)
      @text = text
      @font = font
      @size_enum = size
      @alignment_enum = alignment
    end

    attr_reader :text, :font, :size_enum, :alignment_enum

    include Serialize
  end

  class StaticLabel < Label
    def primitive_marker
      :static_label
    end

    def initialize(x_pos: 0, y_pos: 0, text: "", color: Color::BLACK, font: "font.ttf", size: 0, alignment: 0)
      super(x_pos: x_pos, y_pos: y_pos, text: text, color: color, font: font, size: size, alignment: alignment)
      $gtk.args.outputs.static_labels << self
    end
  end

  class Border < Primitive
    def primitive_marker
      :border
    end

    def initialize(x_pos: 0, y_pos: 0, width: 0, height: 0, color: Color::BLACK)
      super(x_pos: x_pos, y_pos: y_pos, color: color)
      @width = width
      @height = height
    end

    attr_reader :width, :height

    alias w width
    alias h height

    include Serialize
  end

  class StaticBorder < Border
    def primitive_marker
      :static_border
    end

    def initialize(x_pos: 0, y_pos: 0, width: 0, height: 0, color: Color::BLACK)
      super(x_pos: x_pos, y_pos: y_pos, width: width, height: height, color: color)
      $gtk.args.outputs.static_borders << self
    end
  end

  class Line < Primitive
    def primitive_marker
      :line
    end

    def initialize(x_pos1: 0, y_pos1: 0, x_pos2: 0, y_pos2: 0, color: Color::BLACK)
      super(x_pos: x_pos1, y_pos: y_pos1, color: color)
      @x_pos2 = x_pos2
      @y_pos2 = y_pos2
    end

    attr_reader :x_pos2, :y_pos2

    alias x2 x_pos2
    alias y2 y_pos2

    include Serialize

  end
end


def tick args
  args.outputs.lines << LDP::Line.new(x_pos1: 0, y_pos1: 0, x_pos1: 1280, y_pos1: 720)
end
