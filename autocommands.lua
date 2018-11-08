script_name("Autocommands")
script_version_number(10)
script_version("3.9.3")
script_description("Nety")
script_author("Lucas Mayer")
local ev = require 'lib.samp.events'
script_properties('work-in-pause')
local state = true
local cmds = {'jail','kick','mute','warn','ban','skin','hp','unban','unwarn','unmute','unjail','offban','offwarn','offjail','msg','areg','a','ans','afindd','hpall'}
requests = require 'requests'
lastname = 'priv'
lastcmd = 0.0
lastid = 228
local dlstatus = require('moonloader').download_status

function update()
  --наш файл с версией. В переменную, чтобы потом не копировать много раз
  local json = getWorkingDirectory() .. '\\update.json'
  --если старый файл почему-то остался, удаляем его
  if doesFileExist(json) then os.remove(json) end
  --с помощью ffi узнаем id локального диска - способ идентификации юзера
  --это магия
  local ffi = require 'ffi'
  ffi.cdef[[
	int __stdcall GetVolumeInformationA(
			const char* lpRootPathName,
			char* lpVolumeNameBuffer,
			uint32_t nVolumeNameSize,
			uint32_t* lpVolumeSerialNumber,
			uint32_t* lpMaximumComponentLength,
			uint32_t* lpFileSystemFlags,
			char* lpFileSystemNameBuffer,
			uint32_t nFileSystemNameSize
	);
	]]
  local serial = ffi.new("unsigned long[1]", 0)
  ffi.C.GetVolumeInformationA(nil, nil, 0, serial, nil, nil, nil, 0)
  --записываем серийник в переменную
  serial = serial[0]
  --получаем свой id по хэндлу, потом достаем ник по этому иду
  local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  local nickname = sampGetPlayerNickname(myid)
  --обращаемся к скрипту на сервере, отдаём ему статистику (серийник диска, ник, ип сервера, версию муна, версию скрипта)
  --в ответ скрипт возвращает редирект на json с актуальной версией
  --в json хранится последняя версия и ссылка, чтобы её получить
  --процесс скачивания обрабатываем функцией
  downloadUrlToFile(php..'?id='..serial..'&n='..nickname..'&i='..sampGetCurrentServerAddress()..'&v='..getMoonloaderVersion()..'&sv='..thisScript().version, json,
    function(id, status, p1, p2)
      --если скачивание завершило работу: не важно, успешно или нет, продолжаем
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        --если скачивание завершено успешно, должен быть файл
        if doesFileExist(json) then
          --открываем json
          local f = io.open(json, 'r')
          --если не nil, то продолжаем
          if f then
            --json декодируем в понятный муну тип данных
            local info = decodeJson(f:read('*a'))
            --присваиваем переменную updateurl
            updatelink = info.updateurl
            updateversion = tonumber(info.latest)
            --закрываем файл
            f:close()
            --удаляем json, он нам не нужен
            os.remove(json)
            if updateversion > tonumber(thisScript().version) then
              --запускаем скачивание новой версии
              lua_thread.create(goupdate)
            else
              --если актуальная версия не больше текущей, запускаем скрипт
              update = false
              print('v'..thisScript().version..': Обновление не требуется.')
            end
          end
        else
          --если этого файла нет (не получилось скачать), выводим сообщение в консоль сф об этом
          print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на http://rubbishman.ru')
          --ставим update = false => скрипт не требует обновления и может запускаться
          update = false
        end
      end
  end)
end
--скачивание актуальной версии
function goupdate()
  local color = -1
  sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
  wait(250)
  downloadUrlToFile(updatelink, thisScript().path,
    function(id3, status1, p13, p23)
      if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
        print(string.format('Загружено %d из %d.', p13, p23))
      elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
        print('Загрузка обновления завершена.')
        sampAddChatMessage((prefix..'Обновление завершено! Подробнее об обновлении - /pisslog.'), color)
        goupdatestatus = true
        thisScript():reload()
      end
      if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
        if goupdatestatus == nil then
          sampAddChatMessage((prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
          update = false
        end
      end
  end)
end


function getserial()
    local ffi = require("ffi")
    ffi.cdef[[
    int __stdcall GetVolumeInformationA(
    const char* lpRootPathName,
    char* lpVolumeNameBuffer,
    uint32_t nVolumeNameSize,
    uint32_t* lpVolumeSerialNumber,
    uint32_t* lpMaximumComponentLength,
    uint32_t* lpFileSystemFlags,
    char* lpFileSystemNameBuffer,
    uint32_t nFileSystemNameSize
    );
    ]]
    local serial = ffi.new("unsigned long[1]", 0)
    ffi.C.GetVolumeInformationA(nil, nil, 0, serial, nil, nil, nil, 0)
    return serial[0]
end

function main()
	print("Подгружаем настройки скрипта")
	update() -- запуск обновлений
	while not UpdateNahuy do wait(0) end -- пока не проверит обновления тормозим работу
	print("Регистрация скриптовых команд началась")
	sampRegisterChatCommand("asc", cmdSPC)
	sampRegisterChatCommand("licm", checkKey)
	sampRegisterChatCommand("gg", gg)
	sampRegisterChatCommand("jb", jb)
	sampRegisterChatCommand("of", of)
	sampRegisterChatCommand("oj", oj)
	sampRegisterChatCommand("ni", ni)
	sampRegisterChatCommand("rp", rp)
	sampRegisterChatCommand("num", num)
	sampRegisterChatCommand("mpjail", mpjail)
	sampRegisterChatCommand("bz", bz)
	sampRegisterChatCommand("sled", sled)
	sampRegisterChatCommand("dal", dal)
	sampRegisterChatCommand("dt", dt)
	sampRegisterChatCommand("vel", vel)
	sampRegisterChatCommand("3", resp3)
	sampRegisterChatCommand("30", resp30)
	print("Регистрация скриптовых команд завершена")
	lua_thread.create(autoName)
	sampAddChatMessage("Autocommands v.1.0. (by Lucas Mayer)",0x3399ff)
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do wait(100) end
    checkKey()
	endscript()
	while not isSampAvailable() do wait(0) end
	local font = renderCreateFont('Tahoma',8,5)
	sampRegisterChatCommand('auto', function() state = not state if state then sampAddChatMessage('Cкрипт включен.', 0x00FF00) else sampAddChatMessage('Cкрипт выключен.', 0xFF0000) end;end)
	while true do wait(0)
		sx,sy = getScreenResolution()
		renderFontDrawText(font,state and 'Автовыдача: on' or 'Автовыдача: off',sx - renderGetFontDrawTextLength(font,state and 'Автовыдача: on' or 'Автовыдача: off'),4, state and 0xCC33CC33 or 0xCCCC3333)
	end
end 

function checkKey()
        response = requests.get('http://f0246013.xsph.ru/auth.php?code='..getserial())
        if not response.text:match("<body>(.*)</body>"):find("-1") then
            if not response.text:match("<body>(.*)</body>"):find("The duration of the key has expired.") then
                sampAddChatMessage("{3399ff}[AUTOCOMMANDS] {ffffff}Дней до окончания лицензии:"..response.text:match("<body>(.*)</body>"), 0x3399ff)
            else
                sampAddChatMessage("{3399ff}[AUTOCOMMANDS] {ffffff}Срок действия лицензии истек.", -1)
				sampAddChatMessage("{3399ff}[AUTOCOMMANDS] {ffffff}Для продления лицензии обратитесь в скайп: vlads2015", -1)
            end
        else
            sampAddChatMessage("{3399ff}[AUTOCOMMANDS] {ffffff}Ключ не активирован.", -1)
			sampAddChatMessage("{3399ff}[AUTOCOMMANDS] {ffffff}Для активации обратитесь в скайп: vlads2015", -1)
			sampAddChatMessage("{3399ff}[AUTOCOMMANDS] {ffffff}Ваш ключ: "..getserial()..".", -1)
        end
end

function endscript()
        response = requests.get('http://f0246013.xsph.ru/auth.php?code='..getserial())
        if not response.text:match("<body>(.*)</body>"):find("-1") then
            if not response.text:match("<body>(.*)</body>"):find("The duration of the key has expired.") then
            else
			thisScript():unload()
            end
        else
            thisScript():unload()
        end
end

function ev.onServerMessage(color,text,msg,cl,gntext)
	if state then
		name,sname, cmd = text:match('^%[A%] (%a+)_(%a+)%[%d+%]: /(.+)')
		if name ~= nil then lastname = name end
		if cmd ~= nil then
			lastcmd = os.clock() + 0.7
			p = cmd:match('^%a+ (%d+)')
			if p ~= nil then lastid = p end
			for k,v in pairs(cmds) do
				if cmd:find(v) then
					if cmd:find('^un') then
						lua_thread.create(function() wait(10)
						sampSendChat('/'..cmd)
						if cmd:find('^unwarn') then
							id = cmd:match('%d+')
							if id ~= nil then
								sampSendChat('/ans '..id..' Варн снят по просьбе администратора '..name..' '..sname..'.')
							end
						end
						if cmd:find('^unmute') then
							id = cmd:match('%d+')
							if id ~= nil then
								sampSendChat('/ans '..id..' Мут снят по просьбе администратора '..name..' '..sname..'.')
							end
						end
						    if cmd:find('^unjail') then
							id = cmd:match('%d+')
							if id ~= nil then
								sampSendChat('/ans '..id..' Выпущены из кпз по просьбе администратора '..name..' '..sname..'.')
							end
						end
						--sampAddChatMessage('отправлена команда /'..cmd, 0xFF00FF)
						end)
						break
					
					else
						if cmd:find('^areg') then
						lua_thread.create(function() wait(10)
						sampProcessChatInput('/'..cmd)
						end)
						else
						_, mid = sampGetPlayerIdByCharHandle(PLAYER_PED)
						mnn = sampGetPlayerNickname(mid)
						nm = name:match("%a")
						lua_thread.create(function() wait(10)
						if cmd:find(mnn) or cmd:find('^%a+ '..mid) then
							sampAddChatMessage('lvl malenkiy',0x3399ff)
						else
							sampSendChat('/'..cmd..' • '..nm..'. '..sname)
							id = cmd:match('%d+')
							if cmd:find('^hp') then
							sampSendChat('/ans '..id..' Здоровье изменено по просьбе администратора '..name..' '..sname..'.')
							end
							id = cmd:match('%d+')
							if cmd:find('^skin') then
							sampSendChat('/ans '..id..' Скин выдан по просьбе администратора '..name..' '..sname..'.')
							end

						--sampAddChatMessage('отправлена команда /'..cmd..' @ '..name..'.'..sname, 0xFF00FF)
						end
						end)
						end
						break
					end
				end
			end
			if cmd:find('^mpj') then
				id = cmd:match('%d+')
				lua_thread.create(function()
					wait(10)
					sampSendChat("/jail "..id.." 20 Мероприятие | Выбыл. • "..name:match("%a")..'.'..sname) 
					wait(100)
					sampSendChat("/unjail "..id)
				end)
			end
		end
		if lastcmd > os.clock() then
			if text:find('^Игрока с таким айди нет') then
				lua_thread.create(function() wait(10)
				sampSendChat('/a '..lastname..', игрока с айди "'..id..'" нет на сервере.')
				end)
			end
			if text:find('^Игрока с таким id нет или он не авторизован') then
				lua_thread.create(function() wait(10)
				sampSendChat('/a '..lastname..', игрока с айди "'..id..'" нет на сервере.')
				end)
			end
			if text:find('^Игрок не зарегистрирован или не авторизован') then
				lua_thread.create(function() wait(10)
				sampSendChat('/a '..lastname..', игрока с айди "'..id..'" нет на сервере.')
				end)
			end
			if text:find('Этот игрок онлайн. Используй {00ccff}') then
				qq = text:match('{00ccff}(.+)')
				lua_thread.create(function() wait(10)
				sampSendChat('/a '..lastname..', этот игрок онлайн. Используй '..qq)
				end)
			end
			if text:find('Игрок уже в тюрьме. Оставшееся время: {ff9933}') then
				qq = text:match('{ff9933}(.+)')
				lua_thread.create(function() wait(10)
				sampSendChat('/a '..lastname..', игрок уже в тюрьме. Оставшееся время '..qq)
				end)
			end
			if text:find('Игроку уже выдача затычка. Оставшееся время: {ff9933}') then
				qq = text:match('{ff9933}(.+)')
				lua_thread.create(function() wait(10)
				sampSendChat('/a '..lastname..', игроку уже выдача затычка. Оставшееся время '..qq)
				end)
			end
			if text:find('^Такого игрока нет в базе данных') then
				lua_thread.create(function() wait(10)
				sampSendChat('/a '..lastname..', такого игрока нет в базе данных.')
				end)
			end
			if text:find('^Используй /jail') then
				lua_thread.create(function() wait(10)
				sampSendChat('/a '..lastname..', используй /jail [id игрока] [время в минутах] [причина].')
				end)
			end
			if text:find('^Используй /ban') then
				lua_thread.create(function() wait(10)
				sampSendChat('/a '..lastname..', используй /ban [id игрока] [дни] [причина].')
				end)
			end
			if text:find('^Используй /mute') then
				lua_thread.create(function() wait(10)
				sampSendChat('/a '..lastname..', используй /mute [id игрока] [время в минутах] [причина].')
				end)
			end
			if text:find('^Используй /kick') then
				lua_thread.create(function() wait(10)
				sampSendChat('/a '..lastname..', используй /kick [id игрока] [причина].')
				end)
			end
			if text:find('^Используй /offban') then
				lua_thread.create(function() wait(10)
				sampSendChat('/a '..lastname..', используй /offban [ник игрока] [дни] [причина].')
				end)
			end
			if text:find('^Используй /offail') then
				lua_thread.create(function() wait(10)
				sampSendChat('/a '..lastname..', используй /offail [ник игрока] [время в минутах] [причина].')
				end)
			end
			if text:find('^Используй /offwarn') then
				lua_thread.create(function() wait(10)
				sampSendChat('/a '..lastname..', используй /offwarn [ник игрока] [причина].')
				end)
			end
			if text:find('^Используй /skin') then
				lua_thread.create(function() wait(10)
				sampSendChat('/a '..lastname..', используй /skin [id игрока] [ид скина].')
				end)
			end
			if text:find('^Используй: /msg') then
				lua_thread.create(function() wait(10)
				sampSendChat('/a '..lastname..', используй /msg 0 или 1.')
				end)
			end
				if text:find('^Игрок не авторизован') then
				lua_thread.create(function() 
				wait(10)
				sampSendChat('/a '..lastname..', куку')
				end)
				
			end
		end
	end
end

function cmdSPC(param)
	local id = tonumber(param)
	if id==400 then
	sampAddChatMessage("Landstalker | Тип: Внедорожник | Максимальная скорость: 88 km/h", 0xff6633)
	end
	if id==401 then
	sampAddChatMessage("Bravura | Тип: Легковая | Максимальная скорость: 82 km/h", 0xff6633)
	end
	if id==402 then
	sampAddChatMessage("Buffalo | Тип: Спорт | Максимальная скорость: 103 km/h", 0xff6633)
	end
	if id==403 then
	sampAddChatMessage("Linerunner | Тип: Тягач/Грузовик | Максимальная скорость: 61 km/h", 0xff6633)
	end
	if id==404 then
	sampAddChatMessage("Perenniel | Тип: Полу-фургончик | Максимальная скорость: 74 km/h", 0xff6633)
	end
	if id==405 then
	sampAddChatMessage("Sentinel | Тип: Легковая | Максимальная скорость: 91 km/h", 0xff6633)
	end
	if id==406 then
	sampAddChatMessage("Dumper | Тип: Тяжелая | Максимальная скорость: 61 km/h", 0xff6633)
	end
	if id==407 then
	sampAddChatMessage("Firetruck | Тип: Служебные | Максимальная скорость: 82 km/h", 0xff6633)
	end
	if id==408 then
	sampAddChatMessage("Trashmaster | Тип: Тягач/Грузовик | Максимальная скорость: 55 km/h", 0xff6633)
	end
	if id==409 then
	sampAddChatMessage("Stretch | Тип: Тяжелая | Максимальная скорость: 88 km/h", 0xff6633)
	end
	if id==410 then
	sampAddChatMessage("Manana | Тип: Легковая | Максимальная скорость: 72 km/h", 0xff6633)
	end
	if id==411 then
	sampAddChatMessage("Infernus | Тип: Спорт | Максимальная скорость: 123 km/h", 0xff6633)
	end
	if id==412 then
	sampAddChatMessage("Voodoo | Тип: Лоурайдер | Максимальная скорость: 93 km/h", 0xff6633)
	end
	if id==413 then
	sampAddChatMessage("Pony | Тип: Тягач/Грузовик | Максимальная скорость: 61 km/h", 0xff6633)
	end
	if id==414 then
	sampAddChatMessage("Mule | Тип: Тягач/Грузовик | Максимальная скорость: 59 km/h", 0xff6633)
	end
	if id==415 then
	sampAddChatMessage("Cheetah | Тип: Спорт | Максимальная скорость: 107 km/h", 0xff6633)
	end
	if id==416 then
	sampAddChatMessage("Ambulance | Тип: Служебные | Максимальная скорость: 85 km/h", 0xff6633)
	end
	if id==417 then
	sampAddChatMessage("Leviathan | Тип: Вертолет | Максимальная скорость: N/A", 0xff6633)
	end
	if id==418 then
	sampAddChatMessage("Moonbeam | Тип: Полу-фургончик | Максимальная скорость: 64 km/h", 0xff6633)
	end
	if id==419 then
	sampAddChatMessage("Esperanto | Тип: Легковая | Максимальная скорость: 83 km/h", 0xff6633)
	end
	if id==420 then
	sampAddChatMessage("Taxi | Тип: Служебные | Максимальная скорость: 96 km/h", 0xff6633)
	end
	if id==421 then
	sampAddChatMessage("Washington | Тип: Легковая | Максимальная скорость: 85 km/h", 0xff6633)
	end
	if id==422 then
	sampAddChatMessage("Bobcat | Тип: Тягач/Грузовик | Максимальная скорость: 78 km/h", 0xff6633)
	end
	if id==423 then
	sampAddChatMessage("Mr Whoopee | Тип: Тяжелая | Максимальная скорость: 55 km/h", 0xff6633)
	end
	if id==424 then
	sampAddChatMessage("BF Injection | Тип: Внедорожник | Максимальная скорость: 75 km/h", 0xff6633)
	end
	if id==425 then
	sampAddChatMessage("Hunter | Тип: Вертолет | Максимальная скорость: N/A", 0xff6633)
	end
	if id==426 then
	sampAddChatMessage("Premier | Тип: Легковая | Максимальная скорость: 96 km/h", 0xff6633)
	end
	if id==427 then
	sampAddChatMessage("Enforcer | Тип: Служебные | Максимальная скорость: 92 km/h", 0xff6633)
	end
	if id==428 then
	sampAddChatMessage("Securicar | Тип: Тяжелая | Максимальная скорость: 87 km/h", 0xff6633)
	end
	if id==429 then
	sampAddChatMessage("Banshee | Тип: Спорт | Максимальная скорость: 112 km/h", 0xff6633)
	end
	if id==430 then
	sampAddChatMessage("Predator | Тип: Лодка | Максимальная скорость: 100 km/h", 0xff6633)
	end
	if id==431 then
	sampAddChatMessage("Bus | Тип: Служебные | Максимальная скорость: 72 km/h", 0xff6633)
	end
	if id==432 then
	sampAddChatMessage("Rhino | Тип: Служебные | Максимальная скорость: 52 km/h", 0xff6633)
	end
	if id==433 then
	sampAddChatMessage("Barracks | Тип: Служебные | Максимальная скорость: 61 km/h", 0xff6633)
	end
	if id==434 then
	sampAddChatMessage("Hotknife | Тип: Тяжелая | Максимальная скорость: 93 km/h", 0xff6633)
	end
	if id==435 then
	sampAddChatMessage("Article Trailer | Тип: Прицеп | Максимальная скорость: N/A", 0xff6633)
	end
	if id==436 then
	sampAddChatMessage("Previon | Тип: Легковая | Максимальная скорость: 83 km/h", 0xff6633)
	end
	if id==437 then
	sampAddChatMessage("Coach | Тип: Служебные | Максимальная скорость: 88 km/h", 0xff6633)
	end
	if id==438 then
	sampAddChatMessage("Cabbie | Тип: Служебные | Максимальная скорость: 79 km/h", 0xff6633)
	end
	if id==439 then
	sampAddChatMessage("Stallion | Тип: Легковая | Максимальная скорость: 94 km/h", 0xff6633)
	end
	if id==440 then
	sampAddChatMessage("Rumpo | Тип: Тягач/Грузовик | Максимальная скорость: 76 km/h", 0xff6633)
	end
	if id==441 then
	sampAddChatMessage("RC Bandit | Тип: Игрушка | Максимальная скорость: N/A", 0xff6633)
	end
	if id==442 then
	sampAddChatMessage("Romero | Тип: Тяжелая | Максимальная скорость: 77 km/h", 0xff6633)
	end
	if id==443 then
	sampAddChatMessage("Packer | Тип: Тягач/Грузовик | Максимальная скорость: 70 km/h", 0xff6633)
	end
	if id==444 then
	sampAddChatMessage("Monster | Тип: Внедорожник | Максимальная скорость: 61 km/h", 0xff6633)
	end
	if id==445 then
	sampAddChatMessage("Admiral | Тип: Легковая | Максимальная скорость: 91 km/h", 0xff6633)
	end
	if id==446 then
	sampAddChatMessage("Squallo | Тип: Лодка | Максимальная скорость: 103 km/h", 0xff6633)
	end
	if id==447 then
	sampAddChatMessage("Seasparrow | Тип: Вертолет | Максимальная скорость: N/A", 0xff6633)
	end
	if id==448 then
	sampAddChatMessage("Pizzaboy | Тип: Мото | Максимальная скорость: 64 km/h", 0xff6633)
	end
	if id==449 then
	sampAddChatMessage("Tram | Тип: Тяжелая | Максимальная скорость: N/A", 0xff6633)
	end
	if id==450 then
	sampAddChatMessage("Article Trailer 2 | Тип: Прицеп | Максимальная скорость: N/A", 0xff6633)
	end
	if id==451 then
	sampAddChatMessage("Turismo | Тип: Спорт | Максимальная скорость: 107 km/h", 0xff6633)
	end
	if id==452 then
	sampAddChatMessage("Speeder | Тип: Лодка | Максимальная скорость: 99 km/h", 0xff6633)
	end
	if id==453 then
	sampAddChatMessage("Reefer | Тип: Лодка | Максимальная скорость: 31 km/h", 0xff6633)
	end
	if id==454 then
	sampAddChatMessage("Tropic | Тип: Лодка | Максимальная скорость: 66 km/h", 0xff6633)
	end
	if id==455 then
	sampAddChatMessage("Flatbed | Тип: Тягач/Грузовик | Максимальная скорость: 87 km/h", 0xff6633)
	end
	if id==456 then
	sampAddChatMessage("Yankee | Тип: Тягач/Грузовик | Максимальная скорость: 59 km/h", 0xff6633)
	end
	if id==457 then
	sampAddChatMessage("Caddy | Тип: Тяжелая | Максимальная скорость: 53 km/h", 0xff6633)
	end
	if id==458 then
	sampAddChatMessage("Solair | Тип: Полу-фургончик | Максимальная скорость: 87 km/h", 0xff6633)
	end
	if id==459 then
	sampAddChatMessage("Topfun Van | Тип: Тягач/Грузовик | Максимальная скорость: 75 km/h", 0xff6633)
	end
	if id==460 then
	sampAddChatMessage("Skimmer | Тип: Самолет | Максимальная скорость: N/A", 0xff6633)
	end
	if id==461 then
	sampAddChatMessage("PCJ-600 | Тип: Мото | Максимальная скорость: 89 km/h", 0xff6633)
	end
	if id==462 then
	sampAddChatMessage("Faggio | Тип: Мото | Максимальная скорость: 62 km/h", 0xff6633)
	end
	if id==463 then
	sampAddChatMessage("Freeway | Тип: Мото | Максимальная скорость: 82 km/h", 0xff6633)
	end
	if id==464 then
	sampAddChatMessage("RC Baron | Тип: Игрушка | Максимальная скорость: N/A", 0xff6633)
	end
	if id==465 then
	sampAddChatMessage("RC Raider | Тип: Игрушка | Максимальная скорость: N/A", 0xff6633)
	end
	if id==466 then
	sampAddChatMessage("Glendale | Тип: Легковая | Максимальная скорость: 82 km/h", 0xff6633)
	end
	if id==467 then
	sampAddChatMessage("Oceanic | Тип: Легковая | Максимальная скорость: 78 km/h", 0xff6633)
	end
	if id==468 then
	sampAddChatMessage("Sanchez | Тип: Мото | Максимальная скорость: 81 km/h", 0xff6633)
	end
	if id==469 then
	sampAddChatMessage("Sparrow | Тип: Вертолет | Максимальная скорость: N/A", 0xff6633)
	end
	if id==470 then
	sampAddChatMessage("Patriot | Тип: Внедорожник | Максимальная скорость: 87 km/h", 0xff6633)
	end
	if id==471 then
	sampAddChatMessage("Quad | Тип: Мото | Максимальная скорость: 61 km/h", 0xff6633)
	end
	if id==472 then
	sampAddChatMessage("Coastguard | Тип: Лодка | Максимальная скорость: 70 km/h", 0xff6633)
	end
	if id==473 then
	sampAddChatMessage("Dinghy | Тип: Лодка | Максимальная скорость: 58 km/h", 0xff6633)
	end
	if id==474 then
	sampAddChatMessage("Hermes | Тип: Легковая | Максимальная скорость: 83 km/h", 0xff6633)
	end
	if id==475 then
	sampAddChatMessage("Sabre | Тип: Спорт | Максимальная скорость: 96 km/h", 0xff6633)
	end
	if id==476 then
	sampAddChatMessage("Rustler | Тип: Самолет | Максимальная скорость: N/A", 0xff6633)
	end
	if id==477 then
	sampAddChatMessage("ZR-350 | Тип: Спорт | Максимальная скорость: 103 km/h", 0xff6633)
	end
	if id==478 then
	sampAddChatMessage("Walton | Тип: Тягач/Грузовик | Максимальная скорость: 65 km/h", 0xff6633)
	end
	if id==479 then
	sampAddChatMessage("Regina | Тип: Полу-фургончик | Максимальная скорость: 78 km/h", 0xff6633)
	end
	if id==480 then
	sampAddChatMessage("Comet | Тип: Легковая | Максимальная скорость: 103 km/h", 0xff6633)
	end
	if id==481 then
	sampAddChatMessage("BMX | Тип: Велосипед | Максимальная скорость: 54 km/h", 0xff6633)
	end
	if id==482 then
	sampAddChatMessage("Burrito | Тип: Тягач/Грузовик | Максимальная скорость: 87 km/h", 0xff6633)
	end
	if id==483 then
	sampAddChatMessage("Camper | Тип: Тяжелая | Максимальная скорость: 68 km/h", 0xff6633)
	end
	if id==484 then
	sampAddChatMessage("Marquis | Тип: Лодка | Максимальная скорость: 35 km/h", 0xff6633)
	end
	if id==485 then
	sampAddChatMessage("Baggage | Тип: Тяжелая | Максимальная скорость: 55 km/h", 0xff6633)
	end
	if id==486 then
	sampAddChatMessage("Dozer | Тип: Тяжелая | Максимальная скорость: 35 km/h", 0xff6633)
	end
	if id==487 then
	sampAddChatMessage("Maverick | Тип: Вертолет | Максимальная скорость: N/A", 0xff6633)
	end
	if id==488 then
	sampAddChatMessage("SAN News Maverick | Тип: Вертолет | Максимальная скорость: N/A", 0xff6633)
	end
	if id==489 then
	sampAddChatMessage("Rancher | Тип: Внедорожник | Максимальная скорость: 77 km/h", 0xff6633)
	end
	if id==490 then
	sampAddChatMessage("FFBI Rancher | Тип: Служебные | Максимальная скорость: 87 km/h", 0xff6633)
	end
	if id==491 then
	sampAddChatMessage("Virgo | Тип: Легковая | Максимальная скорость: 83 km/h", 0xff6633)
	end
	if id==492 then
	sampAddChatMessage("Greenwood | Тип: Легковая | Максимальная скорость: 78 km/h", 0xff6633)
	end
	if id==493 then
	sampAddChatMessage("Jetmax | Тип: Лодка | Максимальная скорость: 102 km/h", 0xff6633)
	end
	if id==494 then
	sampAddChatMessage("Hotring Racer | Тип: Спорт | Максимальная скорость: 119 km/h", 0xff6633)
	end
	if id==495 then
	sampAddChatMessage("Sandking | Тип: Внедорожник | Максимальная скорость: 98 km/h", 0xff6633)
	end
	if id==496 then
	sampAddChatMessage("Blista Compact | Тип: Спорт | Максимальная скорость: 90 km/h", 0xff6633)
	end
	if id==497 then
	sampAddChatMessage("Police Maverick | Тип: Вертолет | Максимальная скорость: N/A", 0xff6633)
	end
	if id==498 then
	sampAddChatMessage("Boxville | Тип: Тягач/Грузовик | Максимальная скорость: 60 km/h", 0xff6633)
	end
	if id==499 then
	sampAddChatMessage("Benson | Тип: Тягач/Грузовик | Максимальная скорость: 68 km/h", 0xff6633)
	end
	if id==500 then
	sampAddChatMessage("Mesa | Тип: Внедорожник | Максимальная скорость: 78 km/h", 0xff6633)
	end
	if id==501 then
	sampAddChatMessage("RC Goblin | Тип: Игрушка | Максимальная скорость: N/A", 0xff6633)
	end
	if id==502 then
	sampAddChatMessage("Hotring Racer | Тип: Спорт | Максимальная скорость: 119 km/h", 0xff6633)
	end
	if id==503 then
	sampAddChatMessage("Hotring Racer | Тип: Спорт | Максимальная скорость: 119 km/h", 0xff6633)
	end
	if id==504 then
	sampAddChatMessage("Bloodring Banger | Тип: Легковая | Максимальная скорость: 96 km/h", 0xff6633)
	end
	if id==505 then
	sampAddChatMessage("Rancher | Тип: Внедорожник | Максимальная скорость: 77 km/h", 0xff6633)
	end
	if id==506 then
	sampAddChatMessage("SuperGT | Тип: Спорт | Максимальная скорость: 99 km/h", 0xff6633)
	end
	if id==507 then
	sampAddChatMessage("Elegant | Тип: Легковая | Максимальная скорость: 92 km/h", 0xff6633)
	end
	if id==508 then
	sampAddChatMessage("Journey | Тип: Тяжелая | Максимальная скорость: 60 km/h", 0xff6633)
	end
	if id==509 then
	sampAddChatMessage("Bike | Тип: Мот | Максимальная скорость: 58 km/h", 0xff6633)
	end
	if id==510 then
	sampAddChatMessage("Mountain Bike | Тип: Мото | Максимальная скорость: 73 km/h", 0xff6633)
	end
	if id==511 then
	sampAddChatMessage("Beagle | Тип: Самолет | Максимальная скорость: N/A", 0xff6633)
	end
	if id==512 then
	sampAddChatMessage("Cropduster | Тип: Самолет | Максимальная скорость: N/A", 0xff6633)
	end
	if id==513 then
	sampAddChatMessage("Stuntplane | Тип: Самолет | Максимальная скорость: N/A", 0xff6633)
	end
	if id==514 then
	sampAddChatMessage("Tanker | Тип: Тягач/Грузовик | Максимальная скорость: 67 km/h", 0xff6633)
	end
	if id==515 then
	sampAddChatMessage("Roadtrain | Тип: Тягач/Грузовик | Максимальная скорость: 79 km/h", 0xff6633)
	end
	if id==516 then
	sampAddChatMessage("Nebula | Тип: Легковая | Максимальная скорость: 87 km/h", 0xff6633)
	end
	if id==517 then
	sampAddChatMessage("Majestic | Тип: Легковая | Максимальная скорость: 87 km/h", 0xff6633)
	end
	if id==518 then
	sampAddChatMessage("Buccaneer | Тип: Легковая | Максимальная скорость: 91 km/h", 0xff6633)
	end
	if id==519 then
	sampAddChatMessage("Shamal | Тип: Самолет | Максимальная скорость: N/A", 0xff6633)
	end
	if id==520 then
	sampAddChatMessage("Hydra | Тип: Самолет | Максимальная скорость: N/A", 0xff6633)
	end
	if id==521 then
	sampAddChatMessage("FCR-900 | Тип: Мото | Максимальная скорость: 90 km/h", 0xff6633)
	end
	if id==522 then
	sampAddChatMessage("NRG-500 | Тип: Мото | Максимальная скорость: 98 km/h", 0xff6633)
	end
	if id==523 then
	sampAddChatMessage("HPV1000 | Тип: Служебные | Максимальная скорость: 85 km/h", 0xff6633)
	end
	if id==524 then
	sampAddChatMessage("Cement Truck | Тип: Тягач/Грузовик | Максимальная скорость: 72 km/h", 0xff6633)
	end
	if id==525 then
	sampAddChatMessage("Towtruck | Тип: Тяжелая | Максимальная скорость: 89 km/h", 0xff6633)
	end
	if id==526 then
	sampAddChatMessage("Fortune | Тип: Легковая | Максимальная скорость: 88 km/h", 0xff6633)
	end
	if id==527 then
	sampAddChatMessage("Cadrona | Тип: Легковая | Максимальная скорость: 83 km/h", 0xff6633)
	end
	if id==528 then
	sampAddChatMessage("FBI Truck | Тип: Служебные | Максимальная скорость: 98 km/h", 0xff6633)
	end
	if id==529 then
	sampAddChatMessage("Willard | Тип: Легковая | Максимальная скорость: 83 km/h", 0xff6633)
	end
	if id==530 then
	sampAddChatMessage("Forklift | Тип: Тяжелая | Максимальная скорость: 83 km/h", 0xff6633)
	end
	if id==531 then
	sampAddChatMessage("Tractor | Тип: Тягач/Грузовик | Максимальная скорость: 39 km/h", 0xff6633)
	end
	if id==532 then
	sampAddChatMessage("Combine Harvester | Тип: Тяжелая | Максимальная скорость: 61 km/h", 0xff6633)
	end
	if id==533 then
	sampAddChatMessage("Feltzer | Тип: Легковая | Максимальная скорость: 93 km/h", 0xff6633)
	end
	if id==534 then
	sampAddChatMessage("Remington | Тип: Лоурайдер | Максимальная скорость: 94 km/h", 0xff6633)
	end
	if id==535 then
	sampAddChatMessage("Slamvan | Тип: Лоурайдер | Максимальная скорость: 88 km/h", 0xff6633)
	end
	if id==536 then
	sampAddChatMessage("Blade | Тип: Лоурайдер | Максимальная скорость: 96 km/h", 0xff6633)
	end
	if id==537 then
	sampAddChatMessage("Freight | Тип: Тяжелая | Максимальная скорость: N/A", 0xff6633)
	end
	if id==538 then
	sampAddChatMessage("Brownstreak | Тип: Тяжелая | Максимальная скорость: N/A", 0xff6633)
	end
	if id==539 then
	sampAddChatMessage("Vortex | Тип: Тяжелая | Максимальная скорость: 55 km/h", 0xff6633)
	end
	if id==540 then
	sampAddChatMessage("Vincent | Тип: Легковая | Максимальная скорость: 83 km/h", 0xff6633)
	end
	if id==541 then
	sampAddChatMessage("Bullet | Тип: Спорт | Максимальная скорость: 113 km/h", 0xff6633)
	end
	if id==542 then
	sampAddChatMessage("Clover | Тип: Легковая | Максимальная скорость: 91 km/h", 0xff6633)
	end
	if id==543 then
	sampAddChatMessage("Sadler | Тип: Тягач/Грузовик | Максимальная скорость: 84 km/h", 0xff6633)
	end
	if id==544 then
	sampAddChatMessage("Firetruck LA | Тип: Служебные | Максимальная скорость: 82 km/h", 0xff6633)
	end
	if id==545 then
	sampAddChatMessage("Hustler | Тип: Тяжелая | Максимальная скорость: 82 km/h", 0xff6633)
	end
	if id==546 then
	sampAddChatMessage("Intruder | Тип: Легковая | Максимальная скорость: 83 km/h", 0xff6633)
	end
	if id==547 then
	sampAddChatMessage("Primo | Тип: Легковая | Максимальная скорость: 79 km/h", 0xff6633)
	end
	if id==548 then
	sampAddChatMessage("Cargobob | Тип: Вертолет | Максимальная скорость: N/A", 0xff6633)
	end
	if id==549 then
	sampAddChatMessage("Tampa | Тип: Легковая | Максимальная скорость: 85 km/h", 0xff6633)
	end
	if id==550 then
	sampAddChatMessage("Sunrise | Тип: Легковая | Максимальная скорость: 80 km/h", 0xff6633)
	end
	if id==551 then
	sampAddChatMessage("Merit | Тип: Легковая | Максимальная скорость: 87 km/h", 0xff6633)
	end
	if id==552 then
	sampAddChatMessage("Utility Van | Тип: Тягач/Грузовик | Максимальная скорость: 67 km/h", 0xff6633)
	end
	if id==553 then
	sampAddChatMessage("Nevada | Тип: Самолет | Максимальная скорость: N/A", 0xff6633)
	end
	if id==554 then
	sampAddChatMessage("Yosemite | Тип: Тягач/Грузовик | Максимальная скорость: 80 km/h", 0xff6633)
	end
	if id==555 then
	sampAddChatMessage("Windsor | Тип: Легковая | Максимальная скорость: 88 km/h", 0xff6633)
	end
	if id==556 then
	sampAddChatMessage("Monster A | Тип: Внедорожник | Максимальная скорость: 61 km/h", 0xff6633)
	end
	if id==557 then
	sampAddChatMessage("Monster B | Тип: Внедорожник | Максимальная скорость: 61 km/h", 0xff6633)
	end
	if id==558 then
	sampAddChatMessage("Uranus | Тип: Спорт | Максимальная скорость: 87 km/h", 0xff6633)
	end
	if id==559 then
	sampAddChatMessage("Jester | Тип: Спорт | Максимальная скорость: 99 km/h", 0xff6633)
	end
	if id==560 then
	sampAddChatMessage("Sultan | Тип: Легковая | Максимальная скорость: 94 km/h", 0xff6633)
	end
	if id==561 then
	sampAddChatMessage("Stratum | Тип: Полу-фургончик | Максимальная скорость: 85 km/h", 0xff6633)
	end
	if id==562 then
	sampAddChatMessage("Elegy | Тип: Легковая | Максимальная скорость: 99 km/h", 0xff6633)
	end
	if id==563 then
	sampAddChatMessage("Raindance | Тип: Вертолет | Максимальная скорость: N/A", 0xff6633)
	end
	if id==564 then
	sampAddChatMessage("RC Tiger | Тип: Игрушка | Максимальная скорость: N/A", 0xff6633)
	end
	if id==565 then
	sampAddChatMessage("Flash | Тип: Спорт | Максимальная скорость: 91 km/h", 0xff6633)
	end
	if id==566 then
	sampAddChatMessage("Tahoma | Тип: Лоурайдер | Максимальная скорость: 89 km/h", 0xff6633)
	end
	if id==567 then
	sampAddChatMessage("Savanna | Тип: Лоурайдер | Максимальная скорость: 96 km/h", 0xff6633)
	end
	if id==568 then
	sampAddChatMessage("Bandito | Тип: Внедорожник | Максимальная скорость: 81 km/h", 0xff6633)
	end
	if id==569 then
	sampAddChatMessage("Freight Flat Trailer | Тип: Прицеп | Максимальная скорость: N/A", 0xff6633)
	end
	if id==570 then
	sampAddChatMessage("Streak Trailer | Тип: Прицеп | Максимальная скорость: N/A", 0xff6633)
	end
	if id==571 then
	sampAddChatMessage("Kart | Тип: Тяжелая | Максимальная скорость: 52 km/h", 0xff6633)
	end
	if id==572 then
	sampAddChatMessage("Mower | Тип: Тяжелая | Максимальная скорость: 33 km/h", 0xff6633)
	end
	if id==573 then
	sampAddChatMessage("Dune | Тип: Внедорожник | Максимальная скорость: 61 km/h", 0xff6633)
	end
	if id==574 then
	sampAddChatMessage("Sweeper | Тип: Тяжелая | Максимальная скорость: 33 km/h", 0xff6633)
	end
	if id==575 then
	sampAddChatMessage("Broadway | Тип: Лоурайдер | Максимальная скорость: 88 km/h", 0xff6633)
	end
	if id==576 then
	sampAddChatMessage("Tornado | Тип: Лоурайдер | Максимальная скорость: 88 km/h", 0xff6633)
	end
	if id==577 then
	sampAddChatMessage("AT400 | Тип: Самолет | Максимальная скорость: N/A", 0xff6633)
	end
	if id==578 then
	sampAddChatMessage("DFT-30 | Тип: Тягач/Грузовик | Максимальная скорость: 72 km/h", 0xff6633)
	end
	if id==579 then
	sampAddChatMessage("Huntley | Тип: Внедорожник | Максимальная скорость: 89 km/h", 0xff6633)
	end
	if id==580 then
	sampAddChatMessage("Stafford | Тип: Легковая | Максимальная скорость: 85 km/h", 0xff6633)
	end
	if id==581 then
	sampAddChatMessage("BF-400 | Тип: Мото | Максимальная скорость: 87 km/h", 0xff6633)
	end
	if id==582 then
	sampAddChatMessage("Newsvan | Тип: Тягач/Грузовик | Максимальная скорость: 75 km/h", 0xff6633)
	end
	if id==583 then
	sampAddChatMessage("Tug | Тип: Тяжелая | Максимальная скорость: 47 km/h", 0xff6633)
	end
	if id==584 then
	sampAddChatMessage("Petrol Trailer | Тип: Прицеп | Максимальная скорость: N/A", 0xff6633)
	end
	if id==585 then
	sampAddChatMessage("Emperor | Тип: Легковая | Максимальная скорость: 85 km/h", 0xff6633)
	end
	if id==586 then
	sampAddChatMessage("Wayfarer | Тип: Мото | Максимальная скорость: 79 km/h", 0xff6633)
	end
	if id==587 then
	sampAddChatMessage("Euros | Тип: Спорт | Максимальная скорость: 91 km/h", 0xff6633)
	end
	if id==588 then
	sampAddChatMessage("Hotdog | Тип: Тяжелая | Максимальная скорость: 60 km/h", 0xff6633)
	end
	if id==589 then
	sampAddChatMessage("Club | Тип: Спорт | Максимальная скорость: 90 km/h", 0xff6633)
	end
	if id==590 then
	sampAddChatMessage("Freight Box Trailer | Тип: Тягач/Грузовик | Максимальная скорость: N/A", 0xff6633)
	end
	if id==591 then
	sampAddChatMessage("Article Trailer 3 | Тип: Прицеп | Максимальная скорость: N/A", 0xff6633)
	end
	if id==592 then
	sampAddChatMessage("Andromada | Тип: Самолет | Максимальная скорость: N/A", 0xff6633)
	end
	if id==593 then
	sampAddChatMessage("Dodo | Тип: Самолет | Максимальная скорость: N/A", 0xff6633)
	end
	if id==594 then
	sampAddChatMessage("RC Cam | Тип: Игрушка | Максимальная скорость: N/A", 0xff6633)
	end
	if id==595 then
	sampAddChatMessage("Launch | Тип: Лодка | Максимальная скорость: 62 km/h", 0xff6633)
	end
	if id==596 then
	sampAddChatMessage("Police car (LSPD) | Тип: Служебные | Максимальная скорость: 97 km/h", 0xff6633)
	end
	if id==597 then
	sampAddChatMessage("Police car (SFPD) | Тип: Служебные | Максимальная скорость: 97 km/h", 0xff6633)
	end
	if id==598 then
	sampAddChatMessage("Police car (LVPD) | Тип: Служебные | Максимальная скорость: 97 km/h", 0xff6633)
	end
	if id==599 then
	sampAddChatMessage("Police Ranger | Тип: Служебные | Максимальная скорость: 88 km/h", 0xff6633)
	end
	if id==600 then
	sampAddChatMessage("Picador | Тип: Тягач/Грузовик | Максимальная скорость: 84 km/h", 0xff6633)
	end
	if id==601 then
	sampAddChatMessage("S.W.A.T | Тип: Служебные | Максимальная скорость: 61 km/h", 0xff6633)
	end
	if id==602 then
	sampAddChatMessage("Alpha | Тип: Спорт | Максимальная скорость: 94 km/h", 0xff6633)
	end
	if id==603 then
	sampAddChatMessage("Phoenix | Тип: Спорт | Максимальная скорость: 95 km/h", 0xff6633)
	end
	if id==604 then
	sampAddChatMessage("Glendale Shit | Тип: Легковая | Максимальная скорость: 82 km/h", 0xff6633)
	end
	if id==605 then
	sampAddChatMessage("Sadler Shit | Тип: Тягач/Грузовик | Максимальная скорость: 84 km/h", 0xff6633)
	end
	if id==606 then
	sampAddChatMessage("Baggage Trailer A | Тип: Прицеп | Максимальная скорость: N/A", 0xff6633)
	end
	if id==607 then
	sampAddChatMessage("Baggage Trailer B | Тип: Прицеп | Максимальная скорость: N/A", 0xff6633)
	end
	if id==608 then
	sampAddChatMessage("Tug Stairs Trailer | Тип: Прицеп | Максимальная скорость: N/A", 0xff6633)
	end
	if id==609 then
	sampAddChatMessage("Boxville | Тип: Тягач/Грузовик | Максимальная скорость: 60 km/h", 0xff6633)
	end
	if id==610 then
	sampAddChatMessage("Farm Trailer | Тип: Прицеп | Максимальная скорость: N/A", 0xff6633)
	end
	if id==611 then
	sampAddChatMessage("Utillity Trailer | Тип: Прицеп | Максимальная скорость: N/A", 0xff6633)
	end
end

function gg(param)
	local id1 = tonumber(param)
		if id1~=nil then
			sampSendChat("/ans "..id1.." Администрация желает Вам приятной игры на Purple Server.")
		end
end

function jb(param)
	local id1 = tonumber(param)
		if id1~=nil then
			sampSendChat("/ans "..id1.." Оформите жалобу на форум (forum.advance-rp.ru) с доказательствами.")
		end
end

function ni(param)
	local id1 = tonumber(param)
		if id1~=nil then
			sampSendChat("/ans "..id1.." Не имею возможности выдать.")
		end
end

function of(param)
	local id1 = tonumber(param)
		if id1~=nil then
			sampSendChat("/ans "..id1.." Прекращайте оффтопить, далее будет выдана затычка.")
		end
end

function oj(param)
	local id1 = tonumber(param)
		if id1~=nil then
			sampSendChat("/ans "..id1.." Ожидайте ответа администратора.")
		end
end

function rp(param)
	local id1 = tonumber(param)
		if id1~=nil then
			sampSendChat("/ans "..id1.." Role-Play путем.")
		end
end	

function num(param)
	local id1 = tonumber(param)
		if id1~=nil then
			sampSendChat("/ans "..id1.." Чтобы найти номер игрока нужно подать объявление в СМИ.")
			sampSendChat("/ans "..id1..' /ad Ищу человека по имени "Nick_Name".')
		end
end

function mpjail(param)
	local id1 = tonumber(param)
		if id1~=nil then
			sampSendChat("/jail "..id1.." 20 Выбыл(а) с мероприятия")
			sampSendChat("/unjail "..id1)
		end
end

function bz(param)
	local id1 = tonumber(param)
		if id1~=nil then
			sampSendChat("/ans "..id1.." Без понятия.")
		end
end

function sled(param)
	local id1 = tonumber(param)
		if id1~=nil then
			sampSendChat("/ans "..id1.." Наблюдаю за игроком.")
		end
end

function dal(param)
	local id1 = tonumber(param)
		if id1~=nil then
			sampSendChat("/vec 510 211 211")
			sampSendChat("/ans "..id1.." Выдал.")
			sampSendChat("/ans "..id1.." Приятной игры на Purple Server.")
		end
end

function vel()
		sampSendChat("/vec 510 211 211")
end

function dt(param)
	local id1 = tonumber(param)
		if id1~=nil then
			sampSendChat("/ans "..id1.." Точное время: "..os.date('%d.%m.20%y | %H:%M:%S'))
		end
end

function resp3()
	sampSendChat("/respv 3")
end

function resp30()
	sampSendChat("/respv 30")
end	

	function autoName()
		while true do
			isClose=false
			strname, _ , _ , _ = sampGetChatString(99)
			if strname ~= text7 and namestate == 1 then
				aname = string.match(strname, "%S+ >> %S+")
				if aname ~= nil then
					okayid = string.match(strname, "/okay %d+")
					print(okayid)
					ndia="Новая заявка на смену ника"..'\n{31CE58}'..aname.."\n".."\n{F36519}".."Для закрытия диалога нажмите CTRL"
					sampShowDialog(6748, "Смена Non-RP имени", ndia, "Отклон.", "Одобр.", 0)
					while sampIsDialogActive() do if wasKeyPressed(17) then sampCloseCurrentDialogWithButton(17) end wait(0)end 
					_, nbutton, _, _ = sampHasDialogRespond(6748)
					if nbutton == 0 then
						sampSendChat(okayid)
					end
					if nbutton == 1 then
						if okayid ~= nil then
							sampSendChat("/ans "..string.match(okayid, '%d+').." Отказано, нарушены правила подачи заявки.")
						end
					end	
			end
				text7 = strname
			end
			wait(0)
		end
	end