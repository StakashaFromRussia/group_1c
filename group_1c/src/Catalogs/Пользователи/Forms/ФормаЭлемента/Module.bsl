
&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ИмяДляВхода) Тогда
		Возврат;
	КонецЕсли;
	
	МассивИмени = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Объект.Наименование, " ");
	Для Каждого ЧастьИмени Из МассивИмени Цикл
		Если ЗначениеЗаполнено(Объект.ИмяДляВхода) Тогда
			Объект.ИмяДляВхода = Объект.ИмяДляВхода + Лев(СокрЛП(ЧастьИмени), 1);
		Иначе
			Объект.ИмяДляВхода = СокрЛП(ЧастьИмени);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры
