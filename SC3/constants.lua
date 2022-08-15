constants = {}

function constants.load()

    SCREEN_WIDTH = 1920
    SCREEN_HEIGHT = 1080

    SCREEN_STACK = {}
    GUI_BUTTONS = {}


    enum = {}               -- global
    enum.sceneMainMenu = 1
    enum.sceneAsteroids = 2
    enum.sceneShop = 3
    enum.sceneDead = 4

    enum.fontDefault = 1

    enum.buttonNewGame = 1


end
return constants
