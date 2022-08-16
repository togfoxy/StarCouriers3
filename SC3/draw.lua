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
			love.graphics.print(button.label, button.x + 5, button.y + 5)

		end
	end
end

function draw.asteroids()
	cam:attach()

	cf.printAllPhysicsObjects(PHYSICSWORLD, BOX2D_SCALE)


	cam:detach()
end

return draw
