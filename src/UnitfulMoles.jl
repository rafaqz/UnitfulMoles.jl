module UnitfulMoles 

using Unitful

export @mol, @compound, @u_str, uconvert


macro mol(x, grams)
    free = Symbol("_mol$x")
    fixed = Symbol("mol$x")
    unit_string = """@unit $free "mol($x)" "Moles $(x)" $(grams)u"g" false"""
    return quote
        eval(parse($unit_string))
        $(esc(fixed)) = Unitful.FixedUnits($free)
    end
end

macro compound(args...)
    local element
    local name = ""
    local weight = 0.0u"g"
    has_element = false
    for arg in args
        if isa(arg, Int)
            weight += get_weight(element) * arg
            has_element = false
        else 
            if has_element
                weight += get_weight(element)
            end
            element = arg
            has_element = true
        end
        name = string(name, arg)
    end

    if has_element
        weight += get_weight(element)
    end
    weight_stripped = ustrip(weight)
    str = """@mol $name $weight_stripped"""
    return esc(parse(str))
end

function get_weight(arg::Symbol)
    local w
    try
        w = eval(parse("""uconvert(u"g", 1Main.mol$(arg))"""))
    catch 
        w = eval(parse("""uconvert(u"g", 1u"mol$(arg)")"""))
    end
    return w
end

end # module
