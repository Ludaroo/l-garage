WaitForGarageData()


function onEnter(self)
end

function onExit(self)
end

function nearby(self)
    print("ah")
end

for k,v in pairs(Garage) do 
    point = lib.points.new({
        data = v,
        coords = v.coords,
        distance = v.distance,
    })

end