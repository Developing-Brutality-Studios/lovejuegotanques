pantallaActual=1
local inter= require "interf"
local juego=require "juego"
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
        love.window.setMode(1200, 600,{resizable=false,vsync=true})
        juego.new(inter.ini.modo,1200,600)     
end

function love.update(dt)   
        --eventos de mouse para elegir la opcion en el menu
    juego.mododejuego.proupdate(dt)
    
end

function love.draw()

    
    if inter.even == 4 then 
        pantallas[pantallaActual].dibujarCapas()
        --love.graphics.draw(ifr,0,0)
    else
        inter.dibijarElementos()
    end
end
function love.mousereleased(x, y, button)
    inter.mousehandler(x,y,button)      
end 
