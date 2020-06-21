local ts={entidades=require "../entidades/entidadesTS",mapa=require "../mapa/mapaTS",puntosEquipos={},mdx=400,mdy=300,ancho=800,alto=600}
--corregir a nuevos parametros
local ssangulo=math.rad(90)
local ancho=0
local alto=0
local inputUno={}
local inputDos={}

function ts.new(ancc,altt)
    ts.mapa.new("../mapas/TS","//assets/terrainTiles_default.png")
    ancho=ts.mapa.tablamapa.width*64
    alto=ts.mapa.tablamapa.height*64
    ts.ancho=ancc
    ts.alto=altt
    ts.mdx=math.floor(ancc/2)
    ts.mdy=math.floor(altt/2)
    inputUno.adelante="w"
    inputUno.atras="s"
    inputUno.derecha="d"
    inputUno.izquierda="a"
    inputUno.disparar="q"
    inputUno.mina="e"
    inputUno.joystick=false
    inputDos.adelante="i"
    inputDos.atras="k"
    inputDos.derecha="l"
    inputDos.izquierda="j"
    inputDos.joystick=false
    inputDos.disparar="u"
    inputDos.mina="o"
    for i=1,#ts.mapa.puntos do 
       if ts.mapa.puntos[i].val==1 then
         ts.entidades.agregarSpawn(ts.mapa.puntos[i].x,ts.mapa.puntos[i].y)
       else
        ts.entidades.agregarPowerUp(ts.mapa.puntos[i].x,ts.mapa.puntos[i].y)
       end
    end
    ts.entidades.agregarJugador(1,ts.entidades.spawns[1].x,ts.entidades.spawns[4].y,"nada",nil,0,300,20,100,"ninguno",21,23,1,inputUno)
    ts.entidades.agregarJugador(2,ts.entidades.spawns[2].x,ts.entidades.spawns[2].y,"nada",nil,0,300,20,100,"ninguno",21,23,1,inputDos)

end

function ts.dibujar()
ts.camara(1,1,nil)
end

function ts.camara(equipo,jugador,canvasss)
    local xsx=ts.entidades.jugadores[jugador].posX-ts.mdx
    --print(ts.entidades.jugadores[2].vida)
    if xsx<0 then 
        xsx=0
    elseif xsx>ancho-ts.ancho then
        xsx=ancho-ts.ancho
    end
    local ysy=ts.entidades.jugadores[jugador].posY-ts.mdy
    if ysy<0 then 
        ysy=0
    elseif ysy>alto-ts.alto then
        ysy=alto-ts.alto
    end
    ts.mapa.dibujar(xsx,ysy,ts.ancho,ts.alto,canvasss)
    ts.entidades.dibujar(xsx,ysy,canvasss,ts.ancho,ts.alto)
    
end
--Mantiene a la entidad dentro de los limites del mapa
function ts.corregirPosicion(entt)
if entt.posX>ancho-entt.medX then
    entt.posX=ancho-entt.medX
elseif entt.posX<entt.medX then
    entt.posX=entt.medX
end
if entt.posY>ancho-entt.medY then
    entt.posY=ancho-entt.medY
elseif entt.posY<entt.medY then
    entt.posY=entt.medY
end

end

function ts.inputP(dt,jugador,avanzar,retroceder,izquierda,derecha,disparar,mina)
    if love.keyboard.isDown(avanzar) then
        ts.entidades.jugadores[jugador].posY=ts.entidades.jugadores[jugador].posY-ts.entidades.jugadores[jugador].magnitud*math.sin(ts.entidades.jugadores[jugador].angulo-ssangulo)*dt
        ts.entidades.jugadores[jugador].posX=ts.entidades.jugadores[jugador].posX-ts.entidades.jugadores[jugador].magnitud*math.cos(ts.entidades.jugadores[jugador].angulo-ssangulo)*dt
    elseif love.keyboard.isDown(retroceder) then
        ts.entidades.jugadores[jugador].posY=ts.entidades.jugadores[jugador].posY+ts.entidades.jugadores[jugador].magnitud*math.sin(ts.entidades.jugadores[jugador].angulo-ssangulo)*dt
        ts.entidades.jugadores[jugador].posX=ts.entidades.jugadores[jugador].posX+ts.entidades.jugadores[jugador].magnitud*math.cos(ts.entidades.jugadores[jugador].angulo-ssangulo)*dt
    elseif love.keyboard.isDown(izquierda) then
        ts.entidades.jugadores[jugador].angulo=ts.entidades.jugadores[jugador].angulo-math.rad(100)*dt
    elseif love.keyboard.isDown(derecha) then
        ts.entidades.jugadores[jugador].angulo=ts.entidades.jugadores[jugador].angulo+math.rad(100)*dt
    end
    if love.keyboard.isDown(disparar) then
    ts.entidades.disparar(ts.entidades.jugadores[jugador])
    end
    if love.keyboard.isDown(mina) then
        ts.entidades.plantarMina(ts.entidades.jugadores[jugador])
    end
end

function ts.proupdate(dt)
ts.entidades.actualizarphy(dt)
ts.entidades.actualizarJugadores(dt)
ts.entidades.actualizarProyectiles(dt)
ts.entidades.detectarColision(dt)
end

function ts.keypressed( key,scancode,isrepeat)
    -- body
    ts.entidades.keypressed( key,scancode,isrepeat)
end

return ts