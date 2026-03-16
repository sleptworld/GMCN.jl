using Test
using GMCN.Utils

@testset "GMCN" begin

    @testset "Utils.out_of_china" begin
        # Inside China
        @test !Utils.out_of_china(116.4, 39.9)   # Beijing
        @test !Utils.out_of_china(121.5, 31.2)   # Shanghai
        @test !Utils.out_of_china(113.3, 23.1)   # Guangzhou

        # Outside China
        @test Utils.out_of_china(0.0, 51.5)      # London
        @test Utils.out_of_china(139.7, 35.7)    # Tokyo (longitude out of range)
        @test Utils.out_of_china(116.4, 70.0)    # Latitude out of range (too high)
        @test Utils.out_of_china(116.4, 0.5)     # Latitude out of range (too low)
    end

    @testset "Utils.wgs84_to_gcj02 no offset outside China" begin

        lon, lat = 139.7, 35.7  # Tokyo, outside China
        mg_lon, mg_lat = Utils.wgs84_to_gcj02(lon, lat)
        @test mg_lon ≈ lon
        @test mg_lat ≈ lat
    end

    @testset "Utils.wgs84_to_gcj02 offset applied inside China" begin

        lon, lat = 116.4, 39.9  # Beijing
        mg_lon, mg_lat = Utils.wgs84_to_gcj02(lon, lat)
        # GCJ-02 vs WGS-84 offset inside China is roughly 100~500 m (0.001~0.005 degrees)
        @test abs(mg_lon - lon) > 1e-4
        @test abs(mg_lat - lat) > 1e-4
        # But the offset should not exceed 0.02 degrees
        @test abs(mg_lon - lon) < 0.02
        @test abs(mg_lat - lat) < 0.02
    end

    @testset "Utils.gcj02_to_wgs84 approximate inverse transform" begin

        original_lon, original_lat = 116.4, 39.9  # Beijing
        gcj_lon, gcj_lat = Utils.wgs84_to_gcj02(original_lon, original_lat)
        back_lon, back_lat = Utils.gcj02_to_wgs84(gcj_lon, gcj_lat)
        # Single-step approximation; error should be within 1e-5 degrees (~1 meter)
        @test abs(back_lon - original_lon) < 1e-5
        @test abs(back_lat - original_lat) < 1e-5
    end

end
