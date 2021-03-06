
// Функция - Получить массив баз кластера серверов
//
// Параметры:
//  Сервер	 - СправочникСсылка.Серверы - 
// 
// Возвращаемое значение:
//   - 
//
Функция ВыполнитьПодключениеККластеруСерверов(Сервер) Экспорт 

	Пользователь = Константы.АдминистраторИБЛогин.Получить();
	Пароль = Константы.АдминистраторИБПароль.Получить();
	Коннектор = Новый COMОбъект("V83.COMConnector");
	
	Агент = ВыполнитьПодключениеКАгентуСервера(Коннектор, Сервер.Наименование, Сервер.ИпАдрес);
	Кластеры = Агент.GetClusters();
	Кластер = Кластеры.GetValue(0);
	Агент.Authenticate(Кластер, , );
	
	РабочийПроцесс = Агент.GetWorkingProcesses(Кластер).GetValue(0);
	Порт = СтрЗаменить(Строка(РабочийПроцесс.MainPort),Символы.НПП,"");  // убиваем непереносимые пробелы
	СтрокаПодлючения = РабочийПроцесс.HostName + ":" + Порт;
	СоединениеСРабочимПроцессом = Коннектор.ConnectWorkingProcess(СтрокаПодлючения);
	СоединениеСРабочимПроцессом.AddAuthentication(Пользователь, Пароль);
	
	Возврат Новый Структура("Агент, СоединениеСРабочимПроцессом", Агент, СоединениеСРабочимПроцессом);

КонецФункции // ПолучитьМассивБазКластераСерверов(Сервер)

Функция ВыполнитьПодключениеКАгентуСервера(Коннектор, ИмяСервера, АдресIP) Экспорт 
	
	Агент = Неопределено;
	Попытка
		Агент = Коннектор.ConnectAgent(ИмяСервера);
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не удалось подключиться к серверу " + ИмяСервера;
		Сообщение.Сообщить();
	КонецПопытки;

	Возврат Агент;	
КонецФункции // ВыполнитьПодключениеККластеруСерверов(ИмяСервера, АдресIP)

Процедура ОбновитьВерсииТиповыхКонфигураций() Экспорт 
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВерсииТиповыхКонфигурацийСрезПоследних.Конфигурация КАК Конфигурация,
		|	ВерсииТиповыхКонфигурацийСрезПоследних.Версия КАК Версия
		|ИЗ
		|	РегистрСведений.ВерсииТиповыхКонфигураций.СрезПоследних КАК ВерсииТиповыхКонфигурацийСрезПоследних";
	
	Результат = Запрос.Выполнить();
	ТаблицаВерсийКонфигураций = Результат.Выгрузить();

	Для каждого СтрокаТЧ Из ТаблицаВерсийКонфигураций Цикл
		
		Конфигурация = СтрокаТЧ.Конфигурация;
		ТекущаяВерсия = СтрокаТЧ.Версия;
		
		ВременныйФайл = КаталогВременныхФайлов() + "UpdInfo.txt";
		Соединение = Новый HTTPСоединение("downloads.1c.ru");
		Заголовки = Новый Соответствие;       
		
		ТекстHTTPЗапроса = Конфигурация.ТекстHTTPЗапроса;
		Если ТекстHTTPЗапроса = "" Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Неизвестная конфигурация (необходимо заполнить реквизит ""Текст HTTP запроса""): " + Конфигурация;
			Сообщение.Сообщить();
			Продолжить;
		КонецЕсли;
		
		HTTPЗапрос = Новый HTTPЗапрос(ТекстHTTPЗапроса, Заголовки);
		HTTPЗапрос.Заголовки.Вставить("Accept-Charset", "utf-8");
		HTTPОтвет = Соединение.Получить(HTTPЗапрос, ВременныйФайл);
		ФайлОтвета = Новый ЧтениеТекста(ВременныйФайл, КодировкаТекста.UTF8);
		ЗаголовкиОтвета = HTTPОтвет.Заголовки;
		СформироватьРезультат(Истина, ВременныйФайл, ЗаголовкиОтвета);
		СведенияОНовойВерсии = ПрочитатьТекстовыйФайл(ВременныйФайл);
		ФайлОтвета.Закрыть();
		Если ТекущаяВерсия <> СведенияОНовойВерсии.Version Тогда
			РегистрВерсий = РегистрыСведений.ВерсииТиповыхКонфигураций;
			ТекущаяВерсия = РегистрВерсий.ПолучитьПоследнее(ТекущаяДата(), Новый Структура("Конфигурация", Конфигурация)).Версия;
			Если ТекущаяВерсия <> СведенияОНовойВерсии.Version Тогда
				Набор = РегистрВерсий.СоздатьМенеджерЗаписи();
				Набор.Период = СведенияОНовойВерсии.UpdateDate;
				Набор.Конфигурация = Конфигурация;
				Набор.Версия = СведенияОНовойВерсии.Version;
				Набор.Записать();		
			КонецЕсли;

		КонецЕсли;	
	
	КонецЦикла;
КонецПроцедуры

// Функция - Прочитать текстовый файл
//
// Параметры:
//  ИмяФайла - Полное имя текстового файла - 
// 
// Возвращаемое значение:
// Структура - 
//
Функция ПрочитатьТекстовыйФайл(ИмяФайла) Экспорт
	
	Файл = Новый Файл(ИмяФайла);
	Если НЕ Файл.Существует() Тогда
		Возврат НСтр("ru = 'Файл описания обновлений не получен'");
	КонецЕсли;	
	ТекстовыйДокумент = Новый ТекстовыйДокумент(); 
	ТекстовыйДокумент.Прочитать(Файл.ПолноеИмя);
	ПараметрыКомплекта = Новый Структура();
	Для НомерСтроки = 1 По ТекстовыйДокумент.КоличествоСтрок() Цикл
		ВременнаяСтрока = НРег(СокрЛП(ТекстовыйДокумент.ПолучитьСтроку(НомерСтроки)));
		Если ПустаяСтрока(ВременнаяСтрока) Тогда
			Продолжить;
		КонецЕсли; 
		Если СтрНайти(ВременнаяСтрока,"fromversions=")>0 Тогда
			ВременнаяСтрока = СокрЛП(Сред(ВременнаяСтрока,Найти(ВременнаяСтрока,"fromversions=")+СтрДлина("fromversions=")));
			ВременнаяСтрока = ?(Лев(ВременнаяСтрока,1)=";","",";") + ВременнаяСтрока + ?(Прав(ВременнаяСтрока,1)=";","",";");
			ПараметрыКомплекта.Вставить("FromVersions",ВременнаяСтрока);
		ИначеЕсли СтрНайти(ВременнаяСтрока,"version=")>0 Тогда
			ПараметрыКомплекта.Вставить("Version",Сред(ВременнаяСтрока,Найти(ВременнаяСтрока,"version=")+СтрДлина("version=")));
		ИначеЕсли СтрНайти(ВременнаяСтрока,"updatedate=")>0 Тогда
			// формат даты = Дата, 
			ВременнаяСтрока = Сред(ВременнаяСтрока,Найти(ВременнаяСтрока,"updatedate=")+СтрДлина("updatedate="));
			Если СтрДлина(ВременнаяСтрока)>8 Тогда
				Если СтрНайти(ВременнаяСтрока,".")=5 Тогда
					// дата в формате  ГГГГ.ММ.ДД
					ВременнаяСтрока = СтрЗаменить(ВременнаяСтрока,".","");
				ИначеЕсли СтрНайти(ВременнаяСтрока,".")=3 Тогда
					// дата в формате ДД.ММ.ГГГГ
					ВременнаяСтрока = Прав(ВременнаяСтрока,4)+Сред(ВременнаяСтрока,4,2)+Лев(ВременнаяСтрока,2);
				Иначе 
					// дата в формате ГГГГММДД
				КонецЕсли;
			КонецЕсли;
			ПараметрыКомплекта.Вставить("UpdateDate",Дата(ВременнаяСтрока));
		Иначе
			Возврат НСтр("ru = 'Неверный формат сведений о наличии обновлений'");
		КонецЕсли;
	КонецЦикла;
	Если ПараметрыКомплекта.Количество() <> 3 Тогда 
		Возврат НСтр("ru = 'Неверный формат сведений о наличии обновлений'");
	КонецЕсли;
	Возврат ПараметрыКомплекта;
	
КонецФункции

Функция СформироватьРезультат(Знач Статус, Знач СообщениеПуть, ЗаголовкиОтвета = Неопределено) Экспорт 
	Результат = Новый Структура("Статус", Статус);
	Если Статус Тогда
		Результат.Вставить("Путь", СообщениеПуть);
	Иначе
		Результат.Вставить("СообщениеОбОшибке", СообщениеПуть);
	КонецЕсли;
	Если ЗаголовкиОтвета <> Неопределено Тогда
		Результат.Вставить("Заголовки", ЗаголовкиОтвета);
	КонецЕсли;
	Возврат Результат;
КонецФункции

Функция ПолучитьИспользуемуюВерсиюПлатформы() Экспорт 

	Возврат "8.3.13.1513";

КонецФункции // ПолучитьИспользуемуюВерсиюПлатформы()

Процедура ПодпискаНаСобытие1ПередЗаписью(Источник, Отказ) Экспорт
	// Вставить содержимое обработчика.
КонецПроцедуры
