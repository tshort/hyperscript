# `hyperscript` — Create HTML with CSS-style selectors

`hyperscript` provides the `h` function that is a convenience wrapper for `html.elem`.

`h(selector, attributes, ..content)`

* `selector` -- A CSS-style selector.
* `attributes` (optional dictionary) -- Attributes for the HTML tag.
* `content` -- Content enclosed by the tag. Can be strings or content.

`selector` has the format "name.class1.class2#id[attr1=something][attr2=else]". All of the components are optional. If "name" is left out, "div" is assumed. One or more classes can be provided. The `class` and `id` are merged into `attributes`.

Note that `html.elem` doesn't have a way to pass in raw strings. Everything is encoded for HTML. Be careful with `<script>` tags, particularly `<`.

`hyperscript` also provides `hc` which is a method wrapped in a context that checks that the target is HTML.

Here are examples:

```typst
#import "@preview/hyperscript:0.1.0": *

#h("#hello")
// <div id="hello"></div>

#h("section.container")
// <section class="container"></section>

#h("input[type=text][placeholder=Name]")
// <input type="text" placeholder="Name" />

#h(".fancy-list#mylist")[
  - one
  - two
  - three
]
// <div class="fancy-list" id="mylist">
//   <ul>
//     <li>one</li>
//     <li>two</li>
//     <li>three</li>
//   </ul>
// </div>

```


This approach is based on [hyperscript (JavaScript)](https://github.com/hyperhype/hyperscript). [Mithril](https://mithril.js.org/hyperscript.html) is also a nice JavaScript package with hyperscript-style HTML generation.
