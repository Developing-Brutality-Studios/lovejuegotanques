
--terreno, jugador
--require("./modosdejuego/TEAMSLAYER")
local juego={mododejuego=nil}

function juego.new(mdj)
    -- body
    if mdj==1 then
        juego.mododejuego=require("./modosdejuego/TEAMSLAYER")
    elseif mdj==3 then
        juego.mododejuego=require("./modosdejuego/reyDeLaColina")
    elseif mdj==4 then
        juego.mododejuego=require("./modosdejuego/bolaL")
    end
    juego.mododejuego.new()
end



function juego:dibujarCapas()
juego.mododejuego.dibujar()
end
return juego

