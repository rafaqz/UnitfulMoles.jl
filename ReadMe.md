# UnitfulMoles

[![Build Status](https://travis-ci.org/rafaqz/UnitfulMoles.jl.svg?branch=master)](https://travis-ci.org/rafaqz/UnitfulMoles.jl)
[![codecov.io](http://codecov.io/github/cesaraustralia/Dispersal.jl/coverage.svg?branch=master)](http://codecov.io/github/rafaqz/UnitfulMoles.jl?branch=master)

This package provides a standardised method for defining mol units for the Julia
language, using Unitful.jl.

## Moles

The main command is the `@mol` macro:

```julia
julia> using UnitfulMoles, Unitful

julia> @mol A
molA
```

This allows for stoichiometric ratios to be expressed more naturally:

```julia
julia> @mol B
molB

julia> 0.5molA/molB
0.5 molA molB^-1
```

You can also assign a molar weight to the unit
to allow conversion between mol and g:

```julia
julia> @mol N 14.0067
molN

julia> uconvert(u"g", 5molN)
70.0335 g
```

A set of predefined mol units is maintained separately in
[UnitfulConventionalMoles.jl](https://github.com/rafaqz/UnitfulConventionalMoles.jl).

## Compounds

The `@compound` macro lets you combine basic elements into compound molecules:

```julia
julia> @mol O 15.999
molO

julia> @compound NO3
molNO3
```

And weight conversions work for free!

```julia
julia> uconvert(u"g", 10molNO3)
620.037 g
```

You can also use these macros in assignments:

```julia
julia> @mol C 12.011
molC

julia> x = (100@compound CO2) / 25u"L"
4.0 L^-1 molCO2

julia> uconvert(u"g/L", x)
176.036 g L^-1
```

## C-mol and others

The `@xmol` macro creates fractional moles scaled to one mole of an element in a
compound. The best example is the C-mole, which measure the amount of a compound
relative to one mole of C:

```julia
julia> @mol H 1.008
molH

julia> @xmol C C8H10N4O2
C-molC8H10N4O2

julia> uconvert(molC8H10N4O2, 1CmolC8H10N4O2)
0.125 molC8H10N4O2

julia> uconvert(CmolC8H10N4O2, 1molC8H10N4O2)
8.0 C-molC8H10N4O2

julia> uconvert(u"g", 1CmolC8H10N4O2)
24.274099999999997 g
```
