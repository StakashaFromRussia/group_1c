
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Для каждого ИнформационнаяБаза Из ПараметрКоманды Цикл
		ОбщегоНазначенияКлиент.ВыполнитьЗапускИнформационнойБазы(ИнформационнаяБаза, "config");
	КонецЦикла;
КонецПроцедуры
