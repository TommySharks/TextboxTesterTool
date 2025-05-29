local TextboxTester, super = Class(Object)

function TextboxTester:init(width,height)
super.init(self,0,0,width,height)

self.rectangle = Rectangle(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)
self.rectangle:setColor(0,0,0,1)

self.clipboard_button = Sprite("clipboard",33,320)

self.portrait_toggle = Sprite("box_unchecked",161,113)

self.font_button = Rectangle(555,55,25,25)
self.font_button:setColor(0,0,1)

self.font_page = 0

self.x_offset = 0
self.y_offset = 0

self.left_arrow = Sprite("left_arrow",320,113)
self.left_arrow:setScale(2)

self.right_arrow = Sprite("right_arrow",320+Assets.getFont("main"):getWidth(self.x_offset)+10,113)
self.right_arrow:setScale(2)

self.up_arrow = Sprite("up_arrow",555,95)
self.up_arrow:setScale(2)

self.down_arrow = Sprite("down_arrow",555,138)
self.down_arrow:setScale(2)

self.textures = {}
self.fonts = Utils.getFilesRecursive(Mod.info.path.."/assets/fonts",".json")

self.portrait_select = false
self.mouse_clicked = false

self.faces_y = 0
self.clipboardtexttimer = 0

for _, id in pairs(Assets.texture_ids) do
    if Utils.startsWith(id, "face/typer/") then
        table.insert(self.textures, id:sub(6))
    end
end

table.sort(self.textures, function (a, b)
    return a:lower() < b:lower()
end)

self.typer = TYPER()
self.font_select = FONT_SELECT(33,80,67,25)
self:addChild(self.rectangle)
self:addChild(self.clipboard_button)
self:addChild(self.portrait_toggle)
self:addChild(self.font_button)
self:addChild(self.typer)
self:addChild(self.font_select)

self:addChild(self.left_arrow)
self:addChild(self.right_arrow)
self:addChild(self.up_arrow)
self:addChild(self.down_arrow)

self:addChild(Text("X Offset:",207,107,300,500))
self:addChild(Text("Y Offset:",440,107,300,500))
self:addChild(Text("Portrait:",33,107,300,500))
end

function TextboxTester:draw()
    super.draw(self)
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(love.graphics.newFont("assets/fonts/main.ttf",32))
    love.graphics.print(""..self.typer.x_offset,340,108)
    love.graphics.print(""..self.typer.y_offset,561,107)

    

    if self.clipboardtexttimer > 0 then
        Draw.printShadow("Copied to your clipboard!", 0, 480 - 450, 0, "center", 640)
    end

    if self.portrait_select == true then
        Draw.setColor(1, 1, 1, 1)
        
        local textures = {}
        for _, id in pairs(Assets.texture_ids) do
            if Utils.startsWith(id, "face/typer/") then
                table.insert(textures, id:sub(6))
            end
        end

        -- Sort textures alphabetically
            table.sort(textures, function (a, b)
            return a:lower() < b:lower()
        end)

        Draw.pushScissor()
        Draw.scissorPoints(0, 350, 640, 480)

        local name = "Press CONFIRM to go back."

        local gap = 128
        local x_offset = 64
        local y_offset = 350
        local faces_per_row = 4
        local total_height = (math.ceil(#textures / faces_per_row) * gap+y_offset)

        self.faces_y = Utils.clamp(self.faces_y, -(total_height - 480 + 48 + 96), 0)

        local scrollbar_height = 240 - y_offset - 38
        local scrollbar_y = 350 + (scrollbar_height * (self.faces_y / total_height))
        Draw.setColor(1, 1, 1, 0.5)
        love.graphics.rectangle("fill", 640 - 16, 240+36+48, 4, 240 - 30 - 48)
        Draw.setColor(1, 1, 1, 1)
        love.graphics.rectangle("fill", 640 - 16, scrollbar_y, 4, scrollbar_height * (scrollbar_height / total_height))
        Draw.setColor(1, 1, 1, 1)

        for i, texture_id in ipairs(textures) do
            local x = (i - 1) % faces_per_row
            local y = math.floor((i - 1) / faces_per_row)
            local texture = Assets.getTexture("face/" .. texture_id)
            Draw.draw(texture, x_offset + (x * gap), y_offset + (self.faces_y + (y * gap)), 0, 2, 2)

            local width = texture:getWidth() * 2
            local height = texture:getHeight() * 2

            local mx, my = Input.getCurrentCursorPosition()

            if my > 335 then
                if mx > x_offset + (x * gap) and mx < x_offset + (x * gap) + width and
            my > y_offset + (self.faces_y + (y * gap)) and my < y_offset + (self.faces_y + (y * gap)) + height then
                love.graphics.setLineWidth(2)
                Draw.setColor(0, 1, 1, 1)
                love.graphics.rectangle("line", x_offset + (x * gap) - 1, y_offset + (self.faces_y + (y * gap)) - 1,
                                        width + 2, height + 2)
                Draw.setColor(1, 1, 1, 1)

                name = texture_id
                if self.clicked_name == name then
                    --name = "Copied to clipboard!"
                else
                    self.clicked_name = nil
                end

                if self.mouse_clicked then
                    self.clicked_name = texture_id
                    local filename = texture_id
                    -- Remove everything before the last slash
                    filename = Utils.split(filename, "/")[#Utils.split(filename, "/")]
                    Game:setFlag("portrait_id",texture_id)
                    self.typer:updatePortrait()
                    love.system.setClipboardText(filename)
                end

                
                Draw.popScissor()               
                Draw.printShadow(name, 0, 480 - 450, 0, "center", 640)
                end
            end
        end
    end
    self.mouse_clicked = false
end

function TextboxTester:update()
    super.update(self)

    self.right_arrow.x = 330+Assets.getFont("main"):getWidth(self.typer.x_offset)+10
    if Input.mousePressed() and not clicked then
        if self.portrait_toggle and self.portrait_toggle:clicked() then
            if self.portrait_select == false then
                self.portrait_toggle:setSprite("box_checked")
                self.portrait_select = true
                self.typer:togglePortrait()
            else
                self.portrait_toggle:setSprite("box_unchecked")
                self.portrait_select = false
                self.typer:togglePortrait()
            end
        
        elseif self.font_button and self.font_button:clicked() then
                self.font_page = self.font_page + 1
                print(self.fonts[self.font_page])
                self.typer.textbox:setFont(self.fonts[self.font_page])
            
        elseif self.left_arrow and self.left_arrow:clicked() then
            self.typer.x_offset = self.typer.x_offset - 1
            if self.typer.has_portrait == true then
                self.typer:updatePortrait()
            end

        elseif self.right_arrow and self.right_arrow:clicked() then
            self.typer.x_offset = self.typer.x_offset + 1
            if self.typer.has_portrait == true then
                self.typer:updatePortrait()
            end

        elseif self.up_arrow and self.up_arrow:clicked() then
            self.typer.y_offset = self.typer.y_offset - 1
            if self.typer.has_portrait == true then
                self.typer:updatePortrait()
            end

        elseif self.down_arrow and self.down_arrow:clicked() then
            self.typer.y_offset = self.typer.y_offset + 1
            if self.typer.has_portrait == true then
                self.typer:updatePortrait()
            end
        elseif self.clipboard_button and self.clipboard_button:clicked() then
            local filename = Game:getFlag("portrait_id")
            filename = Utils.split(filename, "/")[#Utils.split(filename, "/")]
            local actor_name = Utils.split(Game:getFlag("portrait_id"), "/")[2]
            love.system.setClipboardText("cutscene:text(\""..Game:getFlag("textboxtext").."\", \""..filename.."\", \""..actor_name.."\")")
            self.clipboardtexttimer = 1
        end
        self.mouse_clicked = true
    end
    --cutscene:text("aaaaaa", "awkward_2", "asgore")
    
    if self.portrait_select == true then
        
        function Input.onWheelMoved(x,y)
            local mx, my = Input.getCurrentCursorPosition()
            if my > 335 then
                self.faces_y = self.faces_y + (y * 32)
            end
        end

    end
    self.clipboardtexttimer = self.clipboardtexttimer - 0.01

    if self.clipboardtexttimer < 0 then
        self.clipboardtexttimer = 0
    end
end

function TextboxTester:updateFont()

    self.typer.textbox:setFont(self.font_select.fonts[1])

end


return TextboxTester
