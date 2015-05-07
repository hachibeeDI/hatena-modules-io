require '../../node_modules/node-waves/dist/waves.min.css'

Waves = require 'node-waves'

Waves.attach('.btn', ['waves-button', 'waves-float'])
Waves.attach('.hatena-follow-button', ['waves-button', 'waves-float'])
Waves.attach('.custom-header__li', ['waves-button', 'waves-float'])
Waves.attach('.sns-share--link', ['waves-circle'])
Waves.attach('#blog-title-inner', ['waves-block'])

Waves.init()
