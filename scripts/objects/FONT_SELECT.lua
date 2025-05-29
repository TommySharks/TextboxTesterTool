local FontSelect, super = Class(Object)

function FontSelect:init(x,y,width,height)
    super.init(self,x,y,width,height)
    self.layer = 50
    self.mouse_clicked = false
    self.fonts = Utils.getFilesRecursive(Mod.info.path.."/assets/fonts",".json")
    table.insert(self.fonts,1,"main")
    self.font_page = 1
    self.font_button = nil
    
    self.rectangle = Rectangle(0,0,self.width+Assets.getFont("main"):getWidth(self.fonts[1])+5,self.height)
    self.rectangle:setColor(0,0,0)
    --self.width = self.width+Assets.getFont(self.fonts[self.font_page]):getWidth(self.fonts[self.font_page])+5
end

function FontSelect:update()
    super.update(self)
    
    self.rectangle.height = self.height
    self.rectangle.width = 67+Assets.getFont("main"):getWidth(self.fonts[1])+5

    if Input.mousePressed() then
        if self:isMouseOver() then
            self:addChild(self.rectangle)
            if self.mouse_clicked == false then
                self.mouse_clicked = true
                self.height = self.height+350

                for i, v in ipairs(self.fonts) do
                    self.font_button = FONT_BUTTON(0,0+35*i,100,25,v)
                    self:addChild(self.font_button)
                end
            elseif self.mouse_clicked == true then
                self.mouse_clicked = false
                self.height = self.height-350
                for i,v in ipairs(self.children) do 
                    self:removeChild(v)
                end
            end
            self.parent:updateFont()
        else
            if self.mouse_clicked then
                self.mouse_clicked = false
                self.height = self.height-350
                for i,v in ipairs(self.children) do 
                    self:removeChild(v)
                end
            end
        end
    end

    if self.font_page > #self.fonts then
        self.font_page = 1
    elseif self.font_page < 1 then
        self.font_page = #self.fonts
    end

    for i,v in ipairs(self.children) do
        if v ~= self.rectangle then
            v.y = v.y+Mod.scroll_y
        end
    end

end


function FontSelect:draw()
    super.draw(self)


    if self.mouse_clicked == true then
        love.graphics.setColor(0,0,0,1)
        --love.graphics.rectangle("fill",0,0,self.width+Assets.getFont(self.fonts[self.font_page]):getWidth(self.fonts[self.font_page]),self.height)
        love.graphics.setColor(1,1,1,1)
        
    end
    if self:isMouseOver() and self.mouse_clicked == false then
        love.graphics.setColor(1,1,0,1)
    end

    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", 0, 0, self.width+Assets.getFont("main"):getWidth(self.fonts[1])+5, self.height)
    love.graphics.setFont(love.graphics.newFont("assets/fonts/main.ttf",32))
    love.graphics.print("Font: "..self.fonts[1],3,-5)
end

function FontSelect:isMouseOver()
    local mx, my = Input.getCurrentCursorPosition()
    if mx > self.x and mx < self.width+Assets.getFont("main"):getWidth(self.fonts[1])+5+self.x and my > self.y and my < self.height+self.y then
        return true
    else
        return false
    end
end

return FontSelect