
// Функция - Разложить строку в массив подстрок
//
// Параметры:
//  Стр			 - Строка - 
//  Разделитель	 - Строка - 
// 
// Возвращаемое значение:
// Массив - 
//
Функция РазложитьСтрокуВМассивПодстрок(Знач Стр, Разделитель) Экспорт
   
   МассивСтрок = Новый Массив();
   Если Разделитель = " " Тогда
       Стр = СокрЛП(Стр);
       Пока 1=1 Цикл
           Поз = Найти(Стр,Разделитель);
           Если Поз=0 Тогда
               МассивСтрок.Добавить(Стр);
               Возврат МассивСтрок;
           КонецЕсли;
           МассивСтрок.Добавить(Лев(Стр,Поз-1));
           Стр = СокрЛ(Сред(Стр,Поз));
       КонецЦикла;
   Иначе
       ДлинаРазделителя = СтрДлина(Разделитель);
       Пока 1=1 Цикл
           Поз = Найти(Стр,Разделитель);
           Если Поз=0 Тогда
               МассивСтрок.Добавить(Стр);
               Возврат МассивСтрок;
           КонецЕсли;
           МассивСтрок.Добавить(Лев(Стр,Поз-1));
           Стр = Сред(Стр,Поз+ДлинаРазделителя);
       КонецЦикла;
   КонецЕсли;
   Возврат МассивСтрок;
КонецФункции // глРазложить

// Функция - Получить данные для COMСоединения
//
// Параметры:
//  ИнформационнаяБаза	 - СправочникСсылка.ИнформационнаяБаза - информационная база, к которой производится подключение
// 
// Возвращаемое значение:
//  COMОбъект - com объект с подключением к информационной базе
//
Функция ВыполнитьПодключениеКБазе(ИнформационнаяБаза, ДанныеПодключения = Неопределено) Экспорт
	
	Если ДанныеПодключения = Неопределено Тогда
		ДанныеПодключения = ОбщегоНазначенияВызовСервера.ПолучитьДанныеДляCOMСоединения(ИнформационнаяБаза);
	КонецЕсли;

	Если ДанныеПодключения.ВерсияПлатформы = ПредопределенноеЗначение("Перечисление.Платформы.Версия83") Тогда 
		V8 = Новый COMОбъект("V83.COMConnector");
	Иначе 
		//V8 = Новый COMОбъект("V82.COMConnector");
	КонецЕсли;
	
	СтрокаПодключения = "";
	Если ДанныеПодключения.SQL Тогда
		СтрокаПодключения = "srvr=""" + ДанныеПодключения.ИмяСервера + ":" + ДанныеПодключения.Порт + """; ref=""" + ДанныеПодключения.ИмяБазы + """; usr=""" + ДанныеПодключения.Пользователь + """; pwd=""" + ДанныеПодключения.Пароль + """;";
	Иначе
		СтрокаПодключения = "File=""" + ДанныеПодключения.ИмяСервера + """; usr=""" + ДанныеПодключения.Пользователь + """; pwd=""" + ДанныеПодключения.Пароль + """;";
	КонецЕсли;

	Попытка
		Подключение = V8.Connect(СтрокаПодключения);
	Исключение
		Подключение = Неопределено;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не удалось подкюлчиться к информационной базе: " + ИнформационнаяБаза + ". Ошибка: " + ОписаниеОшибки();
		Сообщение.Сообщить();
	КонецПопытки;
	
	Возврат Подключение;
КонецФункции

Функция ПолучитьКонфигурациюИВерсиюБазы(ИнформационнаяБаза) Экспорт 

	СтруктураСоответствий = ОбщегоНазначенияВызовСервера.ПолучитьСтруктуруСоответствийКонфигураийНаименованиям();
	
	Структура = Новый Структура("Конфигурация, Версия", ПредопределенноеЗначение("Справочник.Конфигурации.ПустаяСсылка"), "");
	Подключение = ОбщегоНазначенияКлиентСервер.ВыполнитьПодключениеКБазе(ИнформационнаяБаза);
	Если НЕ Подключение = Неопределено Тогда
		КраткаяИнформация = Подключение.Метаданные.КраткаяИнформация;
		Структура.Конфигурация = СтруктураСоответствий.НаименованиеКонфигурация.Получить(КраткаяИнформация);
		Структура.Версия = Подключение.Метаданные.Версия;
		Если Структура.Конфигурация = Неопределено Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Не найдена конфигурация в справочнике: " + КраткаяИнформация;
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЕсли;

	Возврат Структура;
	
КонецФункции // ПолучитьКонфигурациюБазы(База)()

// Формирует и выводит сообщение, которое может быть связано с элементом управления формы.
//
// Параметры:
//  ТекстСообщенияПользователю - Строка - текст сообщения.
//  КлючДанных - ЛюбаяСсылка - объект или ключ записи информационной базы, к которому это сообщение относится.
//  Поле - Строка - наименование реквизита формы.
//  ПутьКДанным - Строка - путь к данным (путь к реквизиту формы).
//  Отказ - Булево - выходной параметр, всегда устанавливается в значение Истина.
//
// Пример:
//
//  1. Для вывода сообщения у поля управляемой формы, связанного с реквизитом объекта:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ,
//   "ПолеВРеквизитеФормыОбъект",
//   "Объект");
//
//  Альтернативный вариант использования в форме объекта:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ,
//   "Объект.ПолеВРеквизитеФормыОбъект");
//
//  2. Для вывода сообщения рядом с полем управляемой формы, связанным с реквизитом формы:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ,
//   "ИмяРеквизитаФормы");
//
//  3. Для вывода сообщения связанного с объектом информационной базы:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ОбъектИнформационнойБазы, "Ответственный",,Отказ);
//
//  4. Для вывода сообщения по ссылке на объект информационной базы:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), Ссылка, , , Отказ);
//
//  Случаи некорректного использования:
//   1. Передача одновременно параметров КлючДанных и ПутьКДанным.
//   2. Передача в параметре КлючДанных значения типа отличного от допустимого.
//   3. Установка ссылки без установки поля (и/или пути к данным).
//
Процедура СообщитьПользователю( 
	Знач ТекстСообщенияПользователю,
	Знач КлючДанных = Неопределено,
	Знач Поле = "",
	Знач ПутьКДанным = "",
	Отказ = Ложь) Экспорт
	
	ЭтоОбъект = Ложь;
	
	Если КлючДанных <> Неопределено
		И XMLТипЗнч(КлючДанных) <> Неопределено Тогда
		
		ТипЗначенияСтрокой = XMLТипЗнч(КлючДанных).ИмяТипа;
		ЭтоОбъект = СтрНайти(ТипЗначенияСтрокой, "Object.") > 0;
	КонецЕсли;
	
	СообщитьПользователюСлужебный(
		ТекстСообщенияПользователю,
		КлючДанных,
		Поле,
		ПутьКДанным,
		Отказ,
		ЭтоОбъект);
	
КонецПроцедуры

Процедура СообщитьПользователюСлужебный(
		Знач ТекстСообщенияПользователю,
		Знач КлючДанных,
		Знач Поле,
		Знач ПутьКДанным = "",
		Отказ = Ложь,
		ЭтоОбъект = Ложь)
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщенияПользователю;
	Сообщение.Поле = Поле;
	
	Если ЭтоОбъект Тогда
		Сообщение.УстановитьДанные(КлючДанных);
	Иначе
		Сообщение.КлючДанных = КлючДанных;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ПутьКДанным) Тогда
		Сообщение.ПутьКДанным = ПутьКДанным;
	КонецЕсли;
	
	Сообщение.Сообщить();
	
	Отказ = Истина;
	
КонецПроцедуры
