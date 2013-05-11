function word(a, offset)
  local lo = a[offset]
  local hi = a[offset + 1]
  return hi*256 + lo
end
function dword(a, offset)
  local lo = word(a, offset)
  local hi = word(a, offset + 2)
  return hi*65536 + lo
end
function pixel(a,offset,x,y, bw, bh)
  datalength = #a--offset + (bw * bh * 3)

	bytes_width = (bw * 3)
	while ((bytes_width % 4) ~= 0) do
		bytes_width = bytes_width + bytes_width % 4;
	end
	pxoffset = datalength - (y * bytes_width)
	pxoffset = pxoffset - (bytes_width - x * 3)
	--[[print("bytesperline"..tostring(bytes_width))
	print("datalength"..tostring(datalength))
	print("offset"..tostring(offset))
	print("x"..tostring(x))
	print("y"..tostring(y))
	print("bw"..tostring(bw))
	print("bh"..tostring(bh))
	print("calcoffset"..tostring(pxoffset))]]--
	local r =  a[pxoffset + 3]
	local g =  a[pxoffset + 2]
	local b =  a[pxoffset+1]
	return r,g,b
end


h = fs.open("tw.bmp", "rb")

a = {}
db = 0
count = 0

while (db ~= nil) do
	db = h.read()
	count = count + 1
	a[count] = db
end
h.close()
local offset = 1
local type = word(a, offset)
if type ~= 0x4D42 then
	-- invalid BMP magic value (probably not a BMP)
	print("Invalid BMP magic value")
	return
end

offset = 15
local bw = dword(a, offset + 4)
local bh = dword(a, offset + 8)
local bits = word(a, offset + 14)
local comp = dword(a, offset + 16)
local offBits = dword(a, 11)

scr = peripheral.wrap("right")
scr.fill(0,0,0)

for y = 0, bh - 1, 1 do
	for x = 0, bw, 1 do
		local r,g,b = pixel(a, offBits, x,y, bw, bh)
		scr.plot(r,g,b, x + 1,y + 1)	
	end	
end
