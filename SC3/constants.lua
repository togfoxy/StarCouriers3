constants = {}

function constants.load()

    SCREEN_WIDTH = 1920
    SCREEN_HEIGHT = 1080

    FIELD_WIDTH = 1500	-- metres
    FIELD_HEIGHT = 2000	-- metres
    FIELD_SAFEZONE = 150	-- this is metres above the bottom spacedock

    GAME_STAGE = 1

    CARD_WIDTH = 100
    CARD_HEIGHT = 150


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
    IMAGES = {}
    FONT = {}
    ECS_DECK = {}       -- deck of cards

    enum = {}               -- global
    enum.sceneMainMenu = 1
    enum.sceneAsteroids = 2
    enum.sceneShop = 3
    enum.sceneDead = 4

    enum.fontDefault = 1
    enum.fontHeavyMetalLarge = 2
    enum.fontTech18 = 3

    enum.buttonNewGame = 1
    enum.buttonEndTurn = 2

    enum.imagesStarbase = 1

    enum.gamemodePlanning = 1
    enum.gamemodeAction = 2

    GAME_MODE = enum.gamemodePlanning

end
return constants
