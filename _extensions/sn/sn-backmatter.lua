-- local docs = debug.getregistry()['HsLua docs']

-- for k, v in pairs(pandoc) do
--   if type(v) == 'function' then
--     print(k, table.unpack(pandoc.List.map(docs[v].parameters, function (x) return x.type end)))
--   else
--     print(k, docs[v])
--   end
-- end

--- Create section divs for the given blocks.
-- With pandoc 3 and later, this uses pandoc.structure.make_sections;
-- otherwise we wrap an old (now deprecated) function to make it behave
-- similarly.
local make_sections = pandoc.structure.make_sections or
  function (blks)
    return pandoc.utils.make_sections(false, nil, blks)
  end

local function partition_blocks (blks)
  local mainmatter, backmatter = pandoc.Blocks{}, pandoc.Blocks{}
  local xmatter = mainmatter
  for i, blk in ipairs(make_sections(blks)) do
    if blk.t == 'Div' and blk.classes:includes 'backmatter' then
      xmatter = backmatter
    end
    xmatter:insert(blk)
  end
  return mainmatter, backmatter
end

local function latex (tex)
  return {pandoc.RawInline('latex', tex)}
end

-- Filter for backmatter blocks
local bmheads = {
  Header = FORMAT == 'latex'
    and function (h)
      -- We wrap the section title in a span here to enable linking to
      -- this section.
      return pandoc.Plain{
        pandoc.Span(latex('\\bmhead*{') .. h.content .. latex('}'), h.attr)
      }
    end
    or function (h)
      h.classes:extend{'unnumbered', 'appendix'}
      return h
    end
}

function Pandoc (doc)
  local mainmatter, backmatter = partition_blocks(doc.blocks)
  doc.blocks = mainmatter ..
    {pandoc.RawBlock('latex', '\\backmatter')} ..
    backmatter:walk(bmheads)
  return doc
end
