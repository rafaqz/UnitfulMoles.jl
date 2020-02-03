module UnitfulMoles

using Unitful

export @mol, @xmol, @compound, @u_str, @unit, uconvert

"""
    @mol(x::Symbol)

The @mol macro lets you declare specific molar units.

Usage example:
```
julia> @mol N 
julia> 2μmolN
2 μmol(N)
```
"""
macro mol(x::Symbol)
    symb = Symbol("mol", x)
    abbr = "mol($x)"
    name = "Moles $(x)"
    equals = """ 1u"mol" """
    tf = true

    expr = Expr(:block)
    push!(expr.args, Meta.parse("""@unit $symb "$abbr" "$name" $equals $tf"""))
    esc(expr)
end

"""
    @mol(x::Symbol, grams::Real)

The @mol macro lets you declare specific molar units, with weight in grams.

Usage example:
```
julia> @mol N 14.007
julia> 2μmolN/u"L"
2 L^-1 μmol(N)
```
"""
macro mol(x::Symbol, grams::Real)
    symb = Symbol("mol", x)
    abbr = "mol($x)"
    name = "Moles $(x)"
    equals = """ $(grams)u"g" """
    tf = true

    expr = Expr(:block)
    push!(expr.args, Meta.parse("""@unit $symb "$abbr" "$name" $equals $tf"""))
    esc(expr)
end

"""
    @compound(compound::Symbol)

The @compound macro lets you declare a compound moles using their chemical
formula. Gram conversions are generated for free from components.

Usage example:
```
julia> @mol H 1.008
mol(H)
julia> @mol O 15.999
mol(O)
julia> @compound H2O
mol(H2O)
julia>
2molH2O |> u"g"
36.03 g
```
"""
macro compound(name::Symbol)
    elements = parse_compound(string(name))
    weight = 0.0u"g"
    for (el, n) in elements
        weight += getweight(el) * n
    end
    weight_stripped = ustrip(weight)
    str = """@mol $name $weight_stripped"""
    return esc(Meta.parse(str))
end

"""
    @xmol(base::Symbol, compound::Symbol)

The @mol macro lets you declare a fractional compound mole with a particular
base, such as a C-mol.

Usage example:
```
julia> @xmol C C8H10N4O2
julia> 1CmolC8H10N4O2 |> molC8H10N4O2
0.125 mol(C8H10N4O2)
```
"""
macro xmol(base::Symbol, compound::Symbol)
    elements = parse_compound(string(compound))
    n = 1/sum_base(base, elements)

    symb = Symbol(base, "mol", compound)
    abbr = "$(base)-mol($compound)"
    name = "$base-moles $(compound)"
    equals = "$(n)mol$(compound)"
    tf = true

    expr = Expr(:block)
    push!(expr.args, Meta.parse("""@compound $compound"""))
    push!(expr.args, Meta.parse("""@unit $symb "$abbr" "$name" $equals $tf"""))
    esc(expr)
end


function sum_base(base, elements::Array{Pair{String,Int},1})
    number = 0
    for (element, n) in elements
        if string(base) == element;
            number += n
        end
    end
    return number
end

function parse_compound(str::String)
    elements = Pair{String,Int}[]
    numstring = ""
    element = str[1:1]
    for c in str[2:end]
        if 48 <= convert(Int, c) <= 57 # Check c is a number
            numstring *= c
        elseif isuppercase(c) # Elements start with an uppercase letter
            push_element!(elements, element, numstring)
            element = string(c)
            numstring = ""
        elseif islowercase(c)
            element *= c
        end
    end
    push_element!(elements, element, numstring)
    return elements
end

function push_element!(elements, element, n)
    if n == ""; n = "1" end
    push!(elements, element => Base.parse(Int, n))
end

function getweight(arg::String)
    local w
    try
        w = eval(Meta.parse("""uconvert(u"g", 1Main.mol$(arg))"""))
    catch
        w = eval(Meta.parse("""uconvert(u"g", 1u"mol$(arg)")"""))
    end
    return w
end

end # module
