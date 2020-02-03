using Unitful, UnitfulMoles, Test

@mol Baz
@mol Foo 55.5
@mol Bar 99.9

@testset "Printing" begin
    @test string(3molBaz) == "3 mol(Baz)"
    @test string(3.0mmolBaz) == "3.0 mmol(Baz)"
end

@testset "units convert to grams" begin
    @test uconvert(u"g", 2molFoo) == 111.0u"g"
end

@testset "Can add or subtract mol units" begin
    @test 3molFoo + 2molFoo == 5molFoo
    @test 3molFoo - 2molFoo == 1molFoo
    @test 2molFoo + 3molBar ==  0.4107u"kg"
    @test 2molFoo - 3molBar == -0.18870000000000003u"kg"
end

@testset "Can multiply or divide mol units" begin
    @test molFoo * 2molFoo == 2molFoo^2
    @test 1molFoo / 2molFoo == 1/2
    molFoo/molBar * 2molBar == 2molFoo
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
    @test UnitfulMoles.sum_base(base, elements) == 3
end

@testset "Parse compound" begin
    @test UnitfulMoles.parse_compound("CO2") == ["C" => 1, "O" => 2]
    @test UnitfulMoles.parse_compound("NaCl") == ["Na" => 1, "Cl" => 1]
    @test UnitfulMoles.parse_compound("C8H10N4O2") == ["C" => 8, "H" => 10, "N" => 4, "O" => 2]
end

@testset "xmols are the correct fraction of their compound" begin
    @xmol Bar FooBar2
    1molFooBar2 == 2BarmolFooBar2
end

