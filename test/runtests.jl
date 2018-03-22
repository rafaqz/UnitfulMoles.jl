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

@testset "Compound weight is the sum of its components" begin
    @compound FooBar2
    @test uconvert(u"g", 1molFooBar2) == 255.3u"g"
    @compound Foo4Bar
    @test uconvert(u"g", 1molFoo4Bar) == 321.9u"g"
end

@testset "Sum base" begin
    elements = ["C" => 1, "A" => 1, "B" => 2, "C" => 2]
    base = "C"
    @test sum_base(base, elements) == 3
end

@testset "Parse compound" begin
    @test parse_compound("CO2") == ["C" => 1, "O" => 2]
    @test parse_compound("NaCl") == ["Na" => 1, "Cl" => 1]
    @test parse_compound("C8H10N4O2") == ["C" => 8, "H" => 10, "N" => 4, "O" => 2]
end

