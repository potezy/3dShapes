--globals
XRES = 500
YRES = 500
step = .01
MAX_COLOR = 255

--object to store color
Color = {red = 0, green = 0 , blue = 0}

--constructors 
function Color:new ( r , g ,b )
	 local color = {}
	 setmetatable(color , self)
	 self.__index = self 
	 self.red = r 
	 self.green = g
	 self.blue = b
	 return color
end

--create the array to store pixels 
board = {}
for i = 0, XRES-1 do
    board[i] = {}
    for k = 0, YRES -1 do
    	board[i][k] = Color:new(0,0,0)
    end
end



--function to draw line
function draw_line(x0 , y0 , x1, y1 , c , s)
	 if (x0>x1) then
	    xt = x0 	   
	    yt = y0
	    x0 = x1
	    y0 = y1
	    x1 = xt
	    y1 = yt
	 end
	 x = x0
	 y = y0
	 A = 2*(y1-y0)
	 B = -2*(x1 - x0)
	    if (math.abs(x1-x0) >= math.abs(y1-y0)) then
	       if (A > 0) then
	       	  D = A + B/2
	       	  while (x <x1) do
	       	     	plot(s,c,x,y)
			if ( D >0) then	
			   y = y +1  
		     	   D = D + B
			end
			x = x +1
			D = D + A
		  end
		  plot(s , c , x , y)
	       else D = A - B/2
	       	    while (x < x1) do
		    	  plot(s,c,x,y)
			  if (D<0) then
			     y = y -1
			     D = D - B
			  end
			  x = x +1
			  D = D + A
		    end
		    plot(s,c,x,y)
	       end
	    else
		if (A > 0) then
		   D = A/2 + B
		   while ( y < y1) do
		   	 plot( s , c , x ,y)
			 if ( D < 0) then
			    x = x + 1
			    D = D + A
	    	   	 end
			 y = y +1
			 D = D + B
		   end
	 	   plot( s , c , x ,y)
		else D = A/2 - B
		     while (y > y1) do
		     	   plot(s,c,x,y)
			   if  (D > 0) then
			       x = x +1
			       D = D + A
			   end
			   y = y -1
			   D = D - B
		     end
		     plot(s,c,x,y)
		end
	
	   end	
	
end



function draw(board, eMatrix)
	 for i = 1 , sizeOf(eMatrix[1]) , 2 do
	     local x1 = math.floor(eMatrix[1][i])
	     local x2 = math.floor(eMatrix[1][i+1])
	     local y1 = math.floor(eMatrix[2][i])
	     local y2 = math.floor(eMatrix[2][i+1])
	     --print(x1,y1,x2,y2)
	     color = Color:new((x1+x2)%255, (y1+y2)%255, (x1+x2+y1+y2)%255)
	     draw_line(x1,y1,x2,y2,color,board)
	 end
	 --printMatrix(eMatrix)
end

function addPoint(matrix, x,y,z)
	 table.insert(matrix[1],x) 	 
	 table.insert(matrix[2],y)
	 table.insert(matrix[3],z)
	 table.insert(matrix[4],1)
end

function addEdge(pMatrix, x1,y1,z1,x2,y2,z2)
	 addPoint(pMatrix,x1,y1,z1)
	 addPoint(pMatrix,x2,y2,z2)
end

function add_curve(x0,y0,x1,y1,x2,y2,x3,y3,t)
	 local xcoef,ycoef,xcor0,ycor0,xcor1,ycor1
	 xcoef , ycoef = coef(x0,y0,x1,y1,x2,y2,x3,y3,t)
	 xcor0 = xcoef[4][1]
	 ycor0 = ycoef[4][1]
	 for t = 0, 1 ,step do
	     xcor1 = xcoef[1][1] * t^3 + xcoef[2][1] * t^2 +xcoef[3][1] *t + xcoef[4][1]
	     ycor1 = ycoef[1][1] * t^3 + ycoef[2][1] * t^2 +ycoef[3][1] *t + ycoef[4][1]
	     addEdge(eMatrix, xcor0,ycor0,0,xcor1,ycor1,0)
	     xcor0 = xcor1
	     ycor0 = ycor1
	 end
end

function circle(cx , cy , cz , r)
	 print("potato")
	 local step = .01
	 local xcor, ycor, xcor0, ycor0
	 xcor0 = r + cx --first point
	 ycor0 = cy     --first point
	 for t = 0, 1+step, step do
	     theta = 2 * pi * t
	     xcor1 = r * cos(theta) + cx
	     ycor1 = r * sin(theta) + cy
	     addEdge(eMatrix, xcor0 , ycor0 , 0 , xcor1 , ycor1, 0)
	     ycor0 = ycor1
	     xcor0 = xcor1
	 end
	 
end

function add_box(x , y , z , width , height, depth)
	 addEdge(eMatrix, x, y, z, x, y, z)--upper left
	 addEdge(eMatrix, x+width, y, z, x+width, y, z)--upper right
	 addEdge(eMatrix, x, y-height, z, x, y-height, z)--lower left
	 addEdge(eMatrix, x+width, y-height, z, x+width, y-height, z)--lower right
	 addEdge(eMatrix, x, y, z-depth, x, y, z-depth)
	 addEdge(eMatrix, x+width, y, z-depth, x+width, y, z-depth)
	 addEdge(eMatrix, x, y-height,z-depth,x,y-height,z-depth)
	 addEdge(eMatrix, x+width, y-height,z-depth,x+width,y-height,z-depth)
end

function add_sphere(cx , cy , cz , r )
	 local sphere_points, x , y , z
	 sphere_points = generate_sphere(cx,cy,cz,r)
	 --print(sizeOf(sphere_points[1]))
	 for i = 1, sizeOf(sphere_points[1]) do
	     x = sphere_points[1][i]
	     y = sphere_points[2][i]
	     z = sphere_points[3][i]
	     --print(x,y,z)
	     addEdge(eMatrix, x,y,z,x,y,z)
	 end
end
function generate_sphere(cx , cy , cz , r)
         local rot,circ,x,y,z, point_matrix
         point_matrix = makeMatrix(4,4)
         for rot = 0, 1 + step, step do
             for circ = 0, 1 +step, step do
                 x = r * cos(circ * pi) + cx
                 y = r * sin(circ * pi) * cos(rot * 2 * pi) + cy
                 z = r * sin(circ * pi) * sin(rot * 2 * pi) + cz
                 addPoint(point_matrix, x,y,z)
             end
         end
         return point_matrix
end



function add_torus(cx , cy , cz , r1 , r2)
	 local x ,y,z,points
	 points  = generate_torus(cx,cy,cz,r1,r2)
	 for i = 1, sizeOf(points[1]) do
	     x = points[1][i]
	     y = points[2][i]
	     z = points[3][i]
	     addEdge(eMatrix,x,y,z,x,y,z)
	 end
end

function generate_torus(cx , cy , cz , r1 , r2)
	 local rot,circ,x,y,z, torus_points
	 torus_points = makeMatrix(4,4)
	 for rot = 0, 1 + step, step do
	     for circ = 0, 1 + step, step do
	     	 x = cos(rot * 2 * pi) * (r1 * cos(circ * 2 * pi) + r2) + cx
		 y = r1 * sin(circ * 2 * pi) + cy
		 z = -1 * sin(rot * 2 * pi) * (r1 * cos(circ * 2 * pi) + r2) + cz
		 addPoint(torus_points, x ,y ,z)
	      end
	 end
	 return torus_points
end


