
function sizeOf(matrix)
	 local size = 0
	 for _ in pairs(matrix) do size = size + 1 end
	 return size
end

function string:split(sep) --credit to lua user manual
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
 end

function make_int(matrix)
	 for i = 1, sizeOf(matrix) do
	     matrix[i] = tonumber(matrix[i])
	 end
	 return matrix
end

function parseFile(f)
	 local lines = {}
	 local s = 0
	 local n = "pic.png"
	 for line in io.lines(f) do
	     table.insert(lines, line)
	     s = s + 1
	 end
	 for i = 1, s do
	     local temp 
	     ln = lines[i]:split(" ")

	     if (ln[1] == "line") then
	     	args = lines[i+1]:split(" ")
	     	addEdge(eMatrix, args[1], args[2],args[3],args[4],args[5],args[6])
	
	     elseif (ln[1] == "ident") then
	     	    identify(tMatrix)
	
	     elseif (ln[1] == "scale") then
	     	    args = lines[i+1]:split(" ")
		    tMatrix = matrixMult(scale(args[1], args[2], args[3]), tMatrix)
	
	     elseif (ln[1] == "move") then 
	     	    args = lines[i+1]:split(" ")
	     	    tMatrix = matrixMult(translate(args[1], args[2],args[3]), tMatrix)
	
	     elseif (ln[1] == "rotate") then
	     	    args = lines[i+1]:split(" ")
	     	    tMatrix = matrixMult(rotate(args[1], math.rad(args[2])), tMatrix)
		   		  
             elseif (ln[1] == "apply") then
	     	    eMatrix = matrixMult(tMatrix, eMatrix)
	
	     elseif (ln[1] == "save") then
	     	    args = lines[i+1]:split(" ")
		    save(board)
		    n = args[1]
		    os.execute("convert line.ppm " .. n) 
	
	     elseif (ln[1] == "display") then
	     	    clear_screen(board)
	     	    draw(board, eMatrix)
	     	    save(board)
	     	    local a = "display line.ppm" 
		    print(a)
	     	    os.execute(a) 
	
	     elseif (ln[1] == "circle") then
	     	    args = lines[i+1]:split(" ")
		    circle(args[1], args[2], args[3], args[4])	
	    	
	     elseif (ln[1] == "hermite" or ln[1] == "bezier") then
	     	    args = lines[i+1]:split(" ")
		    add_curve(args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8], ln[1])

	     elseif (ln[1] == "clear") then
	     	    eMatrix = {{},{},{},{}}
	     elseif (ln[1] == "sphere") then
	     	     	    
	     elseif (ln[1] == "torus") then

	     elseif (ln[1] == "box") then
	     	    args = lines[i+1]:split(" ")
		    add_box(args[1],args[2],args[3],args[4],args[5],args[6])
	     end
 	 end
end

--parseFile("commands")