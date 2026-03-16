module GMCN
include("Data.jl")
include("Utils.jl")

using GeoMakie
using .Data
using .Utils

import GeoFormatTypes as GFT
import GeoInterface as GI


function add_border!(ax::GeoAxis, geom)
    poly!(ax, geom;
        source=GFT.EPSG(4326),
        color=:transparent,
        strokecolor=:black,
        strokewidth=1
    )
end

add_border!(ax::GeoAxis, district::Union{AbstractString,Int64}) = add_border!(ax, Data.get_border(district))

add_cn_border!(ax::GeoAxis; province::Bool=true) =
    add_border!(ax, province ? "cn_with_province" : "cn")


function create_cn_geoaxis(f::Figure; province::Bool=true)
    ax = GeoAxis(f[1, 1]; dest="+proj=aea +lon_0=110 +lat_1=25 +lat_2=47 +lat_0=0 +datum=WGS84 +units=m +no_defs")
    add_cn_border!(ax)
    return ax
end


export add_border!, add_cn_border!, create_cn_geoaxis

end # module GMCN
