function RawBlock(el)
    if el.format == "tex" then
        local s = el.text:gsub("\\toprule", "\\toprule")
        return pandoc.RawBlock("tex", s)
    end
end