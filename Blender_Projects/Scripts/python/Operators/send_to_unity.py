import bpy


class SendToUnity(bpy.types.Operator):
    """Tooltip"""
    bl_idname = "object.send_to_unity"
    bl_label = "Send to Unity"



    @classmethod
    def poll(cls, context):
        return context.active_object is not None

    def execute(self, context):
        
        print("Something Happened")
        
        bpy.ops.machin3.prepare_unity_export(prepare_only=False)

            
        return {'FINISHED'}


def menu_func(self, context):
    self.layout.operator(self.bl_idname, text=self.bl_label)


# Register and add to the "object" menu (required to also use F3 search "Simple Object Operator" for quick access).
def register():
    bpy.utils.register_class(SendToUnity)
    #bpy.types.VIEW3D_MT_object.append(menu_func)


def unregister():
    bpy.utils.unregister_class(SendToUnity)
    #bpy.types.VIEW3D_MT_object.remove(menu_func)


if __name__ == "__main__":
    register()
