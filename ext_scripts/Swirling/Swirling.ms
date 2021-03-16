/*
author: Bodyul Vladislav
email: bodulwlpc@gmail.com
*/

plugin simpleMod SwirlingMod
name:"Swirling"
classID:#(0x1dad978f, 0x4fd0f4ba)
version:1
(
	parameters main rollout:params
	(
		RotX type:#float ui:RotX_spn default:180
		RotY type:#float ui:RotY_spn default:0
		RotZ type:#float ui:RotZ_spn default:0
		radius type:#float ui:Radius_spn default:50
		falloffVal type:#float ui:Falloff_spn default:1
	)
	
	rollout params "Parameters"
	(
		groupbox grp1 "Angle" pos:[8,8] width:146 height:85
			spinner RotX_spn "X: "  pos:[62,27] type:#float range:[-100000,100000,0] scale:0.5
			spinner RotY_spn "Y: " pos:[62,48] type:#float range:[-100000,100000,0] scale:0.5
			spinner RotZ_spn "Z: " pos:[62,69] type:#float range:[-100000,100000,0] scale:0.5
		
		groupbox grp2 "Radius" pos:[8,100] width:146 height:64
			spinner Radius_spn "Radius: " pos:[36,119] type:#float range:[-100000,100000,50] scale:0.25
			spinner Falloff_spn "Falloff: " pos:[38,140] type:#float range:[0,1000,1] scale:0.01
		
		hyperlink url_hp "Bodyul Vladislav" pos:[45,170] address:"http://bodulwlpc.wix.com/ms-scripts" color:(color 0 170 230) hovercolor:(color 0 170 230) visitedcolor:(color 0 170 230) 
	
		on params open do
		(
			for i in params.controls where ClassOF i == SpinnerControl do print i.pos
		)
	)

	on map i p do
	(
		local dist = (distance p center)
		local val = (radius - dist)
		if val < 0 then val = 0
		local percent = (100. / radius * (pow radius (falloffVal + 1))) / 100.
		val = (pow val (falloffVal + 1)) / percent
		p *= (eulerangles (val * RotX / radius) (val * RotY / radius) (val * RotZ / radius)) as quat
		p
	)
)