

# give Python access to Blender's functionality
import bpy
import xml.etree.ElementTree as ET
import os
from pathlib import Path

from enum import Enum


##-------------------------------------------------------------------------------------------------------------
    
bl_info = {
    "name": "Unity Attributes Panel",
    "author": "Alberto Rodriguez",
    "version": (0, 0, 1),
    "blender": (4, 1, 0),
    "location": "3D Viewport > Sidebar > Attributes",
    "description": "Unity Attributes Pabel",
    "category": "Development"}


#variables-------------------------------------------

layers_list = []
tags_list = []
types_list = []
components_list = []
attributes_list = []
interacts_list = []

current_category_list = []




def get_root_dir(root_dir, list):
    
    for dirpath, dirnames, filenames in os.walk(root_dir):
        print("Directory:", dirpath)

        for dirname in dirnames:
            list.add(dirname)
            print("Subfolder:", os.path.join(dirpath, dirname))
    return list 


#----------------------------------------------------

class Attributes(bpy.types.PropertyGroup):
        
    
    #Convert List to Enum Property 
    def list_to_enum(enum_name, input_list):

        items =[(item, item, item) for item in input_list]
        
        return items
    

    #Read XML data and Update Lists -----------------------------------------------------------
    def getxmldata():

        file_path = Path('D:\\Projects\\Project3D\\Assets\\Resources\\Layers\\UnityLayers.xml')

        tree = ET.parse(file_path)
        root = tree.getroot()
        
        print('-----------------------------Tags---------------------------------')    
        
        #load unity tags list 
        for tag in root.findall('UnityTags/tag'):
            value = tag.get('name')
            
            tags_list.append(value)
            #print(str(value))
        
        print(tags_list)
        
        print('-----------------------------Layers-------------------------------')
        
        #load unity layers list
        for layer in root.findall('UnityLayers/layer'):
            value = layer.get('name')
            
            layers_list.append(value)
            #print(str(value))
        
        print(layers_list)
        
        print('-----------------------------Components----------------------------')
        
        #load unity components list
        for component in root.findall('UnityComponents/Component'):
            value = component.get('name')
            
            components_list.append(value)
            #print(str(value))
        
        print(components_list)
        
        print('-----------------------------Types---------------------------------')
        
        #load unity types list
        for type in root.findall('UnityTypes/Type'):
            value = type.get('name')
            
            types_list.append(value)
            #print(str(value))
        
        print(types_list)
        
        print('-----------------------------Attributes----------------------------')
        
        #load unity attributes list
        for attribute in root.findall('UnityAttributes/Attribute'):
            value = attribute.get('name')
            
            attributes_list.append(value)
            #print(str(value))
        
        print(attributes_list)     
        
        print('-----------------------------Interacts-----------------------------')
        
        #load unity interacts list
        for interact in root.findall('UnityInteracts/Interact'):
            value = interact.get('name')
            
            interacts_list.append(value)
            #print(str(value))
        
        print(interacts_list)

    #function ends---------------------------------------------------------------------


        
    #Run XML Data Getter function
    getxmldata()
    
    
    #Tags------------------------------------
    tag_enum : bpy.props.EnumProperty(
        name="Tag",
        description="Select Object Tag",
        items= list_to_enum("Tag", tags_list)    
    )
    #Layers----------------------------------
    layer_enum : bpy.props.EnumProperty(
        name="Layer",
        description="Select Object Layer",
        items= list_to_enum("Layer", layers_list)   
    )
    #Types-----------------------------------   
    type_enum : bpy.props.EnumProperty(
        name="Type",
        description="Select Object Type",
        items= list_to_enum("Type", types_list)    
    )
    #Components------------------------------    
    component_enum : bpy.props.EnumProperty(
        name="Component",
        description="Select Object Component",
        items= list_to_enum("Type", components_list)    
    )
    #Attributes------------------------------ 
    attribute_enum : bpy.props.EnumProperty(
        name="Attribute",
        description="Select Object Attribute",
        items= list_to_enum("Type", attributes_list)    
    )
    #Interacts-------------------------------
    interact_enum : bpy.props.EnumProperty(
        name="Interact",
        description="Select Object Interact",
        items= list_to_enum("Type", interacts_list)        
    )
    #----------------------------------------
    
    
    #Categories------------------------------
    category_enum : bpy.props.EnumProperty(
        name="Category",
        description="Select Category",
        items=[
                ('0', "None", ""),
                ('1', "Character", ""),
                ('2', "Decal", ""),
                ('3', "Exterior", ""),
                ('4', "Interior", ""),
                ('5', "Prop", ""),
                ('6', "Structure", ""),
                ('7', "Vehicle", ""),
                ('8', "Weapon", ""),            
        ]
    )
    #SubCategory----------------------------
    subcategory_enum : bpy.props.EnumProperty(
        name="Sub-Category",
        description="Select Category",
        items=[
                ('0', "None", ""),
                ('1', "Character", ""),
                ('2', "Decal", ""),
                ('3', "Exterior", ""),
                ('4', "Interior", ""),
                ('5', "Prop", ""),
                ('6', "Structure", ""),
                ('7', "Vehicle", ""),
                ('8', "Weapon", ""),            
        ]
    )
    #Classifications--------------------------
    classification_enum : bpy.props.EnumProperty(
        name="Class",
        description="Select Classification",
        items=[
                ('0', "None", ""),
                ('1', "Character", ""),
                ('2', "Decal", ""),
                ('3', "Exterior", ""),
                ('4', "Interior", ""),
                ('5', "Prop", ""),
                ('6', "Structure", ""),
                ('7', "Vehicle", ""),
                ('8', "Weapon", ""),            
        ]    
    )
    #Standardization---------------------------
    standardization_enum : bpy.props.EnumProperty(
        name="Standard",
        description="Select Standardization",
        items=[
                ('0', "None", ""),
                ('1', "Character", ""),
                ('2', "Decal", ""),
                ('3', "Exterior", ""),
                ('4', "Interior", ""),
                ('5', "Prop", ""),
                ('6', "Structure", ""),
                ('7', "Vehicle", ""),
                ('8', "Weapon", ""),            
        ]
            
    )
    

##-----------------------------------------------S--------------------------------------------------------------


class MESH_OT_add_subdiv_monkey(bpy.types.Operator):
    """Create Something"""
    
    bl_idname = "mesh.add_unity_attributes"
    bl_label = "Add Properties"

    def execute(self, context):
    
        bpy.context.object["01 - Object Tag"]       = str(bpy.context.scene.my_tool.tag_enum)
        bpy.context.object["02 - Object Layer"]     = str(bpy.context.scene.my_tool.layer_enum)
        bpy.context.object["03 - Object Type"]      = str(bpy.context.scene.my_tool.type_enum)
        bpy.context.object["04 - Attribute"]        = str(bpy.context.scene.my_tool.attribute_enum)
        bpy.context.object["05 - Component"]        = str(bpy.context.scene.my_tool.component_enum)
        bpy.context.object["06 - Interact"]         = str(bpy.context.scene.my_tool.interact_enum)
        
        bpy.context.object["07 - Category"]         = int(bpy.context.scene.my_tool.category_enum)
        bpy.context.object["08 - SubCategory"]      = int(bpy.context.scene.my_tool.subcategory_enum)
        bpy.context.object["09 - Classification"]   = int(bpy.context.scene.my_tool.classification_enum)
        bpy.context.object["10 - Standardization"]  = int(bpy.context.scene.my_tool.standardization_enum)

        bpy.context.object["Generate Prefab"] = True              
        
                
        return{"FINISHED"}
        



##-------------------------------------------------------------------------------------------------------------


class VIEW3D_PT_my_custom_panel(bpy.types.Panel):  # class naming convention ‘CATEGORY_PT_name’

    # where to add the panel in the UI
    bl_space_type = "VIEW_3D"  # 3D Viewport area (find list of values here https://docs.blender.org/api/current/bpy_types_enum_items/space_type_items.html#rna-enum-space-type-items)
    bl_region_type = "UI"  # Sidebar region (find list of values here https://docs.blender.org/api/current/bpy_types_enum_items/region_type_items.html#rna-enum-region-type-items)

    bl_category = "Flow Panel"  # found in the Sidebar
    bl_label = "Unity Attributes Panel"  # found at the top of the Panel

    def draw(self, context):
        
        layout  = self.layout
        scene   = context.scene
        tool    = scene.my_tool 
        
        #Unity Settings---------------------------------------------        
        tag     = layout.prop(tool, "tag_enum")
        layer   = layout.prop(tool,"layer_enum")
        att     =  layout.prop(tool, "attribute_enum")
        com     =  layout.prop(tool, "component_enum")
        int     =  layout.prop(tool, "interact_enum")   

        #Origanization----------------------------------------------
        type    = layout.prop(tool, "type_enum")
        
        cat     =  layout.prop(tool, "category_enum")
        sct     =  layout.prop(tool, "subcategory_enum")
        
        cla     =  layout.prop(tool, "classification_enum")
        sta     =  layout.prop(tool, "standardization_enum")

        #Add Collider-----------------------------------------------
        split = layout.split()
        
        col = split.column(align=True)
        col.label(text="Asset Setup:")
        col.operator("object.empty_add", text="Add Custom Collider", icon="SELECT_INTERSECT")
                
        #Creation Settings------------------------------------------
        #row = layout.row()
        col = split.column(align=True)
        col.label(text="")
        col.operator("object.empty_add", text="Place Locator", icon="OUTLINER_OB_EMPTY")

        row = layout.row()
        row.operator("mesh.primitive_ico_sphere_add", text="Set Component", icon="COLLECTION_NEW")
        
        row.operator("object.shade_smooth", text="Create Prefab", icon="PACKAGE")
        
        row = layout.row()
        row.operator("mesh.add_unity_attributes", text="Set Attributes", icon="COPY_ID")
        
        layout.separator()
        
        row = layout.row(align=True)
        row.operator("object.shade_smooth", text="Send to Unity", icon="CON_TRACKTO")
        row.operator("object.shade_smooth", text="Return to Unity", icon="FILE_REFRESH")
        

        
##-------------------------------------------------------------------------------------------------------------


classes = [Attributes, MESH_OT_add_subdiv_monkey, VIEW3D_PT_my_custom_panel]
        


def register():
    for clas in classes:
        bpy.utils.register_class(clas)
    
    
    bpy.types.Scene.my_tool = bpy.props.PointerProperty(type=Attributes)


def unregister():
    for clas in classes:
        bpy.utils.unregister_class(clas)
        del  bpy.types.Scene.my_tool

if __name__ == "__main__":
    register()
    
    
    
##-------------------------------------------------------------------------------------------------------------

