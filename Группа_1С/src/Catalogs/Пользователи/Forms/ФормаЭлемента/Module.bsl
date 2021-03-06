
//Формирование реквизита Наименование------------------------
//Фамилия
&НаКлиенте
Процедура ФамилияПриИзменении(Элемент)
	СформироватьНаименование();
КонецПроцедуры

//Имя
&НаКлиенте
Процедура ИмяПриИзменении(Элемент)
	СформироватьНаименование();
КонецПроцедуры

//Отчество
&НаКлиенте
Процедура ОтчествоПриИзменении(Элемент)
	СформироватьНаименование();
КонецПроцедуры

&НаКлиенте
Процедура СформироватьНаименование()
	Объект.Наименование = СокрЛП(Объект.Фамилия) + " " + СокрЛП(Объект.Имя) + " " + СокрЛП(Объект.Отчество);
КонецПроцедуры // СформироватьНаименование()

//----------------------------------------------------------

////Процедура подключения к пользователю----------
//&НаКлиенте
//Процедура Подключиться(Команда)
//	ПодключитьсяНаСервере();
//КонецПроцедуры
//&НаСервере
//Процедура ПодключитьсяНаСервере()
//	Док = РеквизитФормыВЗначение("Объект");
//	ТекДанные = ОбщиеФункции.СобратьДанныеДляПодключения(Док);
//	Подключиться.ПодключитьсяКУдаленномуКомпьютеру(ТекДанные);
//КонецПроцедуры
////----------------------------------------------

////Перед записью нового пользователя проверка на дубли по Фамилии и Имени //добавлено 2014-08-13 проверка по Наименованию
//&НаКлиенте
//Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
//	УбираемЛишниеПробелы();
//	Код = ПередЗаписьюНаСервере();
//	Рез = ПоискИстины();
//	Если НЕ Рез = Неопределено Тогда 
//		Если Рез Тогда 
//			// Предложения открыть запись
//			Ответ = Вопрос("Дублирование записи. Открыть ранее созданную запись?", РежимДиалогаВопрос.ДаНет, 60);
//			Если Ответ = КодВозвратаДиалога.Да Тогда
//				ЭтаФорма.Закрыть();
//				ОткрытьФорму("Справочник.Пользователи.ФормаОбъекта", Новый Структура("Ключ", НайтиПользователя(Код)));
//				Отказ = Рез;
//				Возврат;
//			Иначе 
//				Отказ = Рез;
//				СтандартнаяОбработка = Ложь;
//				ЭтаФорма.Закрыть();
//				Возврат;
//			КонецЕсли;
//			//------------------------------
//		КонецЕсли;
//	КонецЕсли;
//КонецПроцедуры

//&НаСервере
//Функция  ПередЗаписьюНаСервере()
//	Док = РеквизитФормыВЗначение("Объект");
//	Если Ложь Тогда Док = Справочники.Пользователи.ПустаяСсылка(); КонецЕсли;
//	Запрос = Новый Запрос;
//	Запрос.Текст = 
//	"ВЫБРАТЬ
//	|	Пользователи.Ссылка,
//	|	Пользователи.Наименование,
//	|	Пользователи.Код
//	|ИЗ
//	|	Справочник.Пользователи КАК Пользователи
//	|ГДЕ
//	|	Пользователи.Наименование ПОДОБНО &Наименование";
//	Запрос.Параметры.Вставить("Наименование", "%"+ СокрЛП(Док.Фамилия) + " " + СокрЛП(Док.Имя) +"%");
//	Выборка = Запрос.Выполнить().Выгрузить();
//	Для Каждого Стр из Выборка Цикл 
//		Если Док.ИмяКомпьютера = "" или Док.ИмяКомпьютера = Стр.Ссылка.ИмяКомпьютера Тогда 
//			Если Стр.Код = Док.Код Тогда 
//				Док.ПоказатьНаименование = Ложь;
//				ЗначениеВРеквизитФормы(Док, "Объект");
//				Возврат Док.Код;
//			Иначе 
//				Док.ПоказатьНаименование = Ложь;
//				ЗначениеВРеквизитФормы(Док, "Объект");
//				Возврат Стр.Код;
//			КонецЕсли;
//		КонецЕсли;
//	КонецЦикла;
//КонецФункции

//Функция ПоискИстины()
//	Док = РеквизитФормыВЗначение("Объект");
//	Если Ложь Тогда Док = Справочники.Пользователи.ПустаяСсылка(); КонецЕсли;
//	Запрос = Новый Запрос;
//	Запрос.Текст = 
//	"ВЫБРАТЬ
//	|	Пользователи.Ссылка,
//	|	Пользователи.Наименование,
//	|	Пользователи.Код
//	|ИЗ
//	|	Справочник.Пользователи КАК Пользователи
//	|ГДЕ
//	|	Пользователи.Наименование ПОДОБНО &Наименование";
//	Запрос.Параметры.Вставить("Наименование", "%"+ СокрЛП(Док.Фамилия) + " " + СокрЛП(Док.Имя) +"%");
//	Выборка = Запрос.Выполнить().Выгрузить();
//	Для Каждого Стр из Выборка Цикл 
//		Если Стр.Код = Док.Код Тогда 
//			Возврат Ложь;
//		Иначе 
//			Возврат Истина;
//		КонецЕсли;
//	КонецЦикла;
//	ЗначениеВРеквизитФормы(Док, "Объект");
//КонецФункции
////------------------------------------------------------------------------

//&НаСервере
//Процедура УбираемЛишниеПробелы()
//	Док = РеквизитФормыВЗначение("Объект");
//	Если Ложь Тогда Док = Справочники.Пользователи.ПустаяСсылка(); КонецЕсли;
//	Док.Фамилия		= СокрЛП(Док.Фамилия);
//	Док.Имя			= СокрЛП(Док.Имя);
//	Док.Отчество	= СокрЛП(Док.Отчество);
//	ЗначениеВРеквизитФормы(Док, "Объект");
//КонецПроцедуры

////Функция для нахождения пользователя, для открытия формы элемента
//Функция НайтиПользователя(Код)
//	Пол = Справочники.Пользователи.НайтиПоКоду(Код);
//	Возврат Пол;
//КонецФункции
////---------------------------------------------------------------

////Показать наименование (может потребоваться, если у пользователя два и более рабочих места)
//&НаКлиенте
//Процедура ПоказатьНаименованиеПриИзменении(Элемент)
//	ПоказатьНаименованиеПриИзмененииНаСервере();
//КонецПроцедуры

//&НаСервере
//Процедура ПоказатьНаименованиеПриИзмененииНаСервере()
//	Док = РеквизитФормыВЗначение("Объект");
//	Если Ложь Тогда Док = Справочники.Пользователи.ПустаяСсылка(); КонецЕсли;
//	Если Док.ПоказатьНаименование = Истина Тогда 
//		Элементы.Наименование.Видимость = Истина;
//	Иначе 
//		Элементы.Наименование.Видимость = Ложь;
//	КонецЕсли;
//	ЗначениеВРеквизитФормы(Док, "Объект");
//КонецПроцедуры

////-------------------------------------------------------------------
//&НаКлиенте
//Процедура УказатьДатуРождения(Команда)	
//	ОткрытьФорму("РегистрСведений.ДатыРождения.ФормаЗаписи",Новый Структура("Ключ", ПолучитьКлючЗаписи(ЭтаФорма.Объект.Ссылка)));	
//КонецПроцедуры

//&НаСервере
//Функция ПолучитьКлючЗаписи(Пользователь)
//	Запрос = Новый Запрос;
//	Запрос.Текст = 
//	"ВЫБРАТЬ
//	|	ДатыРождения.Пользователь,
//	|	ДатыРождения.ДатаРождения,
//	|	ДатыРождения.Возраст
//	|ИЗ
//	|	РегистрСведений.ДатыРождения КАК ДатыРождения
//	|ГДЕ
//	|	ДатыРождения.Пользователь = &Пользователь";
//	Запрос.УстановитьПараметр("Пользователь", Пользователь);
//	Выборка = Запрос.Выполнить().Выбрать();
//	Если НЕ Выборка.Следующий() Тогда 
//		Возврат Истина;
//	Иначе 		
//		ЗначениеКлюча = Новый Структура;
//		ЗначениеКлюча.Вставить("Пользователь", Пользователь);
//		//ЗначениеКлюча.Вставить("ВидДокумента", Справочники.ВидыДокументовФизическихЛиц.НайтиПоНаименованию("Паспорт"));
//		Возврат РегистрыСведений.ДатыРождения.СоздатьКлючЗаписи(ЗначениеКлюча);
//	КонецЕсли;
//КонецФункции

////&НаКлиенте
////Процедура МестоРасположенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
////	Рез = МестоРасположенияНачалоВыбораНаСервере();
////	СтандартнаяОбработка = Ложь;
////	ЗначениеОтбора = Новый Структура("Родитель", Рез);
////	ПараметрыВыбора = Новый Структура("Отбор", ЗначениеОтбора);
////	
////	ОткрытьФорму("Справочник.МестаРасположения.Форма.ФормаВыбора", ПараметрыВыбора);
////	
////КонецПроцедуры

////&НаСервере
////Функция МестоРасположенияНачалоВыбораНаСервере()
////	Рез = Справочники.МестаРасположения.НайтиПоНаименованию(Объект.Родитель.Наименование);
////	Возврат Рез;
////КонецФункции








