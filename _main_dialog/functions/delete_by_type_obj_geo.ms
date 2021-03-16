for i in objects where classOf i == box do delete i
for i in objects where classOf i == plane do delete i
for i in objects where classOf i == tube do delete i
for i in objects where classOf i == cylinder do delete i
for i in objects where classOf i == sphere do delete i
select(for o in geometry where classOf o != o do delete o) 
