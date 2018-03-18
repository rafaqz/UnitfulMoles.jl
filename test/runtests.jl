using Unitful
using UnitfulMoles
using Base.Test

@mol Foo 55.5
@mol Bar 99.9

@testset "units convert to grams" begin
    @test uconvert(u"g", 2molFoo) == 111.0u"g"
end

@testset "Can't add or subtract dfferent mol units" begin
    @test 3molFoo + 2molFoo == 5molFoo
    @test 3molFoo - 2molFoo == 1molFoo
    @test_throws ErrorException 2molFoo + 3molBar
    @test_throws ErrorException 2molFoo - 3molBar
end

@testset "Can multiply or divide mol units" begin
    @test molFoo * 2molFoo == 2molFoo^2
    @test 1molFoo / 2molFoo == 1/2
    @test_nowarn molFoo * 2molBar
    @test_nowarn molFoo / 2molBar
end
