module UnitfulMoles 

using Unitful

export @u_str, @mol

macro mol(x, grams)
    free = Symbol("_mol$x")
    fixed = Symbol("mol$x")
    unit_string = """@unit $free "mol($x)" "Moles$(x)" $(grams)u"g" false"""
    return quote
        eval(parse($unit_string))
        $(esc(fixed)) = Unitful.FixedUnits($free)
    end
end

end # module
