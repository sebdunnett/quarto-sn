local backmatter_inserted = false

function Header(el)
  if quarto.doc.isFormat("pdf") then
    if not backmatter_inserted and el.level == 1 and el.classes:includes("backmatter") then
      backmatter_inserted = true
      el.content = pandoc.utils.stringify(el.content)
      return {
        pandoc.RawBlock('tex', '\\backmatter'),
        pandoc.RawBlock('tex', '\\bmhead*{' .. el.content .. '}')
      }
    elseif el.level == 1 and el.classes:includes("backmatter") then
      el.content = pandoc.utils.stringify(el.content)
      return pandoc.RawBlock('tex', '\\bmhead*{' .. el.content .. '}')
    end
  elseif quarto.doc.isFormat("html") and el.classes:includes("backmatter") then
    el.classes = {"unnumbered"}
    return el
  end
end