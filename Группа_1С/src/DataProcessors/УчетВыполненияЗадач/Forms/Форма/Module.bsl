
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Задачи.Ссылка КАК Задача
		|ИЗ
		|	Справочник.Задачи КАК Задачи
		|ГДЕ
		|	НЕ Задачи.Выполнена";
	
	АктуальныеЗадачи = Запрос.Выполнить().Выгрузить();
	Для каждого СтрокаТЧ Из АктуальныеЗадачи Цикл
	    Задача = СтрокаТЧ.Задача;
		НоваяСтрока = ТаблицаЗадач.Добавить();
		НоваяСтрока.Задача = Задача;
		НоваяСтрока.ИдентификаторЗадачи = Задача.УникальныйИдентификатор();
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура НачатьВыполнение(Команда)
	ТекущиеДанные = Элементы.ТаблицаЗадач.ТекущиеДанные;
	ТекущиеДанные.ИдетВыполнение = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ОбновитьВремяВыполненияЗадачи", 1);
КонецПроцедуры

&НаКлиенте
Процедура Пауза(Команда)
	ТекущиеДанные = Элементы.ТаблицаЗадач.ТекущиеДанные;
	ЗафиксироватьВремяВыполнения(Объект.Пользователь, ТекущиеДанные.Задача, ТекущиеДанные.ВремяВыполнения);
	ОтключитьОбработчикОжидания("Подключаемый_ОбновитьВремяВыполненияЗадачи");
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьВыполнение(Команда)
	ТекущиеДанные = Элементы.ТаблицаЗадач.ТекущиеДанные;
	ЗафиксироватьВремяВыполнения(Объект.Пользователь, ТекущиеДанные.Задача, ТекущиеДанные.ВремяВыполнения, Истина);
	ОтключитьОбработчикОжидания("Подключаемый_ОбновитьВремяВыполненияЗадачи");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьВремяВыполненияЗадачи()

	Для Каждого СтрокаТЧ Из ТаблицаЗадач Цикл
		Если СтрокаТЧ.ИдетВыполнение Тогда
			СтрокаТЧ.ВремяВыполнения = ТекущаяДата();
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры // Подключаемый_ОбновитьВремяВыполненияЗадачи()

&НаСервереБезКонтекста
Процедура ЗафиксироватьВремяВыполнения(Пользователь, Задача, ВремяВыполнения, ЗадачаВыполнена = Ложь)

	//Найдем или создадим документ за сегодняшнее число
	ДокументОбъект = НайтиДокументВыполненияЗадачи(Пользователь, НачалоДня(ТекущаяДата()));

КонецПроцедуры // ЗафиксироватьВремяВыполнения(Пользователь, Задача, ВремяВыполнения, ЗадачаВыполнена)

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	ОтключитьОбработчик = Истина;
	Для каждого СтрокаТЧ Из ТаблицаЗадач Цикл
		Если СтрокаТЧ.ИдетВыполнение Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Необходимо завершить задачу: " + СтрокаТЧ.Задача;
			Сообщение.Сообщить();
			ОтключитьОбработчик = Ложь;
		КонецЕсли;
	КонецЦикла;
	Если ОтключитьОбработчик Тогда
		ОтключитьОбработчикОжидания("Подключаемый_ОбновитьВремяВыполненияЗадачи");
	КонецЕсли;
КонецПроцедуры

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервереБезКонтекста
Функция НайтиДокументВыполненияЗадачи(Пользователь, ДатаДокумента)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВыполнениеЗадач.Ссылка КАК Документ
		|ИЗ
		|	Документ.ВыполнениеЗадач КАК ВыполнениеЗадач
		|ГДЕ
		|	ВыполнениеЗадач.Пользователь = &Пользователь
		|	И ВыполнениеЗадач.Дата = &Дата";
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	Запрос.УстановитьПараметр("Дата", ДатаДокумента);
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		ДокументОбъект = Выборка.Документ.ПолучитьОбъект();	
	Иначе 
		ДокументОбъект = Документы.ВыполнениеЗадач.СоздатьДокумент();
	КонецЕсли;
	
	Возврат ДокументОбъект;
КонецФункции// НайтиДокументВыполненияЗадачи(Пользователь, НачалоДня(ТекущаяДата()))
