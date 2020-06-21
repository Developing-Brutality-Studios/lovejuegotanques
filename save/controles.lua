cont ={jugador={}}
local lume = require "/save/lume"
function cont.save(control,list)
    cont.jugador ={"1","2","3","a","q","e","\n",
                    "i","k","l","j","u","o"}       
    local control = lume.serialize(cont.jugador)
    success, message = love.filesystem.write("controles.txt", control)
   

    
end
function cont.cargar()
    local data
    if love.filesystem.getInfo("controles.txt") then
        local file = love.filesystem.read("controles.txt")
        data = lume.deserialize(file)
    end
    return data
end 



return cont