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
2 μmolN
```
"""
macro mol(x::Symbol)
    abbr = "mol$x"
    symb = Symbol(abbr)
    name = Symbol("Moles $x")
    equals = :(1u"mol")
    tf = true

    expr = Expr(:block)
    push!(expr.args, :(@unit $symb $abbr $name $equals $tf))
    return esc(expr)
end

"""
    @mol(x::Symbol, grams::Real)

The @mol macro lets you declare specific molar units, with weight in grams.

Usage example:
```
julia> @mol N 14.007
julia> 2μmolN/u"L"
2 L^-1 μmolN
```
"""
macro mol(x::Symbol, grams::Union{Real,Symbol,Expr})
    grams = grams isa Expr ? esc(grams) : grams
    abbr = "mol$x"
    symb = Symbol(abbr)
    name = Symbol("Moles $x")
    equals = :($grams * u"g")
    tf = true

    expr = Expr(:block)
    push!(expr.args, :(@unit $symb $abbr $name $equals $tf))
    return esc(expr)
end

"""
    @compound(compound::Symbol)

The @compound macro lets you declare a compound moles using their chemical
formula. Gram conversions are generated for free from components.

Usage example:
```
julia> @mol H 1.008
molH
julia> @mol O 15.999
molO
julia> @compound H2O
molH2O
julia>
2molH2O |> u"g"
36.03 g
```
"""
macro compound(name::Symbol)
    elements = parse_compound(string(name))
    
    sum_expr = Expr(:block, :(weight = 0.0u"g")) 
    for (el, n) in elements
        x = Symbol("mol$el")
        w = :(Unitful.uconvert(u"g", 1 * $x))
        push!(sum_expr.args, :(weight += $n * $w))
    end
    name = Symbol(subscriptify(string(name)))

    weight_expr = :(weight = ustrip($sum_expr))
    mol_expr = :(@mol $name weight)
    return Expr(:block, esc(weight_expr), esc(mol_expr))
end

"""
    @xmol(base::Symbol, compound::Symbol)

The @mol macro lets you declare a fractional compound mole with a particular
base, such as a C-mol.

Usage example:
```
julia> @xmol C C8H10N4O2
julia> 1CmolC8H10N4O2 |> molC8H10N4O2
0.125 molC8H10N4O2
```
"""
macro xmol(base::Symbol, compound::Symbol)
    elements = parse_compound(string(compound))
    n = 1/sum_base(base, elements)

    # Subscriptify compound
    compound = Symbol(subscriptify(string(compound)))

    symb = Symbol(base, "mol", compound)
    abbr = "$base-mol$compound"
    name = Symbol("$base-moles $compound")
    equals = :($n * $(Symbol("mol$compound")))
    tf = true

    expr = Expr(:block)
    push!(expr.args, :(@compound $compound))
    push!(expr.args, :(@unit $symb $abbr $name $equals $tf))
    esc(expr)
end


function sum_base(base, elements::Array{Pair{T,Int},1}) where {T<:AbstractString}
    number = 0
    for (element, n) in elements
        if string(base) == element;
            number += n
        end
    end
    return number
end

# turn integers in compound name into subscripts
# inspired from Unitful.superscript
subscriptify(s::AbstractString) = map(s) do c
    c == '0' ? '\u2080' :
    c == '1' ? '\u2081' :
    c == '2' ? '\u2082' :
    c == '3' ? '\u2083' :
    c == '4' ? '\u2084' :
    c == '5' ? '\u2085' :
    c == '6' ? '\u2086' :
    c == '7' ? '\u2087' :
    c == '8' ? '\u2088' :
    c == '9' ? '\u2089' :
    c
end
# turn subscript integers in compound name into integer characters
desubscriptify(s::AbstractString) = map(s) do c
    c == '\u2082' ? '2' :
    c == '\u2083' ? '3' :
    c == '\u2084' ? '4' :
    c == '\u2085' ? '5' :
    c == '\u2086' ? '6' :
    c == '\u2087' ? '7' :
    c == '\u2088' ? '8' :
    c == '\u2089' ? '9' :
    c == '\u2080' ? '0' :
    c == '\u2081' ? '1' :
    c
end

parse_compound(s::String) = [element_num_pair(Xn) for Xn in split(desubscriptify(s), r"(?=\p{Lu}(?:\p{Ll})*(?:\d)*)")]
element_num_pair(s::AbstractString) = strip(isdigit, s) => num_element(lstrip(isletter, s))
num_element(s::AbstractString) = isempty(s) ? 1 : Base.parse(Int, s)


include("conventionalmoles.jl")

# Allow precompile, and register mol units with u_str macro.
const localunits = Unitful.basefactors
function __init__()
    merge!(Unitful.basefactors, localunits)
    Unitful.register(UnitfulMoles)
end

end # module
