-- create new layer
actionMan.executeAction 0 "40099"
layer = LayerManager.newLayer()
layer.setname "_Objects"
for n in (selection as array) do layer.addnode n
