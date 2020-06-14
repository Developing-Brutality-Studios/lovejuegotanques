pantallaActual=1
local juego=require "juego"
pantallas={}
for i=1,2 do 
pantallas[i]=0;
end
local ssangulo = math.rad(90)
local xw,yw,flg
pantallas[1]=juego
eventoss={}
ifr=nil

--{fullscreen=true,fullscreentype="exclusive"}
function love.load()
    love.window.setTitle("Tanks")
    xw,yw= love.window.getDesktopDimensions(1)
    love.window.setMode(640,360,{fullscreen=true,fullscreentype="exclusive"})
    juego.new(4,640,360)
end

function love.update(dt)
    --eventos de mouse para elegir la opcion en el menu
    local joysticks = love.joystick.getJoysticks()
    juego.mododejuego.proupdate(dt,joysticks)
end

function love.draw()
pantallas[pantallaActual].dibujarCapas()
--love.graphics.draw(ifr,0,0)
end

function love.keypressed(key,scancode,isrepeat)
    if key=="x" then
    love.event.quit(0)
    end
end