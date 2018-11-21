script_name("TELEPORT")
script_version_number(10)
script_version("1.0.0")
script_description("Z+N")
script_author("Lucas Mayer")
require "lib.moonloader"

function main()
if not isSampfuncsLoaded() or not isSampLoaded() then return end
while not isSampAvailable() do wait(100) end
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Телепорт по важным местам v.1.0. Автор: Lucas Mayer.",0x3399ff)
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Активация: Z+N.",0x3399ff)
while true do
wait(0)
if isKeyDown(90) and isKeyDown(78) then
sampShowDialog(20, "{3399ff}Телепорт по важным местам by Lucas Mayer", "{3399ff}Спавны\n1. Автостанция Лос-Сантос\n2. ЖД Лос-Сантос\n3. ЖД Сан-Фиерро\n4. ЖД Лас-Вентурас\n{3399ff}Работы новичков\n5. Шахта\n6. Завод\n7. Склад\n8. Фармацевтическая фабрика\n{3399ff}Банки\n9. Банк Лос-Сантос\n10. Банк Сан-Фиерро\n11. Банк Fort Carson\n12. Банк Polomino Creek\n13. Банк Angel Pane\n14. Банк Las Barrancas\n{3399ff}Аэропорты и стадионы\n15. Аэропорт Лос-Сантос\n16. Аэропорт Сан-Фиерро\n17. Аэропорт Лас-Вентурас\n18. Стадион Лос-Сантос\n19. Стадион Сан-Фиерро\n20. Стадион Лас-Вентурас\n{3399ff}Казино\n21. Казино 'Лос-Сантос'\n22. Казино 'Южное'\n23. Казино 'Восточное'\n24. Казино '4 дракона'\n25. Казино 'Калигула'\n{3399ff}Гонки\n26. Гонки по Лос-Сантос\n27. Гонки на VineWood\n28. Гонки по Сан-Фиерро\n29. Гонки по Лас-Вентурасу\n30. Экстремальные гонки на Sultan\n31. Экстремальные гонки на NRG-500\n32. Экстремальные гонки на Infernus\n{3399ff}Казаки\n33. Казаки 'Заброщенный завод'\n34. Казаки 'Испытательный полигон'\n35. Казаки 'Ферма наркоманов'\n36. Казаки 'Под водой'\n{3399ff}Прочее\n37. Библиотека\n38. Нарко корабль\n39. Малая рулетка\n40. Большая рулеткаn\n41. Злые клоуны\n42. Дамба\n43. Поливалка\n44. Гора 'Чиллиад'\n45. Военкомат\n46. Авианосец\n47. Клуб 'Jizzy'\n48. Тир\n49. Соревнования по стрельбе\n50. Таможня Лас-Вентурас\n51. Церковь\n{3399ff}Стрелы\n52. Заброшенная деревня\n53. Карьер\n54. Порт\n55. Лесопилка", "Выбрать", "Выход", 2)
end
local result, button, list, text = sampHasDialogRespond(20)
if result then
if list == 1 then
setCharCoordinates(playerPed, 1153.6199,-1757.0463,13.6450)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались на Автостанцию Лос-Сантос.",0x3399ff)
end
if result then
if list == 2 then
setCharCoordinates(playerPed, 1760.4036,-1899.1830,13.5631,271.1769)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались на ЖД Лос-Сантос.",0x3399ff)
end
if result then
if list == 3 then
setCharCoordinates(playerPed, -1988.1208,138.1147,27.5391,91.0320)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались на ЖД Сан-Фиерро.",0x3399ff)
end
if result then
if list == 4 then
setCharCoordinates(playerPed, 2846.0833,1290.4824,11.3906,88.2353)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались на ЖД Лас-Вентурас.",0x3399ff)
end
if result then
if list == 6 then
setCharCoordinates(playerPed, -1930.1831,-1709.1978,22.2730,341.3878)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались на Шахту.",0x3399ff)
end
if result then
if list == 7 then
setCharCoordinates(playerPed, -98.8213,-324.5865,1.4297,357.3679)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались на Завод.",0x3399ff)
end
if result then
if list == 8 then
setCharCoordinates(playerPed, 2210.9050,-2234.8452,13.5469,139.0869)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались на Склад.",0x3399ff)
end
if result then
if list == 9 then
setCharCoordinates(playerPed, 1345.6794,351.7001,19.5547,240.2946)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались на Фармацевтическую фабрику.",0x3399ff)
end
if result then
if list == 11 then
setCharCoordinates(playerPed, 1423.9794,-1623.8815,13.5469,267.9221)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Банку Лос-Сантос.",0x3399ff)
end
if result then
if list == 12 then
setCharCoordinates(playerPed, -1499.3363,920.2478,7.1875,267.9221)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Банку Сан-Фиерро.",0x3399ff)
end
if result then
if list == 13 then
setCharCoordinates(playerPed, -182.3565,1133.1173,19.7422,267.9221)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к банку Fort Carson.",0x3399ff)
end
if result then
if list == 14 then
setCharCoordinates(playerPed, 2301.0630,-16.3021,26.4844,267.9221)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к банку Polomino Creek.",0x3399ff)
end
if result then
if list == 15 then
setCharCoordinates(playerPed, -2160.8884,-2419.6382,30.6250,56.5703)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к банку Angel Pane.",0x3399ff)
end
if result then
if list == 16 then
setCharCoordinates(playerPed, -827.7589,1498.9653,19.2755,2.3629)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к банку Las Barrancas.",0x3399ff)
end
if result then
if list == 18 then
setCharCoordinates(playerPed, 1948.1451,-2262.1511,13.5469,150.6129)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались в Аэропорт Лос-Сантоса.",0x3399ff)
end
if result then
if list == 19 then
setCharCoordinates(playerPed, -1372.4335,-238.1189,14.1484,311.0646)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались в Аэропорт Сан-Фиерро.",0x3399ff)
end
if result then
if list == 20 then
setCharCoordinates(playerPed, 1571.1998,1453.6764,10.8254,119.6162)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались в Аэропорт Лас-Вентурас.",0x3399ff)
end
if result then
if list == 21 then
setCharCoordinates(playerPed, 2691.1653,-1706.6339,11.7473,39.0888)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Стадиону Лос-Сантос.",0x3399ff)
end
if result then
if list == 22 then
setCharCoordinates(playerPed, -2115.5291,-445.7120,37.2738,84.5225)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Стадиону Сан-Фиерро.",0x3399ff)
end
if result then
if list == 23 then
setCharCoordinates(playerPed, 1092.4154,1604.1655,12.5469,6.3568)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Стадиону Лас-Вентурас.",0x3399ff)
end
if result then
if list == 25 then
setCharCoordinates(playerPed, 1022.5181,-1129.9711,23.8703,179.6318)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Казино 'Лос-Сантос'.",0x3399ff)
end
if result then
if list == 26 then
setCharCoordinates(playerPed, 2018.1703,1103.1053,10.8203,209.7121)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Казино 'Южное'.",0x3399ff)
end
if result then
if list == 27 then
setCharCoordinates(playerPed, 2448.4722,1493.9178,10.9063,129.6904)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Казино 'Восточное'.",0x3399ff)
end
if result then
if list == 28 then
setCharCoordinates(playerPed, 2029.4445,1007.5312,10.8203,89.1010)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Казино '4 дракона'.",0x3399ff)
end
if result then
if list == 29 then
setCharCoordinates(playerPed, 2192.4065,1677.0450,12.3672,89.1010)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Казино 'Калигула'.",0x3399ff)
end
if result then
if list == 31 then
setCharCoordinates(playerPed, 847.8695,-1822.4263,12.1833,349.5386)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Гонкам по Лос-Сантосу.",0x3399ff)
end
if result then
if list == 32 then
setCharCoordinates(playerPed, 1141.8643,-897.5825,43.1797,87.3229)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Гонкам на VineWood.",0x3399ff)
end
if result then
if list == 33 then
setCharCoordinates(playerPed, -1969.1019,613.8064,35.0156,358.5788)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Гонкам по Сан-Фиерро.",0x3399ff)
end
if result then
if list == 34 then
setCharCoordinates(playerPed, 2351.1531,2738.0967,10.8203,88.7964)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Гонкам по Лас-Вентурасу.",0x3399ff)
end
if result then
if list == 35 then
setCharCoordinates(playerPed, 2351.9348,-1990.5313,13.3729,269.8815)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Экстремальным гонкам на Sultan.",0x3399ff)
end
if result then
if list == 36 then
setCharCoordinates(playerPed, -2175.0110,-2262.0833,30.6250,51.8228)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Экстремальным гонкам на NRG-500.",0x3399ff)
end
if result then
if list == 37 then
setCharCoordinates(playerPed, -1749.7372,36.5398,3.5547,268.6519)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Экстремальным гонкам на Infernus.",0x3399ff)
end
if result then
if list == 39 then
setCharCoordinates(playerPed, 2487.6829,2780.4377,10.8203,272.0201)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Казакам 'Заброшенный завод'.",0x3399ff)
end
if result then
if list == 40 then
setCharCoordinates(playerPed, 2808.3979,894.9117,10.7578,272.0201)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Казакам 'Испытательный полигон'.",0x3399ff)
end
if result then
if list == 41 then
setCharCoordinates(playerPed, -1054.3126,-1195.9956,129.0635,2.0202)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Казакам 'Ферма наркоманов'.",0x3399ff)
end
if result then
if list == 42 then
setCharCoordinates(playerPed, 2145.8977,-94.0661,2.7604,2.0202)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Казакам 'Под водой'.",0x3399ff)
end
if result then
if list == 44 then
setCharCoordinates(playerPed, 1135.9937,-2037.4247,69.0078,271.3936)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Библиотеке.",0x3399ff)
end
if result then
if list == 45 then
setCharCoordinates(playerPed, -1510.4050,-4029.8726,7.3078,271.3936)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались на Нарко корабль.",0x3399ff)
end
if result then
if list == 46 then
setCharCoordinates(playerPed, 2732.0422,2686.0513,59.0234,95.3220)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались на Малую рулетку.",0x3399ff)
end
if result then
if list == 47 then
setCharCoordinates(playerPed, 1043.4082,1012.6586,55.3047,95.3220)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались на Большую рулетку.",0x3399ff)
end
if result then
if list == 48 then
setCharCoordinates(playerPed, -2314.6140,1545.6936,18.7734,265.5422)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались на Корабль 'Злые клоуны'.",0x3399ff)
end
if result then
if list == 49 then
setCharCoordinates(playerPed, -695.1165,2063.7756,60.3828,180.0014)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались на Дамбу.",0x3399ff)
end
if result then
if list == 50 then
setCharCoordinates(playerPed, 1576.1532,-1245.3424,277.8777,108.8975)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались на Крышу 'Поливалка'.",0x3399ff)
end
if result then
if list == 51 then
setCharCoordinates(playerPed, -2231.2300,-1739.3219,481.4218,218.1500)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались на Гору 'Чиллиад'.",0x3399ff)
end
if result then
if list == 52 then
setCharCoordinates(playerPed, 1047.0348,1309.1364,10.8203,123.5458)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Военкомату.",0x3399ff)
end
if result then
if list == 53 then
setCharCoordinates(playerPed, -1522.3563,486.7305,10.6021,87.5355)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались на Авианосец.",0x3399ff)
end
if result then
if list == 54 then
setCharCoordinates(playerPed, -2622.2744,1406.3295,7.1016,200.5591)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались в Клуб 'Jizzy'.",0x3399ff)
end
if result then
if list == 55 then
setCharCoordinates(playerPed, -2669.8384,-3.6078,6.1328,89.9748)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались в Тир.",0x3399ff)
end
if result then
if list == 56 then
setCharCoordinates(playerPed, 2397.6101,-1543.7786,24.0000,356.2873)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Соревнованиям по стрельбе.",0x3399ff)
end
if result then
if list == 57 then
setCharCoordinates(playerPed, 1797.2426,826.4137,10.6598,356.9376)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались на Таможню Лас-Вентурас.",0x3399ff)
end
if result then
if list == 58 then
setCharCoordinates(playerPed, -1980.6169,1117.9828,53.1214,268.2635)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались к Церкви.",0x3399ff)
end
if result then
if list == 60 then
setCharCoordinates(playerPed, -384.9989,2237.5940,42.0938,87.5355)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались в Заброшенную деревню.",0x3399ff)
end
if result then
if list == 61 then
setCharCoordinates(playerPed, 614.7861,854.8010,-42.9609,87.5355)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались в Карьер.",0x3399ff)
end
if result then
if list == 62 then
setCharCoordinates(playerPed, 2759.1741,-2433.8962,13.5072,87.5355)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались в Порт.",0x3399ff)
end
if result then
if list == 63 then
setCharCoordinates(playerPed, -1987.0364,-2380.1448,30.6250,87.5355)
sampSendChat("/setint 0")
sampSendChat("/setvw 0")
sampAddChatMessage("{3399ff}[TELEPORT] {ffffff}Вы телепортировались на Лесопилку.",0x3399ff)
if result then
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end