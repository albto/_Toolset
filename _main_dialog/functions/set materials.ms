actionMan.executeAction 0 "50048"  -- Tools: Material Editor Toggle
max mtledit
meditMaterials[1] = Standardmaterial ()
meditMaterials[1].diffuseMap = Checker ()
meditMaterials[1][#Maps][#Diffuse_Color__Map__1____Checker].color1 = color 10 10 10
meditMaterials[1][#Maps][#Diffuse_Color__Map__1____Checker].color2 = color 20 20 20
$.material = meditMaterials[1]
$.material.DirectX_Manager.dxStdMat = on
$.wirecolor = color 25 25 25

