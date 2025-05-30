local Typer, super = Class(Object)

function Typer:init(width,height)
super.init(self,0,0,width,height)

self.textbox = Textbox(SCREEN_WIDTH/2-264,SCREEN_HEIGHT/2-51,529,103)
self.textbox.layer = 1000
self:addChild(self.textbox)

--self.font_size = 32
self.font_name = "main"

self.font = Assets.getFont(self.font_name,self.font_size)

self.input_text = {""}

self.has_portrait = false
self.portrait_page = 1

self.x_offset = 0
self.y_offset = 0
self.textures = {}

for _, id in pairs(Assets.texture_ids) do
    if Utils.startsWith(id, "face/typer/") then
        table.insert(self.textures, id:sub(6))
    end
end

table.sort(self.textures, function (a, b)
    return a:lower() < b:lower()
end)

end

function Typer:onAddToStage(stage)

    super.onAddToStage(self,stage)
    self:start()
end

function Typer:start()
    TextInput.attachInput(self.input_text, {
        --multilines = true,
        --enter_submits = true
    })
end

function Typer:togglePortrait()
    if self.has_portrait == false then
        self:updatePortrait()
        self.has_portrait = true
    elseif self.has_portrait == true then
        self.textbox:setText("[face:none][instant:true][voice:none]"..Game:getFlag("textboxtext"))
        self.has_portrait = false
    end
end

function Typer:updatePortrait()
    self.textbox:setText("[face:"..Game:getFlag("portrait_id","none")..","..self.x_offset..","..self.y_offset.."]"..Game:getFlag("textboxtext"))
end

function Typer:draw()
    super.draw(self)
    Game:setFlag("textboxtext",self.input_text[1])
    self.textbox:setText("[instant:true][voice:none]"..Game:getFlag("textboxtext"))
end

function Typer:stop()
    TextInput.endInput()
end

function Typer:onSubmit()
    self:stop()
end

return Typer
