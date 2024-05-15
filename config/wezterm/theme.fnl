(let [{: dark : light : colorscheme : render-background} (require :themefn)]
  {:color_schemes {"BlueSky Dark" dark "BlueSky Light" light}
   :color_scheme (colorscheme)
   :background (render-background)})

