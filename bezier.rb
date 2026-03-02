# frozen_string_literal: true

require 'raylib/raymath'

class Bezier
  def initialize(p1, p2, c1, c2)
    @p1 = p1
    @p2 = p2
    @c1 = c1
    @c2 = c2
    @density = 50
    @show_lines = false
  end

  def update_point(i, pos)
    case i
    when 0
      @p1 = pos
    when 1
      @p2 = pos
    when 2
      @c1 = pos
    when 3
      @c2 = pos
    end
  end

  def show_lines(state)
    @show_lines = state
  end

  def draw
    draw_points
    draw_lines if @show_lines
    segments = [@p1] + (1..@density).map { |i| l3_lerp_point(i * 100.0 / @density) } + [@p2]
    (0..segments.length - 2).each do |i|
      draw_line_v(segments[i], segments[i + 1], DARKGRAY)
    end
  end

  def draw_lines
    draw_line_v(@p1, @c1, DARKGRAY)
    # draw_line_v(@c1, @c2, DARKGRAY)
    draw_line_v(@c2, @p2, DARKGRAY)
  end

  def l3_lerp_point(percent)
    # LEVEL 1:
    pc = lerp_point(@p1, @c1, percent)
    cc = lerp_point(@c1, @c2, percent)
    cp = lerp_point(@c2, @p2, percent)
    # draw_circle_v(pc, 4, GREEN)
    # draw_circle_v(cc, 4, GREEN)
    # draw_circle_v(cp, 4, GREEN)
    # draw_line_v(pc, cc, DARKGRAY)
    # draw_line_v(cc, cp, DARKGRAY)

    # LEVEL 2:
    pcc = lerp_point(pc, cc, percent)
    ccp = lerp_point(cc, cp, percent)
    # draw_circle_v(pcc, 4, ORANGE)
    # draw_circle_v(ccp, 4, ORANGE)
    # draw_line_v(pcc, ccp, DARKGRAY)

    # LEVEL 3:
    # pccp = lerp_point(pcc, ccp, percent)
    lerp_point(pcc, ccp, percent)
    # draw_circle_v(pccp, 1, DARKGRAY)
  end

  def lerp_point(p1, p2, percent)
    v = vector2_subtract(p2, p1)
    l = vector2_scale(v, percent / 100.0)
    vector2_add(p1, l)
  end

  def draw_points
    draw_circle_v(@p1, 4, RED)
    draw_circle_v(@p2, 4, RED)
    draw_rectangle_v(Vector2.create(@c1.x - 3, @c1.y - 3), Vector2.create(6, 6), BLUE)
    draw_rectangle_v(Vector2.create(@c2.x - 3, @c2.y - 3), Vector2.create(6, 6), BLUE)
  end
end
