
local sonido={
        bala1 ="/sonidos/bala1.mp3",
        bala2="/sonidos/bala2.mp3",
        bala3="/sonidos/bala3.mp3",
        mina="/sonidos/mina.wav",
        impacto="/sonidos/impact.mp3",
        dead="/sonidos/dead1.mp3",
        dead2="/sonidos/dead2.mp3"
        }

function sonido.play(s)
    local source = love.audio.newSource( s, "static" )
    love.audio.play(source)
end 
return sonido