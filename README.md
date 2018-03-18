# UnitfulMoles

This package provides a standardised method for defining mol units with gram
conversion using Unitful.jl. 

This package is basically just the @mol macro.

```
julia> @mol C 12.011                                               
mol(C)                                                             
```

It allows conversion between mol and g:

```
@mol N 14.0067
mol(N)                                                             

julia> uconvert(u"g", 5molN)                                       
70.0335 g 
```

And allows units to be expressed as mol / mol:

```
julia> 0.5molC/molN                                                
0.5 mol(C) mol(N)^-1    
```
