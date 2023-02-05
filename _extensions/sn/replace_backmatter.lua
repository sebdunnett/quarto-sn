local backmatter_inserted = false

function Header(el)
  if quarto.doc.isFormat("pdf") then
    if not backmatter_inserted and el.classes:includes("backmatter") then
      backmatter_inserted = true
      el.content = pandoc.utils.stringify(el.content)
      return {
        pandoc.RawBlock('tex', '\\backmatter'),
        pandoc.RawBlock('tex', '\\bmhead*{' .. el.content .. '}')
      }
    elseif el.classes:includes("backmatter") then
      el.content = pandoc.utils.stringify(el.content)
      return pandoc.RawBlock('tex', '\\bmhead*{' .. el.content .. '}')
    end
  elseif quarto.doc.isFormat("html") and el.classes:includes("backmatter") then
    el.classes:extend{'unnumbered', 'appendix'}
    return el
  end
end