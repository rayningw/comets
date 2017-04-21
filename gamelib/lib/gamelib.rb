
module Gamelib
  def self.run(width, height, &p)
    require_relative './game_frame'
    require_relative './image_store'

    GameFrame.new(width, height) do |gf|
      p[gf]
    end
  end
end
