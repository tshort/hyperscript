#let parse-selector(s) = {
  s = s.replace(" ", "")
  let r = regex("[\.#\[\]]")
  let splits = s.split(r)
  let types = s.matches(r).map(x => x.text)
  let tag = splits.remove(0)
  if tag == "" {
    tag = "div"
  }
  let classes = ()
  let attrs = (:)
  let id = ""
  for (typ, split) in types.zip(splits) {
    if typ == "." {
      classes.push(split)
    } 
    if typ == "#" {
      id = split
    } 
    if typ == "[" {
      let kv = split.split("=")
      if kv.len() > 1 {
        attrs.insert(kv.at(0), kv.at(1))
      }
    }
  }
  let class = (..classes, attrs.at("class", default: "")).join(" ").trim()
  if class != "" {
    attrs = attrs + (class: class)
  }
  if id != "" {
    attrs = attrs + (id: id)
  }

  return (tag, attrs)
}

#let h(selector, ..args) = {
  let pargs = args.pos()
  let (tag, attrs) = parse-selector(selector)
  if pargs.len() > 0 {
    if type(pargs.at(0)) == dictionary {
      attrs = attrs + pargs.remove(0)
    }
  }
  html.elem(tag, pargs.join(), attrs: attrs)
}

#let hc(selector, ..args) = context {
  if target() == "html" {
    return h(selector, ..args)
  }
  let pargs = args.pos()
  if pargs.len() > 0 {
    if type(pargs.at(0)) == dictionary {
      let dum = pargs.remove(0)
    }
  }
  return pargs.join()
}
