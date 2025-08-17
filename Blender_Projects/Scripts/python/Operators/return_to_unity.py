import bpy


class ReturnToUnity(bpy.types.Operator):
    """Tooltip"""
    bl_idname = "object.return_to_unity"
    bl_label = "Return to Unity"

    def execute(self, context):
        
        print("Something Happened")
        
        
        bpy.ops.machin3.restore_unity_export()


        
        
        return {'FINISHED'}


def menu_func(self, context):
    self.layout.operator(ReturnToUnity.bl_idname, text=ReturnToUnity.bl_label)


# Register and add to the "object" menu (required to also use F3 search "Simple Object Operator" for quick access).
def register():
    bpy.utils.register_class(ReturnToUnity)
    #bpy.types.VIEW3D_MT_object.append(menu_func)


def unregister():
    bpy.utils.unregister_class(ReturnToUnity)
    #bpy.types.VIEW3D_MT_object.remove(menu_func)


if __name__ == "__main__":
    register()
