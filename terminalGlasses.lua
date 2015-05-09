function rgbToHex(r,g,b)
	local color

	color = b
	color = bit.bor(color, bit.blshift(g, 8))
	color = bit.bor(color, bit.blshift(r, 16))

	return color
end

flhndl = fs.open("tw4.bmp","rb")
data = {}
while true do
	byt = flhndl.read()
	if(byt == nil) then break end
	table.insert(data,byt)
end
 
offset = data[11] + bit.blshift(data[12],8) + bit.blshift(data[13],16) + bit.blshift(data[14],24)
width = data[19] + bit.blshift(data[20],8) + bit.blshift(data[21],16) + bit.blshift(data[22],24)
height = data[23] + bit.blshift(data[24],8) + bit.blshift(data[25],16) + bit.blshift(data[26],24)
 
scr = peripheral.wrap("left")
--scr.addBox(1,1,100,100, 0x000000 , 0.2)
scr.clear()

bytesPerLine = width*3 + ((width*3) % 4)
lineNum = (#data-offset)/bytesPerLine
i = lineNum
while true do
	sleep(0)
	lineData = {}
	for j=1,width do
		pixel = {}
		r = data[bytesPerLine*(i-1)+(j*3)-0+offset]
		g = data[bytesPerLine*(i-1)+(j*3)-1+offset]
		b = data[bytesPerLine*(i-1)+(j*3)-2+offset]

		scr.addBox(j + 1,height - i  + 1,1,1, rgbToHex(r,g,b) , 1)
	end
	i = i - 1
	if(i == 0) then break end
end


scr.sync()
