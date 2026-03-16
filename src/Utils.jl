module Utils
const A::Float64 = 6378245.0
const EE::Float64 = 0.00669342162296594323


out_of_china(lon::Float64, lat::Float64) = lon < 72.004 || lon > 137.8347 || lat < 0.8293 || lat > 55.8271

function transform_lat(x::Float64, y::Float64)
    ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x))

    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0
    ret += (20.0 * sin(y * pi) + 40.0 * sin((y / 3.0) * pi)) * 2.0 / 3.0
    ret += (160.0 * sin((y / 12.0) * pi) + 320.0 * sin((y * pi) / 30.0)) * 2.0 / 3.0

    return ret
end


function transform_lon(x::Float64, y::Float64)
    ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x))

    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0
    ret += (20.0 * sin(y * pi) + 40.0 * sin((y / 3.0) * pi)) * 2.0 / 3.0
    ret += (150.0 * sin((x / 12.0) * pi) + 300.0 * sin((x * pi) / 30.0)) * 2.0 / 3.0

    return ret
end

function wgs84_to_gcj02(lon::Float64, lat::Float64)

    if out_of_china(lon, lat)
        return (lon, lat)
    end

    dlat = transform_lat(lon - 105.0, lat - 35.0)
    dlon = transform_lon(lon - 105.0, lat - 35.0)

    rad_lat = lat / 180.0 * pi
    magic = 1.0 - EE * sin(rad_lat) * sin(rad_lat)
    sqrt_magic = sqrt(magic)

    mg_lat = lat + (dlat * 180.0) / ((A * (1.0 - EE)) / (magic * sqrt_magic) * pi)
    mg_lon = lon + (dlon * 180.0) / (A / sqrt_magic * cos(rad_lat) * pi)

    return (mg_lon, mg_lat)

end

function gcj02_to_wgs84(lon::Float64, lat::Float64)

    if out_of_china(lon, lat)
        return (lon, lat)
    end

    (mg_lon, mg_lat) = wgs84_to_gcj02(lon, lat)
    return (lon * 2.0 - mg_lon, lat * 2.0 - mg_lat)
end

export out_of_china, wgs84_to_gcj02, gcj02_to_wgs84

end
