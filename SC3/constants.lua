constants = {}

function constants.load()

    SCREEN_WIDTH = 1920
    SCREEN_HEIGHT = 1080

    FIELD_WIDTH = 1000	-- metres
    FIELD_HEIGHT = 2000	-- metres
    FIELD_SAFEZONE = 100	-- this is 1oo metres height on/near the spacedock

    GAME_STAGE = 1

    BOX2D_SCALE = 5
    TRANSLATEX = 1
    TRANSLATEY = 1
    ZOOMFACTOR = 1

    NUMBER_OF_ASTEROIDS = GAME_STAGE

    SCREEN_STACK = {}
    GUI_BUTTONS = {}
    ECS_ENTITIES = {}
	PHYSICS_ENTITIES = {}
	SHOPWORLD = {}
	ECSWORLD = {}
	RECEIPT = {}
    PLAYER = {}
    BUBBLE = {}

    enum = {}               -- global
    enum.sceneMainMenu = 1
    enum.sceneAsteroids = 2
    enum.sceneShop = 3
    enum.sceneDead = 4

    enum.fontDefault = 1

    enum.buttonNewGame = 1


end
return constants
