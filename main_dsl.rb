# frozen_string_literal: true

require 'pry'
require 'raylib/dsl'
require_relative 'bezier'

init_window(800, 450, 'Raylib template - DSL version!')

b = nil
points = []

until window_should_close
  if is_key_pressed(KEY_SPACE)
    b = nil
    points = []
  end

  if is_mouse_button_pressed(MOUSE_BUTTON_LEFT) && points.length < 4
    m_pos = get_mouse_position
    points << m_pos
    b = Bezier.new(points[0], points[1], points[2], m_pos) if points.length == 4
  end

  b.show_lines(false) if is_mouse_button_up(MOUSE_BUTTON_LEFT) && points.length == 4

  if is_mouse_button_down(MOUSE_BUTTON_LEFT) && points.length == 4
    m_pos = get_mouse_position

    point = if (m_pos.x - points[0].x).abs < 6 && (m_pos.y - points[0].y).abs < 6
              0
            elsif (m_pos.x - points[1].x).abs < 6 && (m_pos.y - points[1].y).abs < 6
              1
            elsif (m_pos.x - points[2].x).abs < 6 && (m_pos.y - points[2].y).abs < 6
              2
            elsif (m_pos.x - points[3].x).abs < 6 && (m_pos.y - points[3].y).abs < 6
              3
            else
              -1
            end
    if point != -1
      points[point] = m_pos
      b.update_point(point, m_pos)
      b.show_lines(true) if [2, 3].include?(point)
    end
  end
  begin_drawing
  clear_background(WHITE)

  if points.length < 4
    draw_circle_v(points[0], 4, RED) if points[0]
    draw_circle_v(points[1], 4, RED) if points[1]
    draw_circle_v(points[2], 3, LIGHTGRAY) if points[2]
  end
  b.draw if b.is_a?(Bezier)
  end_drawing
end

close_window
