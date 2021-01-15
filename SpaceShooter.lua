-- title:  SpaceShooter
-- author: Kesitem
-- desc:   A simple shoot'em up
-- script: lua

Game = {
	state = "INIT"
}

Player = {

	position = {
		x = 116,
		y = 120
	},
	speed = 1.75,
	moveX = 0,
	sprite = 0,
	centerShooter = {
		x = 4,
		y = 0
	},
	maxBullets = 10,
	bullets = {}
}

Enemies = {
	descriptions = {
		{
			name="SlowOne",
			sprite=16,
			speed=1
		}
	},
	maxEnemies = 10,
	enemies = {}
}


function initialize()
	createPlayer()
	Enemies.enemies[1] = createEnemy()
	Game.state = "RUN"
end -- initialize

function createPlayer()
end

function createPlayerBullet ()
	local bullet = {}
	bullet.position = {}
	bullet.position.x = 0
	bullet.position.y = 0
	bullet.speed = 3
	bullet.color = 4
	bullet.enable = false
	return bullet
end -- createPlayerBullet

function createEnemy()
	local enemy = {}
	enemy.position = {}
	enemy.position.x =  (math.random(30) - 1) * 8
	enemy.position.y = 0
	enemy.size = {}
	enemy.size.x = 8
	enemy.size.y = 8
	enemy.sprite = 16
	enemy.enable = true
	return enemy
end -- createEnemy

function movePlayerShip()
	Player.moveX = 0	
	if(btn(2) and Player.position.x > 0) then
		Player.position.x =	Player.position.x - Player.speed
		Player.moveX = -1
	end
	if(btn(3) and Player.position.x < 232) then
		Player.position.x =	Player.position.x + Player.speed
		Player.moveX = Player.moveX + 1
	end
	if(btn(0) and Player.position.y > 0) then
		Player.position.y = Player.position.y - Player.speed
	end
	if(btn(1) and Player.position.y < 124) then
		Player.position.y =  Player.position.y + Player.speed
	end
end -- movePlayerShip()

function movePlayerBullets()
	for i = 1, #Player.bullets do
		if(Player.bullets[i].enable == true) then
			Player.bullets[i].position.y = Player.bullets[i].position.y - Player.bullets[i].speed
			if(Player.bullets[i].position.y < 0) then
				Player.bullets[i].enable = false
			end
		end
	end
end -- movePlayerBuffets

function moveEnemies()
end -- moveEnemies

function checkPLayerFiring()
	if( (btnp(4))) then
		local numBullets = #(Player.bullets)
		local bulletIndex = -1
		local bullet = nil
		if(numBullets < Player.maxBullets) then
			bullet = createPlayerBullet()
			bulletIndex = numBullets + 1
		else
			for i = 1, numBullets do
				if(Player.bullets[i].enable == false) then
					bulletIndex = i
					bullet = Player.bullets[i]
				end
			end
		end
		if( bulletIndex ~= -1) then
				bullet.position.x = Player.position.x + Player.centerShooter.x
				bullet.position.y = Player.position.y + Player.centerShooter.y
				bullet.enable = true
				Player.bullets[bulletIndex] = bullet
				sfx(0, 'C-4', 5, 0, 14, 1)
		end
	end
end -- checkPLayerFiring

function checkPointRectangleCollision(pointPos, rectPos, rectSize)
	if(	pointPos.x >= rectPos.x and
		pointPos.x <= rectPos.x + rectSize.x and
		pointPos.y >= rectPos.y and
		pointPos.y <= rectPos.y + rectSize.y ) then
	 	return true
	end
	return false
end

function checkPlayerBulletsCollision()
	for i = 1, #Player.bullets do
		if(Player.bullets[i].enable == true) then
			for j = 1, #Enemies.enemies do
				if(Enemies.enemies[j].enable == true) then
					if(checkPointRectangleCollision(Player.bullets[i].position, Enemies.enemies[j].position, Enemies.enemies[j].size)) then
						collidePlayerBulletAndEnemy(i, j)
					end
				end
			end
		end
	end
end -- checkPlayerBulletsCollision

function collidePlayerBulletAndEnemy(bulletIndex, enemyIndex)
	trace("BOOM")
	Player.bullets[bulletIndex].enable = false
	Enemies.enemies[enemyIndex].enable = false
end -- collidePlayerBulletAndEnemy

function renderPlayerShip()

	if(Player.moveX == -1) then
		Player.sprite = 2
	end
	if (Player.moveX == 1) then
		Player.sprite = 1
	end
	if(Player.moveX == 0) then
		Player.sprite = 0
	end
	spr(Player.sprite, Player.position.x, Player.position.y, 0)

end -- renderPlayerShip

function  renderPlayerBullets()

	for i = 1, #(Player.bullets) do
		if(Player.bullets[i].enable == true) then
			pix(Player.bullets[i].position.x, Player.bullets[i].position.y, Player.bullets[i].color)
		end
	end

end -- renderGame

function renderEnemies()

	for i = 1, #Enemies.enemies do
		if(Enemies.enemies[i].enable == true) then
			spr(Enemies.enemies[i].sprite, Enemies.enemies[i].position.x, Enemies.enemies[i].position.y, 0)
		end
	end
end -- renderEnemies

function TIC()

	if(Game.state == "INIT") then
		initialize()
	end

	cls()
	
	movePlayerShip()
	movePlayerBullets()
	moveEnemies();

	checkPLayerFiring()
	checkPlayerBulletsCollision()

	renderEnemies()
	renderPlayerBullets()
	renderPlayerShip()

end

-- <TILES>
-- 000:000ee000000ee00000feef0000faaf000eeaaee00feddef0efeddefeefeddefe
-- 001:0000ee000000ee00000fee00000faa0000eeaae000fedde00efedddf0efedddf
-- 002:00ee000000ee000000eef00000aaf0000eaaee000eddef00fdddefe0fdddefe0
-- 016:0566665006777760567777655575575556666665066006600660066005000050
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- 003:00000000034455954580500534666000
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000000000
-- </SFX>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

-- <COVER>
-- 000:284000007494648393160f00880077000012ffb0e45445353414055423e2033010000000129f40402000ff00c2000000000f00880078a1c1c265c66833c375146a6f490b2c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080ff001080c1840b0a1c388031a2c58c0b1a3c780132a4c9841b2a5cb88133a6cd8c1b3a7cf80234a8c1942b4a9c398235aac59c2b5abc790336acc9943b6adcb98337aecd9c3b7afcf90438a0d1a44b8a1d3a8439a2d5ac4b9a3d7a053aa4d9a45baa5dba853ba6ddac5bba7dfa063ca8d1b46bca9d3b863daad5bc6bdabd7b073eacd9b47beaddbb873faeddbc7bfafdfb0830b0e1c48b0b1e3c8831b2e5cc8b1b3e7c0932b4e9c49b2b5ebc8933b6edcc9b3b7efc0a34b8e1d4ab4b9e3d8a35bae5dcab5bbe7d0b36bce9d4bb6bdebd8b37beeddcbb7bfefd0c38b0f1e4cb8b1f3e8c39b2f5eccb9b3f7e0d3ab4f9e4dbab5fbe8d3bb6fdecd5660800dd32e7c4f0ff050c77104eb1a0810300d7a758fd9df8f7f80dc3102010cd3df289f30cdfefbf1f76f1e76e50860e1880628a0e28c0638e0e380164821e484165861e5881668a1e68c1678e1e7885504000b3
-- </COVER>

