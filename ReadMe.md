# UnitfulMoles

[![Build Status](https://travis-ci.org/rafaqz/UnitfulMoles.jl.svg?branch=master)](https://travis-ci.org/rafaqz/UnitfulMoles.jl)

This package provides a standardised method for defining mol units for the julia
language, using Unitful.jl. 

## Moles

The main command is the @mol macro:

```
julia> @mol C 12.011                                               
molC                                                             
```

It allows conversion between mol and g:

```
jpickulia> @mol N 14.0067
molN                                                             

julia> uconvert(u"g", 5molN)                                       
70.0335 g 
```

And allows units to be expressed as mol / mol:

```
julia> @mol O 15.999
molO                                                             
julia> 0.5molC/molN                                                
0.5 molC molN^-1    
```

A set of predefined mol units is maintained separately in
[UnitfulConventionalMoles.jl](https://github.com/rafaqz/UnitfulConventionalMoles.jl).

## Compounds

The @compound macro lets you combine basic elements into compound molecules:

```
julia> @mol O 15.999
molO

julia> @compound NO3                                      
molNO3                                                    
```

And weight conversions work for free!

```
julia> uconvert(u"g", 10molNO3)                             
620.037 g                                                   
```


You can also use these macros in assignments:

```
julia> x = (100@compound CO2) / 25u"L"
4.0 L^-1 molCO2

julia> uconvert(u"g/L", x)
176.3600000000001 g L^-1
```

## C-mol and others

The @xmol macro creates fractional moles scaled to one mole of an element in a
compound. The best example is the C-mole, which measure the amount of a compound
relative to one mole of C:

```
@xmol C C8H10N4O2

julia> uconvert(molC8H10N4O2, 1CmolC8H10N4O2)                             
0.125 molC8H10N4O2                                                      

julia> uconvert(CmolC8H10N4O2, 1molC8H10N4O2)
8.0 CmolC8H10N4O2
                                                                          
julia> uconvert(u"g", 1CmolC8H10N4O2)                                     
24.27425 g                                                                
```
