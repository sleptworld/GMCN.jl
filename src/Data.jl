module Data
using GeoJSON, DataFrames
using JSON
import GeoInterface as GI
using Pkg.Artifacts


function dataset_root()
    return artifact"border"
end


struct DataPackage
    data_path::String

    function DataPackage()
        data_path = normpath(dataset_root())
        new(data_path)
    end
end

package = DataPackage()

function get_geojson(type::Symbol=:district)
    if type == :district
        return DataFrame(GeoJSON.read(read(joinpath(package.data_path, "border.geojson"))))
    elseif type == :city
        return DataFrame(GeoJSON.read(read(joinpath(package.data_path, "border_city.geojson"))))
    elseif type == :province
        return DataFrame(GeoJSON.read(read(joinpath(package.data_path, "border_province.geojson"))))
    elseif type == :cn
        return DataFrame(GeoJSON.read(read(joinpath(package.data_path, "border_cn.geojson"))))
    end
end

function get_border(s::T) where T<:AbstractString
    if occursin("省", s)
        gj = get_geojson(:province)
        return gj[gj.province_name.==s, 1].geometry
    elseif occursin("市", s)
        gj = get_geojson(:city)
        return gj[gj.city_name.==s, 1].geometry

    elseif s == "中华人民共和国" || s == "cn" || s == "CN"
        gj = get_geojson(:cn)[1, :]
        return gj.geometry

    elseif s == "cn_with_province"
        gj = get_geojson(:province)[:, "geometry"]
        return gj
    else
        gj = get_geojson(:district)
        return gj[gj.district_name.==s, 1].geometry
    end
end


function get_border(adcode::Int64)
    gj = get_geojson(:district)
    gj[gj.district_adcode.==adcode, 1]
end

end