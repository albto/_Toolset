	

	TagsList = #()
	LayersList = #()
	TypeList = #()
	ObjectTypes = #("Characters", "Exteriors", "Interiors", 
	"Lights", "Props", "Structures", "Terrain", 
	"Vehicles", "VertexAnims", "Weapons" )	


	--load unity layers xml file
	filein ((mainFPFolder + "\\FlowPanels\\_base\\XMLGenerator.ms") as String ) 
	flowIns = flowCore()
	flowIns.LoadXml()
	TagsRoot = flowIns.xmlDoc.DocumentElement
	
		--load and distribute xml data to tags dropdownList
		fn LoadDataFromXml root attr list = 
		(
			childNodes=root.childNodes
				
			for i = 0 to childNodes.Count-1 do 
			(
				ele = childNodes.ItemOf[i]
				eleName = ele.getAttribute "name"
					
				if eleName == attr then
				(
					eleChildren = ele.childNodes
						
					for i = 0 to eleChildren.count-1 do 
					(
						child = eleChildren.ItemOf[i]
						
						--print (child.getAttribute "name")
						list[i+1] = (child.getAttribute "name")
					)
				)
					
			)
				
		)
		
		
		

		
		
-- Load .NET assemblies
--dotNet.loadAssembly "System.Windows.Forms"
--dotNet.loadAssembly "System.Drawing"
-- (dotnetclass "System.gc").SuppressFinalize AssemblyComboBox 
-- (Dotnetclass "System.gc").KeepAlive AssemblyComboBox 

-- Define a function to create the form
fn createForm =
(

	
	try ( form.close() ) catch()		
	
	verFont = dotNetObject "System.Drawing.Font" "Verdana" 8.5 ((dotNetClass "System.Drawing.FontStyle").bold)
	--showProperties verFont
	
    -- Create a new instance of a Form
    local form = dotNetObject "MaxCustomControls.MaxForm" --"System.Windows.Forms.Form"
    form.Text = "Unity Project Handler"
    form.Width = 400
    form.Height = 360
	form.font = verFont
	form.autoSize = true
	form.autosizemode= (dotNetClass "System.Windows.Forms.AutoSizeMode").GrowOnly
    -- Set form background color to dark gray
	form.TopMost = true
	
	--Create Group01 
	formGroupBox1 = (dotNetObject "System.Windows.Forms.GroupBox")
	formGroupBox1.width = (200)
	formGroupBox1.height= (form.height-20)
	formGroupBox1.left = 0
	formGroupBox1.top = 05
	formGroupBox1.autoSize = true
	formGroupBox1.flatStyle=(dotNetClass "System.Windows.Forms.FlatStyle").flat
	formGroupBox1.BackColor = (dotNetClass "System.Drawing.Color").FromArgb 55 55 55
	--showproperties formGroupBox1 
	
	formGroupBox2 = (dotNetObject "System.Windows.Forms.GroupBox")
	formGroupBox2.width = (form.width-20)
	formGroupBox2.height= (formGroupBox1.height-20)
	formGroupBox2.top = (formGroupBox1.height+(formGroupBox1.height/100))

	
	
	
	
	
	
	
	
    -- Create a label - UNITY TAGS 
    local LO_UnityTags = dotNetObject "System.Windows.Forms.Label"
    LO_UnityTags.Text = "Unity Tag:"
	LO_UnityTags.font = verFont
    LO_UnityTags.Location = dotNetObject "System.Drawing.Point" 20 40--(form.width/5) ((form.height/5)+LO_UnityTags.width)
    LO_UnityTags.AutoSize = true
    LO_UnityTags.ForeColor = (dotNetClass "System.Drawing.Color").FromArgb 250 210 210 -- Set text color to white
	LO_UnityTags.BackColor = (dotNetClass "System.Drawing.Color").FromArgb 50 50 50
	
	--Create a DotNet ComboBox
	CB_UnityTags = dotNetObject "System.Windows.Forms.ComboBox"
	CB_UnityTags.size = dotNetObject "System.Drawing.Size" 160 5
	CB_UnityTags.flatStyle=(dotNetClass "System.Windows.Forms.FlatStyle").flat
	CB_UnityTags.BackColor = (dotNetClass "System.Drawing.Color").FromArgb 45 45 48
	CB_UnityTags.ForeColor = (dotNetClass "System.Drawing.Color").FromArgb 160 160 180
	CB_UnityTags.Location = dotNetObject "System.Drawing.Point" 20 60	
	
		
	--Load tags data 
	LoadDataFromXml flowIns.xmlDoc.DocumentElement "Tags" TagsList
	
	for i = 1 to TagsList.count do
	(
		CB_UnityTags.Items.Add(TagsList[i])
	)
	
	--set index
	CB_UnityTags.SelectedIndex = 0	
	
	-- Create a label - UNITY TAGS 
    local LO_UnityLayers = dotNetObject "System.Windows.Forms.Label"
    LO_UnityLayers.Text = "Unity Layer:"
	LO_UnityLayers.font = verFont
    LO_UnityLayers.Location = dotNetObject "System.Drawing.Point" 20 100--(form.width/5) ((form.height/5)+LO_UnityTags.width)
    LO_UnityLayers.AutoSize = true
    LO_UnityLayers.ForeColor = (dotNetClass "System.Drawing.Color").FromArgb 250 210 210 -- Set text color to white
	LO_UnityLayers.BackColor = (dotNetClass "System.Drawing.Color").FromArgb 50 50 50
	
	--Create a DotNet ComboBox
	CB_UnityLayers = dotNetObject "System.Windows.Forms.ComboBox"
	CB_UnityLayers.size = dotNetObject "System.Drawing.Size" 160 5
	CB_UnityLayers.flatStyle=(dotNetClass "System.Windows.Forms.FlatStyle").flat
	CB_UnityLayers.BackColor = (dotNetClass "System.Drawing.Color").FromArgb 45 45 48
	CB_UnityLayers.ForeColor = (dotNetClass "System.Drawing.Color").FromArgb 160 160 180
	CB_UnityLayers.Location = dotNetObject "System.Drawing.Point" 20 120	
	
	--showProperties CB_UnityLayers
	
	--Load layers data 
	LoadDataFromXml flowIns.xmlDoc.DocumentElement "Layers" LayersList
	
	for i = 1 to LayersList.count do
	(
		CB_UnityLayers.Items.Add(LayersList[i])
	)
	
	--set index
	CB_UnityLayers.SelectedIndex = 0
	
		-- Create a label - UNITY TAGS 
    local LO_UnityAttribute = dotNetObject "System.Windows.Forms.Label"
    LO_UnityAttribute.Text = "Unity Attribute:"
	LO_UnityAttribute.font = verFont
    LO_UnityAttribute.Location = dotNetObject "System.Drawing.Point" 20 160--(form.width/5) ((form.height/5)+LO_UnityTags.width)
    LO_UnityAttribute.AutoSize = true
    LO_UnityAttribute.ForeColor = (dotNetClass "System.Drawing.Color").FromArgb 250 210 210 -- Set text color to white
	LO_UnityAttribute.BackColor = (dotNetClass "System.Drawing.Color").FromArgb 50 50 50
	
	--Create a DotNet ComboBox
	CB_UnityAttribute = dotNetObject "System.Windows.Forms.ComboBox"
	CB_UnityAttribute.size = dotNetObject "System.Drawing.Size" 160 5
	CB_UnityAttribute.flatStyle=(dotNetClass "System.Windows.Forms.FlatStyle").flat
	CB_UnityAttribute.BackColor = (dotNetClass "System.Drawing.Color").FromArgb 45 45 48
	CB_UnityAttribute.ForeColor = (dotNetClass "System.Drawing.Color").FromArgb 160 160 180
	CB_UnityAttribute.Location = dotNetObject "System.Drawing.Point" 20 180	
	
	--showProperties CB_UnityAttribute
	
	--Load layers data 
	LoadDataFromXml flowIns.xmlDoc.DocumentElement "Attributes" TypeList
	
	for i = 1 to TypeList.count do
	(
		CB_UnityAttribute.Items.Add(TypeList[i])
	)
	
	--set index
	CB_UnityAttribute.SelectedIndex = 0
	
	
			-- Create a label - UNITY TAGS 
    local LO_UnityType = dotNetObject "System.Windows.Forms.Label"
    LO_UnityType.Text = "Unity Type:"
	LO_UnityType.font = verFont
    LO_UnityType.Location = dotNetObject "System.Drawing.Point" 20 220--(form.width/5) ((form.height/5)+LO_UnityTags.width)
    LO_UnityType.AutoSize = true
    LO_UnityType.ForeColor = (dotNetClass "System.Drawing.Color").FromArgb 250 210 210 -- Set text color to white
	LO_UnityType.BackColor = (dotNetClass "System.Drawing.Color").FromArgb 50 50 50
	
	--Create a DotNet ComboBox
	CB_UnityType = dotNetObject "System.Windows.Forms.ComboBox"
	CB_UnityType.size = dotNetObject "System.Drawing.Size" 160 5
	CB_UnityType.flatStyle=(dotNetClass "System.Windows.Forms.FlatStyle").flat
	CB_UnityType.BackColor = (dotNetClass "System.Drawing.Color").FromArgb 45 45 48
	CB_UnityType.ForeColor = (dotNetClass "System.Drawing.Color").FromArgb 160 160 180
	CB_UnityType.Location = dotNetObject "System.Drawing.Point" 20 240	
	
	--showProperties CB_UnityAttribute
	
	--Load layers data 
	--LoadDataFromXml flowIns.xmlDoc.DocumentElement "Attributes" TypeList
	
	for i = 1 to ObjectTypes.count do
	(
		CB_UnityType.Items.Add(ObjectTypes[i])
	)
	
	--set index
	CB_UnityType.SelectedIndex = 0
	
	
	
	--Create a DotNet Button
    mButton = dotNetObject "System.Windows.Forms.Button"
    mButton.text = "Get Attributes"
    mButton.size = dotNetObject "System.Drawing.Size" 160 20
    mButton.flatStyle=(dotNetClass "System.Windows.Forms.FlatStyle").standard
	mButton.Location = dotNetObject "System.Drawing.Point" 20 270
	--showproperties  mButton	
		
		
	--Create a DotNet ComboBox
	CK_GenCollision = dotNetObject "System.Windows.Forms.CheckBox"
	CK_GenCollision.text = "Generate Collision"
	CK_GenCollision.size = dotNetObject "System.Drawing.Size" 160 20
	CK_GenCollision.Location = dotNetObject "System.Drawing.Point" 20 40
	CK_GenCollision.BackColor = (dotNetClass "System.Drawing.Color").FromArgb 50 50 50
	CK_GenCollision.ForeColor = (dotNetClass "System.Drawing.Color").FromArgb 160 160 180
	
	CK_GenLightmap = dotNetObject "System.Windows.Forms.CheckBox"
	CK_GenLightmap.text = "Generate Lightmap"
	CK_GenLightmap.size = dotNetObject "System.Drawing.Size" 160 20
	CK_GenLightmap.Location = dotNetObject "System.Drawing.Point" 20 60
	CK_GenLightmap.BackColor = (dotNetClass "System.Drawing.Color").FromArgb 50 50 50
	CK_GenLightmap.ForeColor = (dotNetClass "System.Drawing.Color").FromArgb 160 160 180
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	--showProperties CK_GenCollision
	
	
	--CB_UnityTags.location = dotNetObject "System.Drawing.Point" 0 0
	--CB_UnityTags.AutoSize = true
    -- Add the label to the form
    --form.Controls.AddRange #(label, mButton, CB_UnityTags)
	--Form Settings 
	--showProperties form.margin
	
	--Add to GroupBox
	CB_UnityTags.parent = formGroupBox1
	CB_UnityLayers.parent = formGroupBox1
	CB_UnityAttribute.parent = formGroupBox1
	CB_UnityType.parent = formGroupBox1
	
	LO_UnityTags.parent = formGroupBox1
	LO_UnityLayers.parent = formGroupBox1
	LO_UnityAttribute.parent = formGroupBox1
	LO_UnityType.parent = formGroupBox1
	
	
	mButton.parent = formGroupBox2
	CK_GenCollision.parent = formGroupBox2
	CK_GenLightmap.parent = formGroupBox2
	
	
	--Add GroupBox to Form
	form.Controls.Add formGroupBox1
	form.Controls.Add formGroupBox2
	
    -- Show the form
    form.Show()
	
)

-- Call the function to create the form
createForm()

