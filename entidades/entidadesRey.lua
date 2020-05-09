local entidadesRey={rcolina=250,colina={},jugadores={},proyectiles={},powerUps={},spawns={},ancho=950,alto=950,puntuaciones={}}
local tanques ={"//assets/tanques/tank_dark.png","//assets/tanques/tank_red.png","//assets/tanques/tank_green.png"}
local proyectiles={"//assets/proyectiles/bulletDark1_outline.png","//assets/proyectiles/bulletRed1_outline.png","//assets/proyectiles/bulletGreen1_outline.png"}
local mina=love.graphics.newImage("//assets/mina.png")
local ssangulo=math.rad(90)
local cbs=60
local mcbs=cbs/2
local calavera=love.graphics.newImage("//assets/skull.png")
local particulas=love.graphics.newImage("//assets/explosion3.png")
local caja=love.graphics.newImage("//assets/crateMetal.png")
function entidadesRey.agregarEquipo()
local equipo={}
table.insert(entidadesRey.equipos, equipo)
end
function entidadesRey.agregarColina(px,py)
    local colina={}
    colina.posX=px
    colina.posY=py
    table.insert( entidadesRey.colina,colina )
end 
function entidadesRey.agregarSpawn(spx,spy)
    local spawn={}
    spawn.x=spx
    spawn.y=spy
    table.insert( entidadesRey.spawns,spawn )
end
--tipo:1=tanque de energia plus,2=Sobreescudo,3=modificador de minas,4=velocidad plus

function entidadesRey.agregarPowerUp(pwx,pwy)
    local tipo=math.random(1,4)
    local pw={}
    pw.posX=pwx
    pw.posY=pwy
    pw.vida=70
    pw.tipo=tipo
    table.insert( entidadesRey.powerUps,pw)
end

--equipo,--entidad=posX,posY,strimagen,imagen,angulo,magnitud,danho,vida,powerUp,medX,medY,tamanho,anco,larg
function entidadesRey.agregarJugador(nEqu,posX,posY,strimagen,imagen,angulo,magnitud,danho,vida,powerUp,medX,medY,tamanho,anco,larg)
    local  ju={}
    if entidadesRey.puntuaciones[nEqu]==nil then
        local ro={}
        ro.puntos=0
        table.insert( entidadesRey.puntuaciones,ro)
    end
    ju.equipo=nEqu
    ju.posX=posX
    ju.posY=posY
    ju.strimagen=tanques[nEqu]
    ju.imagen=love.graphics.newImage(ju.strimagen)
    ju.angulo=angulo
    ju.magnitud=magnitud
    ju.danho=danho
    ju.vida=vida
    ju.powerup=powerUp
    ju.medX=medX
    ju.medY=medY
    ju.tamanho=tamanho
    ju.energia=100
    ju.limite=100
    ju.ratio=15
    ju.eqimpac=0
    ju.spawnear=true
    ju.danhomina=50
    ju.danhoproyectil=20
    table.insert( entidadesRey.jugadores,ju)
    print("jugadorAgregado")
end


function entidadesRey.agregarProyectil(nEqu,posX,posY,strimagen,imagen,angulo,magnitud,danho,vida,powerUp,medX,medY,tamanho,tipo)
    local  ju={}
    ju.equipo=nEqu
    ju.posX=posX
    ju.posY=posY
    ju.strimagen=proyectiles[nEqu]
    ju.imagen=love.graphics.newImage(ju.strimagen)
    ju.angulo=angulo
    ju.magnitud=magnitud
    ju.danho=danho
    ju.vida=vida
    ju.powerup=powerUp
    ju.medX=medX
    ju.medY=medY
    ju.tamanho=tamanho
    ju.tipo=tipo
    if tipo==2 then
    ju.imagen=mina
    end
    table.insert( entidadesRey.proyectiles,ju)
end

function entidadesRey.disparar(rrr)
    --crea un proyectil con el angulo y direccion
    local px=rrr.posX-24*math.cos(rrr.angulo-ssangulo)
    local py=rrr.posY-24*math.sin(rrr.angulo-ssangulo)
    --nEqu,posX,posY,strimagen,imagen,angulo,magnitud,danho,vida,powerUp,medX,medY,tamanho
    if rrr.energia>rrr.danhoproyectil then
        entidadesRey.agregarProyectil(rrr.equipo,px,py,1,nil,rrr.angulo,300,rrr.danhoproyectil,10,"ninguno",4,7,1,1)
        rrr.energia=rrr.energia-rrr.danhoproyectil
    end
end

function entidadesRey.plantarMina(rrr)
    if rrr.energia>rrr.danhomina then
        entidadesRey.agregarProyectil(rrr.equipo,rrr.posX,rrr.posY,1,nil,0,0,rrr.danhomina,10,"ninguno",12,12,1,2)
        rrr.energia=rrr.energia-rrr.danhomina
    end
end

function entidadesRey.eliminarProyectiles(limitex,limitey)
    if #entidadesRey.proyectiles>0 then
        for i=1,#entidadesRey.proyectiles do
            if entidadesRey.proyectiles[i]~=nil then
                local prro=entidadesRey.proyectiles[i].posX>limitex or #entidadesRey.proyectiles[i].posX<0
                local qrro=entidadesRey.proyectiles[i].posY>limitey or #entidadesRey.proyectiles[i].posY<0
                local errd=prro or qrro
                if errd or entidadesRey.proyectiles[i].vida<1 then
                    table.remove( entidadesRey.proyectiles,i)
                end
            end
        end
    end
end

function entidadesRey.actualizarProyectiles(dt)
    if #entidadesRey.proyectiles>0 then
        for i=1,#entidadesRey.proyectiles do
            if  entidadesRey.proyectiles[i]~=nil then
            if  entidadesRey.proyectiles[i].vida<1 then
            table.remove( entidadesRey.proyectiles, i)
            end
            end
        end

        for i=1,#entidadesRey.proyectiles do 
            if entidadesRey.proyectiles[i].tipo ==1 then
            entidadesRey.proyectiles[i].posY=entidadesRey.proyectiles[i].posY-entidadesRey.proyectiles[i].magnitud*math.sin(entidadesRey.proyectiles[i].angulo-ssangulo)*dt
            entidadesRey.proyectiles[i].posX=entidadesRey.proyectiles[i].posX-entidadesRey.proyectiles[i].magnitud*math.cos(entidadesRey.proyectiles[i].angulo-ssangulo)*dt
            else
                entidadesRey.proyectiles[i].vida=entidadesRey.proyectiles[i].vida-1*dt
            end    
        end
    end
    for i=1,#entidadesRey.powerUps do
        if entidadesRey.powerUps[i].vida<61 and entidadesRey.powerUps[i].vida>1 then
            entidadesRey.powerUps[i].vida=entidadesRey.powerUps[i].vida-1*dt
        elseif entidadesRey.powerUps[i].vida<1 then
            entidadesRey.powerUps[i].vida=70
        end
    end
end

function entidadesRey.actualizarJugadores(dt)
    entidadesRey.matarJugadores()
    for i=1,#entidadesRey.jugadores do
        entidadesRey.jugadores[i].energia=entidadesRey.jugadores[i].energia+entidadesRey.jugadores[i].ratio*dt
        if entidadesRey.jugadores[i].energia>entidadesRey.jugadores[i].limite then
            entidadesRey.jugadores[i].energia=entidadesRey.jugadores[i].limite
        end
    end
end


function entidadesRey.estaDentro(exx,eyy,entt)

    local retorno=false
    local erer=entt.posX>exx and entt.posX<exx+entidadesRey.ancho
    local rr=entt.posY>eyy and entt.posY<eyy+entidadesRey.ancho

    if rr and erer then
    retorno=true
    end

    return retorno
end
function entidadesRey.es(entt)
    local retorno=false
    local difx=entidadesRey.colina[1].posX-entt.posX
    local dify=entidadesRey.colina[1].posY-entt.posY
    if difx < 0 then
        difx = difx*-1
        end
    if dify < 0 then
         dify = dify*-1
    end
    local dist = math.sqrt( difx^2+dify^2)
    if dist < entidadesRey.rcolina then
        return true
    else 
        return false
    end    
end

function entidadesRey.espColina(dt)
    local retorno=false
    local dentroArea={}
    local eqpo=0
    for i=1, #entidadesRey.jugadores do
        if entidadesRey.es(entidadesRey.jugadores[i]) then
           table.insert( dentroArea, entidadesRey.jugadores[i]) 
        end
    end
    if #dentroArea ~= 0 then
        for i=1, #dentroArea do              
            if eqpo == 0 then
                eqpo = entidadesRey.jugadores[i].equipo
            end
            if eqpo ~=entidadesRey.jugadores[i].equipo then                
                return 0
            end 
        end
        entidadesRey.puntuaciones[dentroArea[1].equipo].puntos= entidadesRey.puntuaciones[dentroArea[1].equipo].puntos+1*dt  
    end
    

    return retorno
end


function entidadesRey.detectarColision(dt)
    --jugadores v proyectiles
    for i=1,#entidadesRey.jugadores do
        for j=1,#entidadesRey.proyectiles do
            if entidadesRey.proyectiles[j].equipo~=entidadesRey.jugadores[i].equipo then
                local corX=entidadesRey.jugadores[i].posX-mcbs
                local corY=entidadesRey.jugadores[i].posY-mcbs
                local sx=corX<entidadesRey.proyectiles[j].posX and corX+cbs>entidadesRey.proyectiles[j].posX
                local sy=corY<entidadesRey.proyectiles[j].posY and corY+cbs>entidadesRey.proyectiles[j].posY
                if sx and sy then
                    entidadesRey.jugadores[i].vida=entidadesRey.jugadores[i].vida-entidadesRey.proyectiles[j].danho
                    entidadesRey.jugadores[i].eqimpac=entidadesRey.proyectiles[j].equipo
                    --print(entidadesRey.jugadores[i].eqimpac)
                    print(entidadesRey.jugadores[i].vida)
                    entidadesRey.proyectiles[j].vida=entidadesRey.proyectiles[j].vida-entidadesRey.jugadores[i].danho
                    print(entidadesRey.jugadores[i].vida)
                end
            end
        end
    end
    --jugadores v powerUPs
    for i=1,#entidadesRey.jugadores do
        for j=1,#entidadesRey.powerUps do
            local corX=entidadesRey.jugadores[i].posX-mcbs
            local corY=entidadesRey.jugadores[i].posY-mcbs
            local sx=corX<entidadesRey.powerUps[j].posX and corX+cbs>entidadesRey.powerUps[j].posX
            local sy=corY<entidadesRey.powerUps[j].posY and corY+cbs>entidadesRey.powerUps[j].posY
            if sx and sy and entidadesRey.powerUps[j].vida>60 then
                entidadesRey.procesarColPow(entidadesRey.powerUps[j],entidadesRey.jugadores[i])
                entidadesRey.powerUps[j].vida=60
            end
        end
    end
    ---Calcular si esta dentro del circulo 
    entidadesRey.espColina(dt)

end

function entidadesRey.matarJugadores()
    for i=1,#entidadesRey.jugadores do
        if entidadesRey.jugadores[i].vida<1 then
            if entidadesRey.jugadores[i].spawnear then
            entidadesRey.spawnearJugadores(entidadesRey.jugadores[i])
            else
            entidadesRey.jugadores[i].imagen=calavera
            entidadesRey.jugadores[i].magnitud=0   
            end            
        end
    end
end

function entidadesRey.procesarColPow(pU,ply)
    if pU.tipo == 1 then
        ply.energia=300
        ply.limite=300
        ply.ratio=80
    elseif pU.tipo == 2 then
        ply.vida=200
    elseif pU.tipo == 3 then
        ply.danhomina=200
    elseif pU.tipo == 4 then
        ply.magnitud=500
    end
end

function entidadesRey.desactivarPu(tipo,ply)
    if tipo == 1 then
        if ply.energia>100 then
            ply.energia=100
        end
        ply.limite=100
        ply.ratio=50
    elseif tipo == 2 then
        if ply.vida>100 then
            ply.vida=100
        end
    elseif tipo == 3 then
        ply.danhomina=50
    elseif tipo == 4 then
        ply.magnitud=300
    end
end

function entidadesRey.spawnearJugadores(ent)
    ent.posX=entidadesRey.spawns[ent.equipo].x
    ent.posY=entidadesRey.spawns[ent.equipo].y
    ent.energia=100
    ent.limite=100
    ent.vida=100
    ent.ratio=50
end



function entidadesRey.dibujar(eex,eey,canv)
    --dibuja a los proyectiles
    if canv~=nil then
        love.graphics.setCanvas(canv)
    end
    for i=1,#entidadesRey.proyectiles do
        if entidadesRey.estaDentro(eex,eey,entidadesRey.proyectiles[i]) then
            local fx=entidadesRey.proyectiles[i].posX-eex
            local fy=entidadesRey.proyectiles[i].posY-eey
            love.graphics.draw(entidadesRey.proyectiles[i].imagen,fx,fy,entidadesRey.proyectiles[i].angulo,entidadesRey.proyectiles[i].tamanho,entidadesRey.proyectiles[i].tamanho,entidadesRey.proyectiles[i].medX,entidadesRey.proyectiles[i].medY,0,0)
            --dibuja la caja de colision
        end
    
    end
    
    --dibuja los power Ups
    for i=1,#entidadesRey.powerUps do
        if entidadesRey.estaDentro(eex,eey,entidadesRey.powerUps[i]) then
            local fx=entidadesRey.powerUps[i].posX-eex
            local fy=entidadesRey.powerUps[i].posY-eey
            if entidadesRey.powerUps[i].vida>61 then
                love.graphics.draw(caja,fx,fy,0,1,1,14,14,0,0)
            else
                --love.graphics.setColor(1,1,0)
                --math.rad(entidadesRey.powerUps[i].vida*60)
                love.graphics.arc("fill",fx,fy,30,0,math.rad(entidadesRey.powerUps[i].vida*6))
            end
        end
    end
    if entidadesRey.estaDentro(eex,eey,entidadesRey.colina[1]) then
        local fx=entidadesRey.colina[1].posX-eex
        local fy=entidadesRey.colina[1].posY-eey
        love.graphics.circle("fill",fx,fy,entidadesRey.rcolina)
    end
    --dibuja a los jugadores
    for i=1,#entidadesRey.jugadores do
            if entidadesRey.estaDentro(eex,eey,entidadesRey.jugadores[i]) then
                local fx=entidadesRey.jugadores[i].posX-eex
                local fy=entidadesRey.jugadores[i].posY-eey
                love.graphics.draw(entidadesRey.jugadores[i].imagen,fx,fy,entidadesRey.jugadores[i].angulo,entidadesRey.jugadores[i].tamanho,entidadesRey.jugadores[i].tamanho,entidadesRey.jugadores[i].medX,entidadesRey.jugadores[i].medY,0,0)
                --dibuja la caja de colision
            end
    end
    
    love.graphics.print(tostring(entidadesRey.puntuaciones[1].puntos),50,500)
    love.graphics.print(tostring(entidadesRey.puntuaciones[2].puntos),50,550)
    love.graphics.setCanvas()
end  

return entidadesRey