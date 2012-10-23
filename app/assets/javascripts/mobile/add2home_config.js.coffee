window.addToHomeConfig =
    expire: 2
    lifespan: 4000
    touchIcon: true
    autostart: false
    animationIn: 'bubble'
    animationOut: 'drop'
    returningVisitor: true

if gon.page is 'products_index'
    $ ->
        addToHome.show()


