
&НаКлиенте
Процедура Подключиться(Команда)
	ПодключитьсяНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПодключитьсяНаСервере()
	//Док = РеквизитФормыВЗначение("Объект");
	//Подключиться.ПодключитьсяКСерверу(Док);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Объект.ИпАдрес = СтрЗаменить(Объект.ИпАдрес, " ", "");
КонецПроцедуры
