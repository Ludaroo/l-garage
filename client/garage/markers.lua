function garage_markers_drawMarker(data)
    garagedata = data.data
    markerdata = garagedata.marker  
    DrawMarker(markerdata.type, markerdata.coords.x, markerdata.coords.y, markerdata.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, markerdata.scale.x, markerdata.scale.y, markerdata.scale.z, markerdata.color.r, markerdata.color.g, markerdata.color.b, markerdata.color.a, false, true, 2, nil, nil, false)
end