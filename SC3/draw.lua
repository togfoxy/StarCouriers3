draw = {}

function draw.mainMenu()

	-- love.graphics.setColor(1,1,1,1)
	-- love.graphics.draw(IMAGES[enum.imagesMenuBackground], 0,0)

	for k, button in pairs(GUI_BUTTONS) do
		if button.scene == enum.sceneMainMenu and button.visible then
			-- draw the button
			love.graphics.setColor(button.bgcolour)
			if button.state == "on" then
				love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)			-- drawx/y is the top left corner of the square
                love.graphics.setColor(button.labeloncolour)
			else
				love.graphics.rectangle("line", button.x, button.y, button.width, button.height)			-- drawx/y is the top left corner of the square
                love.graphics.setColor(button.labeloffcolour)
			end
			-- draw the label
			-- love.graphics.setFont(FONT[enum.fontDefault])
            -- label colour is set in the if statement above
			love.graphics.setFont(FONT[enum.fontDefault])
			love.graphics.print(button.label, button.x + 5, button.y + 5)

		end
	end
end

local function drawStartBase()
	-- draw the starbase you start at

	local image = IMAGES[enum.imagesStarbase]
	local imagewidth = image:getWidth()
	local drawx = (FIELD_WIDTH / 2) -- imagewidth / 2
	local drawy = (FIELD_HEIGHT) - 125

	drawx = drawx * BOX2D_SCALE - imagewidth / 2
	drawy = drawy * BOX2D_SCALE
	love.graphics.setColor(1,1,1,0.25)
	love.graphics.draw(image, drawx, drawy)

	-- print words

	local txt = "STAGE " .. GAME_STAGE
	local txtwidth = FONT[enum.fontHeavyMetalLarge]:getWidth(txt)
	local txtScaling = 7		-- make font larger
	local drawx = (FIELD_WIDTH / 2) * BOX2D_SCALE
	drawx = drawx - (txtwidth / 2 * txtScaling)
	local drawy = (FIELD_HEIGHT - 50) * BOX2D_SCALE
	love.graphics.setFont(FONT[enum.fontHeavyMetalLarge])
    love.graphics.setColor(1,1,1,0.25)
	love.graphics.printf(txt, drawx, drawy, 1000, "left", 0, txtScaling, txtScaling)


end

function draw.asteroids()
	cam:attach()

	cf.printAllPhysicsObjects(PHYSICSWORLD, BOX2D_SCALE)

	-- draw the starting starbase
	drawStartBase()


	cam:detach()
end

return draw
