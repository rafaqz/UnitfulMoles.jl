# UnitfulMoles

This package provides a standardised method for defining mol units for the julia
language, using Unitful.jl. 

The main command is the @mol macro:

```
julia> @mol C 12.011                                               
mol(C)                                                             
```

It allows conversion between mol and g:

```
julia> @mol N 14.0067
mol(N)                                                             

julia> uconvert(u"g", 5molN)                                       
70.0335 g 
```

And allows units to be expressed as mol / mol:

```
julia> @mol O 15.999
mol(O)                                                             
julia> 0.5molC/molN                                                
0.5 mol(C) mol(N)^-1    
```

The @compound macro lets you combine basic elements into compound molecules:

```
julia> @mol O 15.999
mol(O)

julia> @compound N O 3                                      
mol(NO3)                                                    
```

And weight conversions work for free!

```
julia> uconvert(u"g", 10molNO3)                             
620.037 g                                                   
```


A set of predefined mol units is maintained separately in
[UnitfulConventionalMoles.jl](https://github.com/rafaqz/UnitfulConventionalMoles.jl).
