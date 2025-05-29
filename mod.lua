function Mod:init()
    print("Loaded "..self.info.name.."!")

    self.scroll_y = 0
end

function Mod:load()
    Game.can_open_menu = false
end

function Mod:postInit()

    if Game.world.map.id == "room1" then

        Game.TEXTBOX_TESTER = TEXTBOX_TESTER()

        Game.stage:addChild(Game.TEXTBOX_TESTER)
    end
end

function Mod:onWheelMoved(x,y)
    
    self.scroll_y = Utils.clamp(self.scroll_y + y*10, 100000, 10000)

end