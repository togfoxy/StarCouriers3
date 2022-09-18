constants = {}

function constants.load()

    SCREEN_WIDTH = 1920
    SCREEN_HEIGHT = 1080

    FIELD_WIDTH = 1500	-- metres
    FIELD_HEIGHT = 2000	-- metres
    FIELD_SAFEZONE = 150	-- this is metres above the bottom spacedock

    PLAYER_START_X = FIELD_WIDTH / 2
    PLAYER_START_Y = (FIELD_HEIGHT) - 175

    GAME_STAGE = 30
    GAME_TIMER_DEFAULT = 5
    GAME_TIMER = GAME_TIMER_DEFAULT      -- loop for this many seconds

    CARD_WIDTH = 100
    CARD_HEIGHT = 150

    PHYSICS_DENSITY = 1.15
    PHYSICS_TURNRATE = 0       -- how fast can objects turn

    BOX2D_SCALE = 5
    TRANSLATEX = 1
    TRANSLATEY = 1
    ZOOMFACTOR = 1

    rotation_error_prior = 0
    rotation_integral_prior = 0
    rotation_value_out_prior = 0
    thrust_error_prior = 0
    thrust_integral_prior = 0
    thrust_value_out_prior = 0

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
    QUAD_ARROWS = {}        -- for the cards
    SOUND = {}

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

    -- images and quads use the same sequence so must have unique numbers
    enum.imagesStarbase = 1
    enum.imagesQuarterPort = 2
    enum.quadsArrows = 3

    enum.gamemodePlanning = 1
    enum.gamemodeAction = 2

    GAME_MODE = enum.gamemodePlanning

end
return constants
