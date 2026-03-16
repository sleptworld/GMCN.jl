# GMCN

A Julia package for rendering geographic maps of China, with utilities for coordinate system conversion.

## Features

- Plot China's national border, province boundaries, and city boundaries using [GeoMakie.jl](https://github.com/MakieOrg/GeoMakie.jl)
- Coordinate conversion between WGS-84 and GCJ-02 (Mars Coordinate System)

## Installation

```julia
using Pkg
Pkg.add(url="https://github.com/tsuki/GMCN.jl")
```

## Usage

### Drawing China's Map

```julia
using GLMakie, GMCN

f = Figure()
ax = create_cn_geoaxis(f; province=true)  # province=false for national border only
display(f)
```

### Adding a Border to an Existing GeoAxis

```julia
using GeoMakie, GMCN

f = Figure()
ax = GeoAxis(f[1, 1])
add_cn_border!(ax)           # national + province borders
add_border!(ax, "北京")   # a specific district by name or code
display(f)
```

### Coordinate Conversion

```julia
using GMCN.Utils

# WGS-84 (GPS) -> GCJ-02 (used by Chinese mapping services)
gcj_lon, gcj_lat = wgs84_to_gcj02(116.4, 39.9)

# GCJ-02 -> WGS-84 (approximate inverse)
wgs_lon, wgs_lat = gcj02_to_wgs84(gcj_lon, gcj_lat)

# Check whether a point is outside China
out_of_china(0.0, 51.5)  # true (London)
```

## API Reference

| Function | Description |
|---|---|
| `create_cn_geoaxis(f; province)` | Create a `GeoAxis` with China's border pre-drawn |
| `add_cn_border!(ax; province)` | Add China's national (and optionally province) borders to an axis |
| `add_border!(ax, geom)` | Add an arbitrary geometry border to an axis |
| `Utils.wgs84_to_gcj02(lon, lat)` | Convert WGS-84 coordinates to GCJ-02 |
| `Utils.gcj02_to_wgs84(lon, lat)` | Convert GCJ-02 coordinates back to WGS-84 (approximate) |
| `Utils.out_of_china(lon, lat)` | Return `true` if the point lies outside China's bounding box |

## License

MIT
