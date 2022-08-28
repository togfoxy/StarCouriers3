draw = {}

local function drawGUIButtons(activeScene)
	-- activeScene is an enum eg enum.sceneMainMenu

	for k, button in pairs(GUI_BUTTONS) do
		if button.scene == activeScene and button.visible then
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
			love.graphics.printf(button.label, button.x + 5, button.y + 5, button.width, "center")
		end
	end

end

function draw.mainMenu()

	-- love.graphics.setColor(1,1,1,1)
	-- love.graphics.draw(IMAGES[enum.imagesMenuBackground], 0,0)

	drawGUIButtons(enum.sceneMainMenu)
end

local function drawStartBase()
	-- draw the starbase you start at
	-- draw the starbase you stop at

	-- draw image for bottom starbase
	local image = IMAGES[enum.imagesStarbase]
	local imagewidth = image:getWidth()
	local drawx = (FIELD_WIDTH / 2)
	local drawy = (FIELD_HEIGHT) - 125

	drawx = drawx * BOX2D_SCALE - imagewidth / 2
	drawy = drawy * BOX2D_SCALE
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(image, drawx, drawy)

	-- draw image for top starbase
	local drawy = 85 * BOX2D_SCALE - (image:getHeight() / 2)
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(image, drawx, drawy)

	-- print bottom words
	local txt = "STAGE " .. GAME_STAGE
	local txtwidth = FONT[enum.fontHeavyMetalLarge]:getWidth(txt)
	local txtScaling = 7		-- make font larger
	local drawx = (FIELD_WIDTH / 2) * BOX2D_SCALE
	drawx = drawx - (txtwidth / 2 * txtScaling)
	local drawy = (FIELD_HEIGHT - 50) * BOX2D_SCALE
	love.graphics.setFont(FONT[enum.fontHeavyMetalLarge])
    love.graphics.setColor(1,1,1,1)
	love.graphics.printf(txt, drawx, drawy, 1000, "left", 0, txtScaling, txtScaling)

	-- print top words
	txt = "STAGE " .. GAME_STAGE + 1
	txtwidth = FONT[enum.fontHeavyMetalLarge]:getWidth(txt)
	drawx = (FIELD_WIDTH / 2) * BOX2D_SCALE
	drawx = drawx - (txtwidth / 2 * txtScaling)
	local drawy = 25 * BOX2D_SCALE
	love.graphics.setFont(FONT[enum.fontHeavyMetalLarge])
	love.graphics.setColor(1,1,1,1)
	love.graphics.printf(txt, drawx, drawy, 1000, "left", 0, txtScaling, txtScaling)
end

local function drawAsteroids()

	for k, obj in pairs(PHYSICS_ENTITIES) do
		local udtable = obj.fixture:getUserData()
		if udtable.objectType == "Asteroid" and udtable.isVisible then
			local body = obj.body
			local mass = cf.round(body:getMass())
			local x0, y0 = body:getPosition()
			for _, fixture in pairs(body:getFixtures()) do
				local shape = fixture:getShape()
				local points = {body:getWorldPoints(shape:getPoints())}
				for i = 1, #points do
					points[i] = points[i] * BOX2D_SCALE
				end

				if udtable.oreType == enum.oreTypeGold then
					love.graphics.setColor(236/255,164/255,18/255,0.75)
					love.graphics.polygon("fill", points)
				elseif udtable.oreType == enum.oreTypeSilver then
					love.graphics.setColor(192/255,192/255,192/255,1)
					love.graphics.polygon("fill", points)
				elseif udtable.oreType == enum.oreTypeBronze then
					love.graphics.setColor(122/255,84/255,9/255,0.5)
					love.graphics.polygon("fill", points)
				else
					love.graphics.setColor(139/255,139/255,139/255,1)
					love.graphics.polygon("line", points)
				end
				-- -- print the mass for debug reasons
				-- love.graphics.setColor(1,1,1,1)
				-- love.graphics.print(cf.round(obj.currentMass), (x0 * BOX2D_SCALE) + 15, (y0 * BOX2D_SCALE) - 15)
			end

		end
	end
end

local function drawCards()
	-- assumes the deck is already populated

	assert(#ECS_DECK > 0)

	local drawx = 100
	local drawy = SCREEN_HEIGHT - 200


	for k,v in pairs(ECS_DECK) do
		local allComponents = v:getComponents()
		for _, component in pairs(allComponents) do
			local txt = component.label
			if txt ~= "" and txt ~= nil then		-- things like 'drawable' don't have a label
				love.graphics.setFont(FONT[enum.fontTech18])
				love.graphics.setColor(1,1,1,1)
				love.graphics.printf(txt, drawx + 5, drawy + 5, CARD_WIDTH, "center")
				component.x = drawx
				component.y = drawy

				-- draw the arrow/image/quad
				if component.quadnumber ~= nil then
					love.graphics.draw(IMAGES[enum.quadsArrows], QUAD_ARROWS[component.quadnumber], drawx, drawy, 0, 1, 1, -10, -35)
				end

				if component.selected then
					love.graphics.setColor(0,1,0,0.33)
				else
					love.graphics.setColor(1,1,1,0.33)
				end
				love.graphics.rectangle("fill", drawx, drawy, CARD_WIDTH, CARD_HEIGHT)
				drawx = drawx + CARD_WIDTH + 20


			end
		end
	end

	drawGUIButtons(enum.sceneAsteroids)
end

function draw.asteroids()
	cam:attach()
	-- cf.printAllPhysicsObjects(PHYSICSWORLD, BOX2D_SCALE)

	ECSWORLD:emit("draw")		-- draws all entities
	drawStartBase()
	drawAsteroids()

	cam:detach()

	if GAME_MODE == enum.gamemodePlanning then
		drawCards()		-- includes the end button
	end


end

return draw
