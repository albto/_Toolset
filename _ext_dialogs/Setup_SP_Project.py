

texture_set_name = ["01_Head", "02_Body", "03_Base"]

dict_sample = {
    "first": texture_set_name[0],
    "second" : texture_set_name[1]
}


def print_texture_set_names ():
    #print (f"{texture_set_name[0]}")

    for i, value in dict_sample.items():
        print (f"name = {i} and the value is {value}") 


print_texture_set_names()

class CustomExporter:
    def __init__(self):
        self.tex_set_name = "head"

    def print_tex_set_name(self):
        print(self.tex_set_name)

exporter = CustomExporter()
exporter.print_tex_set_name()

import os 
dir_name = os.path.dirname(__file__)
print(dir_name)
print(__file__)






        
         










