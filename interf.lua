interf={tiempo = 0,video,elementos={},even=3,ini={jugadores =1,modo=2,numMuertes=20,capturas=3,rondas=1,time=120}} 
local font = love.graphics.newFont( "arial_/arial_narrow_7.ttf",40)
local color ={244/255,208/255,63/255}   
local lista ={"a","b","c","d","q","e","\n","i","k","l","j","u","o"} 
local segX
local segY
local dibujar={x,y,w,h}
local play = false
local pint = false

function size()
    w,h= love.window.getDesktopDimensions(1)
    segX = w/40
    segY = h/40
end 
function interf.video()    
    size()
    interf.video = love.graphics.newVideo("/assets/vid1.ogv")
    
end 
function interf.timer(dt)
    interf.tiempo = interf.tiempo +dt
    
   if interf.tiempo >= 15 then
        
        interf.video:play()
        play =true       
              
    else
        interf.video:pause()
        interf.video:rewind()
        play =false
    end 
    
end 

function caja_estado(ele,ref) 
            
    local t = love.graphics.newText( font, ele.txt)
    local r = love.graphics.newText( font, ref)
    local w, h = t:getDimensions()
    local w2, h2 = r:getDimensions()

    local p = love.graphics.newText( font, ref) 
            if w2 > segX then
                love.graphics.rectangle("line",ele.x+w+segX-segX/8,ele.y,w2*1.1,h2)
                love.graphics.draw(p,ele.x+w+segX,ele.y)
            else 
            love.graphics.rectangle("line",ele.x+w+segX,ele.y,segX*1.1,h2)
            love.graphics.draw(p,ele.x+w+segX+segX/4,ele.y)            
            end 
            
end 
function dibujarText(ele)   
        --local font = love.graphics.getFont()              
        local t = love.graphics.newText( font, ele.txt)     
        local w, h = t:getDimensions()
        if ele.tipo ~= "imagen"   then
         love.graphics.draw(t,ele.x,ele.y,0,1,1)  
        end        
        if ele.tipo == "caja_estado" then
            caja_estado(ele,ele.transp)             
        end       
        if ele.tipo == "rectangulo" then 
            love.graphics.rectangle("line",ele.x-4,ele.y-4,w*1.050,h*1.1)                         
        end
        if ele.tipo == "cajaEstadoControl" then 
            caja_estado(ele,lista[ele.seg]) 
        end 
        if ele.tipo == "imagen"   then 
           local image = love.graphics.newImage( ele.seg )
           local width = image:getWidth()
           local height = image:getHeight()
           love.graphics.setColor(255,255,255,ele.im)    
           love.graphics.draw(image, ele.x + width/2 , ele.y + height/2,ele.txt,ele.escalax,ele.escalay,width/2,height/2) 
           love.graphics.setColor(255,255,255)         
        end
        if play then
            love.graphics.setColor(255,255,255,0.1)  
            love.graphics.draw(interf.video,0,0,0,1.2,1.2 )  
            love.graphics.setColor(255,255,255)           
        end
        if pint == true then 
            love.graphics.rectangle("fill",dibujar.x,dibujar.y,dibujar.w,dibujar.h)                         
        end       
        
end 

function lable(tipo,x,y,val,seg,id,ty)   
        interf.addUIElement(x,y,tipo,val,1,1,1,1,0.23,id,1,1,1,seg)  
end 

function boton_flecaha(tipo,x,y,val,seg,id,ty,variable)
    local t = love.graphics.newText( font, val)     
    local w, h = t:getDimensions()
    interf.addUIElement(x,y,tipo,val,1,1,1,1,variable,0,1,1,1,1)
    interf.addUIElement(x+w+segX*3,y,"rectangulo"," + ",1,1,1,ty,0.23,"botonAumento",1,1,1,1)
    interf.addUIElement(x+w+segX*5,y,"rectangulo"," - ",1,1,1,ty,0.23,"botonDisminuir",1,1,1,1)
    --interf.addUIElement(x,y,tipo,frase,escalax,escalay,tx,ty,transp,id,tColorT,tColorF,im,seg)
end 

function controles(tipo,x,y,val,seg)
    local t = love.graphics.newText( font, val)     
    local w, h = t:getDimensions()
        interf.addUIElement(x,y,tipo,"Adelante",1,1,1,1,0.23,0,1,1,1,seg)
        interf.addUIElement(x,y+segY*2,tipo,"Atras",1,1,1,1,0.23,0,1,1,1,seg+1)
        interf.addUIElement(x,y+segY*4,tipo,"Derecha",1,1,1,1,0.23,0,1,1,1,seg+2)
        interf.addUIElement(x,y+segY*6,tipo,"Izquierda",1,1,1,1,0.23,0,1,1,1,seg+3)
        interf.addUIElement(x,y+segY*8,tipo,"Disparar",1,1,1,1,0.23,0,1,1,1,seg+4)
        interf.addUIElement(x,y+segY*10,tipo,"Mina",1,1,1,1,0.23,0,1,1,1,seg+5)

        interf.addUIElement(x+w+80,y,"rectangulo","<>",1,1,1,1,0.23,"controles",1,1,1,seg)
        interf.addUIElement(x+w+80,y+segY*2,"rectangulo","<>",1,1,1,1,0.23,"controles",1,1,1,seg+1)
        interf.addUIElement(x+w+80,y+segY*4,"rectangulo","<>",1,1,1,1,0.23,"controles",1,1,1,seg+2)
        interf.addUIElement(x+w+80,y+segY*6,"rectangulo","<>",1,1,1,1,0.23,"controles",1,1,1,seg+3)
        interf.addUIElement(x+w+80,y+segY*8,"rectangulo","<>",1,1,1,1,0.23,"controles",1,1,1,seg+4)
        interf.addUIElement(x+w+80,y+segY*10,"rectangulo","<>",1,1,1,1,0.23,"controles",1,1,1,seg+5)
        --interf.addUIElement(x,y,tipo,frase,escalax,escalay,tx,ty,transp,id,tColorT,tColorF,im,seg)
end 
function condicion(ref,paso,sig,condicion)
    if sig == "mas" then 
        if  ref < condicion then 
            ref = ref + paso
        end 
        return ref
    end 
    if  sig == "menos" then 
        if  ref > condicion then 
            ref = ref - paso
        end 
        return ref
    end 
end 
function imagen(x,y,r,sx,sy,ox,oy,trans,direc)
    --interf.addUIElement(x,y,tipo,frase,escalax,escalay,tx,ty,transp,id,tColorT,tColorT,im,seg) 
        love.graphics.setColor(255,255,255,0.7)    
        interf.addUIElement(x,y,"imagen",math.rad(r),sx,sy,ox,oy,1,1,kx,1,trans,direc)  
        love.graphics.setColor(255,255,255)
end 
 
function event(x,y,ele)
             
            t = love.graphics.newText( font, ele.txt)
            w, h = t:getDimensions()  
            interf.tiempo = 0 
            if x > ele.x-4 and x < ele.x+w*1.2 and y > ele.y and y < ele.y+h*1.1 then
                dibujar.x = ele.x-4
                dibujar.y = ele.y-2
                dibujar.w = w
                dibujar.h = h
                color ={244/255,208/255,63/255}                
                             
                if ele.id == 2 then
                    interf.even = ele.seg 
                end              
                if ele.id == 7 then
                    interf.ini.modo = ele.seg
                end
                if ele.id == 14 then 
                    love.event.quit(0) 
                end
               
                -----Opciones modo                
                if ele.id == "botonAumento" then
                    if ele.ty == 1 then                                       
                        interf.ini.jugadores = condicion(interf.ini.jugadores,1,"mas",4)
                    end
                    if ele.ty == 2 then                                               
                        interf.ini.numMuertes = condicion(interf.ini.numMuertes,5,"mas",100) 
                    end 
                    if ele.ty == 5 then                            
                        interf.ini.capturas = condicion(interf.ini.capturas,1,"mas",6)
                    end                         
                    if ele.ty == 5 then                            
                        interf.ini.time = condicion(interf.ini.time,25,"mas",600)
                    end 
                    if ele.ty == 4 then                            
                        interf.ini.rondas = condicion(interf.ini.rondas,1,"mas",3)
                    end 
                   
                      
                end 
                if ele.id == "botonDisminuir" then 
                    if  ele.ty == 1 then                    
                        interf.ini.jugadores = condicion(interf.ini.jugadores,1,"menos",1)
                    end
                    if ele.ty == 2 then                       
                        interf.ini.numMuertes = condicion(interf.ini.numMuertes,5,"menos",20) 
                    end                   
                    if ele.ty == 5 then
                        interf.ini.capturas = condicion(interf.ini.capturas,1,"menos",1)
                    end                                                                                       
                    if ele.ty == 5 then                           
                        interf.ini.time = condicion(interf.ini.time,25,"menos",120)                          
                    end 
                    if ele.ty == 4 then                            
                        interf.ini.rondas = condicion(interf.ini.rondas,1,"menos",1)
                    end       
                       
                end
                if ele.id == 10 then
                    interf.even = 4
                end 
                if ele.id == "controles" then 
                    lista[ele.seg] = '?'                    
                    function love.keyreleased(key)                        
                            local letra = true 
                            for k,v in pairs(lista) do
                                if lista[k] == key then 
                                    letra = false
                                end 
                            end 
                            if letra then
                                lista[ele.seg] = key   
                            end 
                    end
                    
                end 
                ----------
            end 
               
end   

function interf.addUIElement(x,y,tipo,frase,escalax,escalay,tx,ty,transp,id,tColor,tColorT,im,seg)    
    local ele={} 
    ele.id=id    
    ele.x=x
    ele.y=y
    ele.tipo=tipo
    ele.txt=frase
    ele.escalax=escalax
    ele.escalay=escalay
    ele.tcolor=tcolor    
    ele.tColorT=tColorT
    ele.tx=tx
    ele.ty=ty
    ele.transp=transp
    ele.im=im
    ele.seg=seg    
    table.insert(interf.elementos,ele)  
end
function validar()
    interf.elementos = nil
    interf.elementos = {}    
    if interf.even == 1 then        
        pagina1()
        
    end
    if interf.even == 2 then
        pagina2()
        
    end
    if interf.even == 3 then
        pagina3()
        
    end
    if interf.even == 5 then
        pagina4()
    end

end

function interf.dibijarElementos()        
    validar()
     for i=1,#interf.elementos,1 do       
            dibujarText(interf.elementos[i])                     
    end     
end

function interf.mousehandler(x, y, button)
       if button == 1 then
          for i =1,#interf.elementos,1 do
                event(x,y,interf.elementos[i]) 
          end
       end        
end 

function pagina1()             
        lable(1,segX*19,segY*15,"Jugar",2,2)
        lable(1,segX*18,segY*18,"Configuracion",5,2)
        lable(1,segX*19,segY*21,"Salir",1,14)
        imagen(segX*30,segY*2,0,1,1,1,1,0.7,"/assets/img1.jpg")
       -- imagen(x,y,r,sx,sy,ox,oy,kx,ky,direc)
        love.graphics.setBackgroundColor(46/255,64/255,83/255)        
end 
function pagina4()
        lable(1,segX*14,segY*5,"Jugador 1",2,0)
        lable(1,segX*22,segY*5,"Jugador 2",2,0)
        controles("cajaEstadoControl",segX*12,segY*10,"controles1",1)
        controles("cajaEstadoControl",segX*20,segY*10,"controles2",8)
        lable(8,segX*14,segY*25,"Salir pantalla inicio",1,2,1,1)  


end 
function pagina3()       
    lable("rectangulo",segX*18,segY*15,"Seguir jugando",2,10)
    lable("rectangulo",segX*18,segY*18,"Configuracion",5,2)
    lable("rectangulo",segX*17,segY*21,"Salir pantalla inicio",1,2)        
end 
function pagina2()       
   -- lable(tipo,x,y,val,seg,id,ty,tp)
        lable(1,segX*8,segY*10,"Modo de juego: ",1,0)     
        lable("rectangulo",segX*8,segY*13,"Team Slayer",1,7)     
        lable("rectangulo",segX*8,segY*16,"Capture The Flag",2,7)     
        lable("rectangulo",segX*8,segY*19,"King Of The Hill",3,7)     
        lable("rectangulo",segX*8,segY*22,"Crazy Ball",4,7)     

            boton_flecaha("caja_estado",segX*22,segY*11,"Jugadores: ",2,1,1,interf.ini.jugadores)

            interf.addUIElement(segX*22,segY*14,"caja_estado","Modo de juego:",1,1,1,1,interf.ini.modo,0,1,1,1,1)

        if interf.ini.modo ==1 then
            boton_flecaha("caja_estado",segX*22,segY*17,"Numero de muertes:",1,1,2,interf.ini.numMuertes)
        end  
        if interf.ini.modo ==2 then
            boton_flecaha("caja_estado",segX*22,segY*17,"Rondas: ",2,1,4,interf.ini.rondas)
            boton_flecaha("caja_estado",segX*22,segY*20,"Capturas: ",2,1,5,interf.ini.capturas)
        end 
        if interf.ini.modo ==3 then 
            boton_flecaha("caja_estado",segX*22,segY*17,"tiempo: ",2,1,5,interf.ini.time)
            boton_flecaha("caja_estado",segX*22,segY*20,"Rondas: ",2,1,4,interf.ini.rondas)
        end 
        if interf.ini.modo ==4 then
            boton_flecaha("caja_estado",segX*22,segY*17,"tiempo: ",2,1,5,interf.ini.time)
            boton_flecaha("caja_estado",segX*22,segY*20,"Rondas: ",2,1,4,interf.ini.rondas)
        end 

        lable(1,segX*19,segY*27,"Jugar",4,2,3)
        
        lable(1,segX*16,segY*30,"Salir pantalla inicio",1,2)       

        
end 
 

 


return interf