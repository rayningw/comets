
module Gamelib
  def self.run(width, height, &p)
    require 'game_frame'
    require 'image_store'

    GameFrame.new(width, height) do |gf|
      p[gf]
    end
  end
end
