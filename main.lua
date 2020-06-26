pantallaActual=1
local juego=require "juego"
local inter= require "interf"
local save = require "/save/controles"
pantallas={}
for i=1,2 do 
pantallas[i]=0;
end
local ssangulo = math.rad(90)

pantallas[1]=juego
eventoss={}
ifr=nil


    function love.load()
        love.window.setTitle("Tanks")
        xw,yw= love.window.getDesktopDimensions(1)
        love.window.setMode(xw, yw,{fullscreen=true,vsync=true})
        juego.new(4,xw,yw)
        
    
    end

    function love.update(dt)
        --eventos de mouse para elegir la opcion en el menu
        local joysticks = love.joystick.getJoysticks()
        juego.mododejuego.proupdate(dt,joysticks[1])
    end

function love.draw()    
    if inter.even == 4 then 
        pantallas[pantallaActual].dibujarCapas()
        --love.graphics.draw(ifr,0,0)
    else
        inter.dibijarElementos()
        save.save()

    end
end

function love.keypressed(key,scancode,isrepeat)
    if key=="x" then
    love.event.quit(0)
    end
    if inter.even == 4 then 
    juego.mododejuego.keypressed( key,scancode,isrepeat)
    end 
end
function love.mousereleased(x, y, button)
    inter.mousehandler(x,y,button)      
end 