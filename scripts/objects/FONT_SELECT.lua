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

    self.max_font_page = 1 + math.floor(math.max(0, #self.fonts - 1)/8)
    self.pos_var = 1
end

function FontSelect:update()
    super.update(self)

    self.rectangle.height = self.height
    self.rectangle.width = 67+Assets.getFont("main"):getWidth(self.fonts[1])+5

    if Input.mousePressed(1) then

        if self.right_arrow and self.right_arrow:clicked() then
            self.pos_var = 1
            self.font_page = self.font_page + 1 
            if self.font_page > self.max_font_page then
                self.font_page = 1
            end
            for i,v in ipairs(self.children) do 
                if v ~= self.right_arrow then
                    self:removeChild(v)
                end
            end
            self:addButtons()
        end

        if self.left_arrow and self.left_arrow:clicked() then
            self.pos_var = 1
            self.font_page = self.font_page - 1 
            if self.font_page < 1 then
                self.font_page = self.max_font_page
            end
            for i,v in ipairs(self.children) do 
                if v ~= self.right_arrow then
                    self:removeChild(v)
                end
            end
            self:addButtons()
        end
        if self:isMouseOver() then
            self:addChild(self.rectangle)
            self.left_arrow = Sprite("left_arrow",15,325)
            self.left_arrow:setScale(2)

            self.right_arrow = Sprite("right_arrow",100,325)
            self.right_arrow:setScale(2)
            self:addChild(self.right_arrow)
            self:addChild(self.left_arrow)

            if self.mouse_clicked == false then
                self.mouse_clicked = true
                self.height = self.height+350
                self:addButtons()
            end
            self.parent:updateFont()
        else
            if self.mouse_clicked then
                self.mouse_clicked = false
                self.height = self.height-350
                for i,v in ipairs(self.children) do 
                    self:removeChild(v)
                    self.pos_var = 1
                end
            end
        end
    end
end


function FontSelect:draw()
    super.draw(self)


    if self.mouse_clicked == true then
        love.graphics.setColor(1,1,1,1)
        love.graphics.print(self.font_page.."/"..self.max_font_page,45,320)
        
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

function FontSelect:ToggleSelect()
    if self.mouse_clicked == true then
        self.mouse_clicked = false
        self.height = self.height-350
        for i,v in ipairs(self.children) do 
            self:removeChild(v)
            self.pos_var = 1
        end
        self.parent:updateFont()
    end
end

function FontSelect:addButtons()
    local start = (self.font_page - 1) * 8 + 1
    local endd = math.min(self.font_page * 8, #self.fonts)

    for i = start,endd do
        self.font_button = FONT_BUTTON(0,0+35*self.pos_var,100,25,self.fonts[i])
        self:addChild(self.font_button)
        self.pos_var = self.pos_var + 1                     
    end
end
return FontSelect