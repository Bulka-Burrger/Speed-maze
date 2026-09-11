function love.load()
	love.window.setMode(1024, 768, {vsync= 1, resizable = true, minwidth = 640, minheight = 480})
	love.window.setTitle("Speed maze")
	boxes = {}
	boxes[1] = {0,0}
	boxes[2] = {0,0}
	level = #boxes - 1
	score = 0
    startGame()
end

function love.update(dt)
	mx, my = love.mouse.getPosition()
	wid, hei = love.window.getMode()
	if wid > hei then
		gbox = hei*0.95
	else
		gbox = wid+0.95
	end
	gap = gbox/((#boxes)*4 + #boxes+1)

	for i,v in ipairs(boxes) do
		for j,w in ipairs(v) do
			if collision(((wid-gbox)/2)+gap+(gap*5*(i-1)),((hei-gbox)/2)+gap+(gap*5*(j-1)),gap*4,gap*4,mx,my,0,0) and boxes[i][j] > 0 then
				boxes[i][j] = 2
			end
		end
	end
    if isClear() then
        local ran = 0
        score = score + 1
        if score%5==0 then
            plus()
        end
        by,bx = boxTouch()
        if bx == 1 then
            while not bx == #boxes do
                ran = love.math.random(3)
                if ran == 1 then
                    bx = bx + 1
                    boxes[bx][by] = 1
                elseif ran == 2 and by > 1 then
                    by = by - 1
                    boxes[bx][by] = 1
                elseif ran == 3 and by < #boxes then
                    by = by + 1
                    boxes[bx][by] = 1
                end
            end
        else
            while not bx == 1 do
                ran = love.math.random(3)
                if ran == 1 then
                    bx = bx - 1
                    boxes[bx][by] = 1
                elseif ran == 2 and by > 1 then
                    by = by - 1
                    boxes[bx][by] = 1
                elseif ran == 3 and by < #boxes then
                    by = by + 1
                    boxes[bx][by] = 1
                end
            end
        end
    end
end

function love.draw()
	love.graphics.setColor(218/255,221/255,210/255)
	love.graphics.rectangle("fill",0,0,wid,hei)
	love.graphics.setColor(230/225,238/225,231/225)
	love.graphics.rectangle("fill",(wid-gbox)/2,(hei-gbox)/2,gbox,gbox,5,5)

	for i,v in ipairs(boxes) do
		for j,w in ipairs(v) do
			if w == 0 then
				love.graphics.setColor(149/225,162/225,135/225)
			elseif w == 1 then
				love.graphics.setColor(213/225,189/225,166/225)
			elseif w == 2 then
				love.graphics.setColor(189/225,148/225,112/225)
			else
				love.graphics.setColor(189/225,148/225,112/225)
			end
			love.graphics.rectangle("fill",((wid-gbox)/2)+gap+(gap*5*(i-1)),((hei-gbox)/2)+gap+(gap*5*(j-1)),gap*4,gap*4,5,5)
		end
	end
end

function collision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function startGame()
    boxes[#boxes][#boxes] = 3
end

function isClear()
    clear = true
    for i,v in ipairs(boxes) do
        for j,w in ipairs(v) do
            if w == 1 or w > 2 then
                clear = false
            end
            if not clear then
                break
            end
        end
        if not clear then 
            break
        end
    end
    return clear

end
function plus()
    local x,y = 0,0
    local b = #boxes +1
    for i=1,b do
        boxes[i] = {}
        for j=1,b do
            boxes[i][j] = 0
        end
    end
    x,y = boxTouch()
    boxes[x][y] = 1 
end
function boxTouch()
    local x,y = 0,0
    for i,v in ipairs(boxes) do
        for j,w in ipairs(v) do
            if collision(((wid-gbox)/2)+gap+(gap*5*(i-1)),((hei-gbox)/2)+gap+(gap*5*(j-1)),gap*4,gap*4,mx,my,0,0) then
                x,y = i,j
            end
        end
    end
    return x,y
end
