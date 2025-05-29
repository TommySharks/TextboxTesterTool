local FontButton, super = Class(Object)

function FontButton:init(x,y,width,height,text)
    super.init(self,x,y,width,height)
    self.layer = 1000000
    self.text_string = text
    --self.text_object = Text(text,0,0,500,100)
    --self:addChild(self.text_object)

end

function FontButton:update()
    super.update(self)

    if Input.mousePressed() then
        if self:isMouseOver() then
            for i,v in ipairs(self.parent.fonts) do
                if v == self.text_string then
                    table.remove(self.parent.fonts,i)
                    table.insert(self.parent.fonts,1,self.text_string)
                end
            end
        end
    end
end

function FontButton:draw()
    if self:isMouseOver() then
        love.graphics.setColor(1,1,0,1)
    end
    love.graphics.setFont(love.graphics.newFont("assets/fonts/main.ttf",32))
    love.graphics.print(self.text_string,0,0)
    love.graphics.setColor(1,1,1,1)
end

function FontButton:isMouseOver()
    local mx, my = Input.getMousePosition()
    local new_x, new_y = self:localToScreenPos()
    if mx > new_x and mx < self.width+new_x and my > new_y and my < self.height+new_y then
        return true
    else
        return false
    end
end

return FontButton