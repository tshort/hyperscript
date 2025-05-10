// Function to check if a dictionary is empty
#let is_empty(dict) = {
  for key in dict.keys() {
    return false
  }
  return true
}

// Function to compile a CSS-like selector into Typst components
#let compile_selector(selector) = {
  // Typst regex works differently, so we'll adapt the approach
  let tag = "div"
  let classes = ()
  let attrs = (:)
  
  // Process ID selectors (#id)
  let id_pattern = regex("#([^#\\.\\[\\]]+)")
  let id_matches = selector.match(id_pattern)
  if id_matches != none {
    attrs.insert("id", id_matches.captures.at(0))
  }
  
  // Process class selectors (.class)
  let class_pattern = regex("\\.([^#\\.\\[\\]]+)")
  let class_matches = selector.matches(class_pattern)
  for match in class_matches {
    classes.push(match.captures.at(0))
  }
  
  // Process tag name (if it starts with a letter)
  let tag_pattern = regex("^([a-zA-Z][^#\\.\\[\\]]*)")
  let tag_match = selector.match(tag_pattern)
  if tag_match != none {
    tag = tag_match.captures.at(0)
  }
  
  // Process attribute selectors [attr] or [attr=value]
  let attr_pattern = regex("\\[(.+?)(?:\\s*=\\s*([\"\']?)(.+?)\\2)?\\]")
  let attr_matches = selector.matches(attr_pattern)
  for match in attr_matches {
    let attr_name = match.captures.at(0)
    if match.captures.len() >= 3 {
      let attr_value = match.captures.at(2)
      if attr_name == "class" {
        classes.push(attr_value)
      } else {
        attrs.insert(attr_name, attr_value)
      }
    } else {
      // Attribute without value
      attrs.insert(attr_name, true)
    }
  }
  
  // Handle classes
  if classes.len() > 0 {
    attrs.insert("class", classes.join(" "))
  }
  
  // Return empty attrs as none (null equivalent)
  if is_empty(attrs) {
    attrs = none
  }
  
  return (tag: tag, attrs: attrs)

}

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
