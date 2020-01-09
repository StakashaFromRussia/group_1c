
#Область ПроцедурыФункцииОбновленияТиповыхКонфигурацийИнформационныхБаз

Функция ПодготовитьТекстКомандыОбновленияИнформационнойБазы(ИнформационнаяБаза, РежимЗапуска, УстанавливаемаяВерсия) Экспорт 
	
	//Обновлять можем только полностью типовые конфигурации
	//1. Проверяем, стоит ли база на поддержке
	Если НЕ ИнформационнаяБаза.Типовая Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Конфигурация информационной базы снята с полной поддержки, автоматическое обновление невозможно.";
		Сообщение.Сообщить();
		Возврат "";
	КонецЕсли;
	
	ВерсияПлатформы = ОбщегоНазначенияСервер.ПолучитьИспользуемуюВерсиюПлатформы();
	КаталогСОбновлениями = "\\192.168.100.9\Exchange\Update_1c\1c";
	КаталогЛогов = "\\192.168.100.9\Exchange\Update_1c\log";
	РелизОбновления = УстанавливаемаяВерсия;
	КаталогКонфигурации = ИнформационнаяБаза.Конфигурация.НаименованиеКаталогаОбновлений;
	Сервер = ИнформационнаяБаза.Сервер;
	ИмяБазы = ИнформационнаяБаза.ИмяФайла;
	ЛогинПароль = ОбщегоНазначенияВызовСервера.ПолучитьЛогинПарольАдминистратора();
	КодРазрешения	= "/uc 14429";
	
	//Сначала собираем файлик
	ТекстФайла = "";
	ТекстФайла = ТекстФайла + "chcp 1251" + Символы.ПС;
	ТекстФайла = ТекстФайла + "setlocal" + Символы.ПС;
	ТекстФайла = ТекстФайла + "set bin_dir=""C:\Program Files\1cv8""" + Символы.ПС;
	ТекстФайла = ТекстФайла + "set bin_ver=" + ВерсияПлатформы + Символы.ПС;
	ТекстФайла = ТекстФайла + "set cfu_dir=" + КаталогСОбновлениями + Символы.ПС;
	ТекстФайла = ТекстФайла + "set log_dir=" + КаталогЛогов + Символы.ПС;
	
	ТекстФайла = ТекстФайла + "set cfu=" + РелизОбновления + Символы.ПС;
	ТекстКоманды = ТекстФайла + "%bin_dir%\%bin_ver%\bin\1cv8.exe " + РежимЗапуска + " /S " + Сервер + "\" + ИмяБазы + " /N" + ЛогинПароль.Логин + " /P" + ЛогинПароль.Пароль + " " + КодРазрешения + " /UpdateCfg %cfu_dir%\" + КаталогКонфигурации +"\%cfu%\1Cv8.cfu /UpdateDBCfg /Out %log_dir%\Vector_" + ИмяБазы + "_" + РежимЗапуска + "_%cfu%.log" + Символы.ПС;
	
	Возврат ТекстКоманды;
	
КонецФункции // ПодготовитьТекстКомандыОбновленияИнформационнойБазы()

Функция ВыбратьРелизДляУстановки(ИнформационнаяБаза) Экспорт 

	МассивВерсий = Новый Массив;
	НужнаяВерсия = "";
	Конфигурация = ИнформационнаяБаза.Конфигурация;
	//Получаем текущую версию конфигурации информационной базы
	УстановленнаяВерсия = РегистрыСведений.СостояниеКонфигурацийИнформационныхБаз.ПолучитьПоследнее(ТекущаяДата(), Новый Структура("Конфигурация, ИнформационнаяБаза", Конфигурация, ИнформационнаяБаза)).Версия;
	
	//Обходим каталог с обновлениями и собираем цепочку обновлений
	КаталогПоиска = "\\192.168.100.9\Exchange\Update_1c\1c\" + Конфигурация.НаименованиеКаталогаОбновлений;
	КаталогиВерсий = НайтиФайлы(КаталогПоиска, "*.*");
	
	Для каждого Версия Из КаталогиВерсий Цикл
	
		ВременныйФайл = Версия.ПолноеИмя + "\UpdInfo.txt";
		СведенияОНовойВерсии = ОбщегоНазначенияСервер.ПрочитатьТекстовыйФайл(ВременныйФайл);
		Если НЕ СтрНайти(СведенияОНовойВерсии.FromVersions, УстановленнаяВерсия) = 0 Тогда
			МассивВерсий.Добавить(СведенияОНовойВерсии.Version);
			УстановленнаяВерсия = СведенияОНовойВерсии.Version;
		КонецЕсли;
	КонецЦикла;
	
	////Получаем актуальную версию конфигурации
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ ПЕРВЫЕ 10
	//	|	ВерсииТиповыхКонфигураций.Период КАК Период,
	//	|	ВерсииТиповыхКонфигураций.Конфигурация КАК Конфигурация,
	//	|	ВерсииТиповыхКонфигураций.Версия КАК Версия
	//	|ИЗ
	//	|	РегистрСведений.ВерсииТиповыхКонфигураций КАК ВерсииТиповыхКонфигураций
	//	|ГДЕ
	//	|	ВерсииТиповыхКонфигураций.Конфигурация = &Конфигурация
	//	|
	//	|УПОРЯДОЧИТЬ ПО
	//	|	Период УБЫВ";
	//
	//Запрос.УстановитьПараметр("Конфигурация", Конфигурация);
	//ТаблицаВерсийКонфигураций = Запрос.Выполнить().Выгрузить();
	//
	//МассивВерсий = Новый Массив;
	//Для каждого ВерсияКонфигурации Из ТаблицаВерсийКонфигураций Цикл
	//	
	//	Если ВерсияКонфигурации.Версия = УстановленнаяВерсия Тогда
	//		//Обновление не требуется
	//		Прервать;
	//	КонецЕсли;
	//	//Проверяем возможность обновления установленной версии до актуальной
	//	ВременныйФайл = "\\192.168.100.9\Exchange\Update_1c\1c\" + Конфигурация.НаименованиеКаталогаОбновлений + "\" + СтрЗаменить(ВерсияКонфигурации.Версия, ".", "_") + "\" + "UpdInfo.txt";
	//	
	//	СведенияОНовойВерсии = ОбщегоНазначенияСервер.ПрочитатьТекстовыйФайл(ВременныйФайл);
	//	Если НЕ СтрНайти(СведенияОНовойВерсии.FromVersions, УстановленнаяВерсия) = 0 Тогда
	//		//НужнаяВерсия = СведенияОНовойВерсии.Version;
	//		МассивВерсий.Добавить(СведенияОНовойВерсии.Version);
	//		Прервать;
	//	Иначе
	//		МассивВерсий.Добавить(СведенияОНовойВерсии.Version);
	//	КонецЕсли;
	//КонецЦикла;

	Возврат МассивВерсий;
КонецФункции // ВыбратьРелизДляУстановки(ИнформационнаяБаза)

#КонецОбласти

// Функция - Получить данные для COMСоединения
//
// Параметры:
//  ИнформационнаяБаза	 - СправочникСсылка.ИнформационнаяБаза - информационная база, к которой производится подключение
// 
// Возвращаемое значение:
//  Структура - структура данных, необходимых для подключения к информационной базе
//
Функция ПолучитьДанныеДляCOMСоединения(ИнформационнаяБаза) Экспорт 

	Возврат Справочники.ИнформационныеБазы.ПолучитьДанныеДляCOMСоединения(ИнформационнаяБаза);

КонецФункции // ПолучитьДанныеДляCOMСоединения()

Функция ПолучитьДанныеДляОбновленияИБ(ИнформационнаяБаза)
	
	

КонецФункции // ПолучитьДанныеДляОбновленияИБ(ИнформационнаяБаза)

Процедура ОбновитьСписокИБНаСервере(ИнформационнаяБаза) Экспорт
	
	Если ИнформационнаяБаза.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	База = ИнформационнаяБаза.ПолучитьОбъект();
	КонфигурацияВерсия = ОбщегоНазначенияКлиентСервер.ПолучитьКонфигурациюИВерсиюБазы(База);
	База.Конфигурация = КонфигурацияВерсия.Конфигурация;
	База.Записать();
	Если ЗначениеЗаполнено(КонфигурацияВерсия.Конфигурация)
		И ЗначениеЗаполнено(КонфигурацияВерсия.Версия) Тогда
		НаборЗаписей = РегистрыСведений.СостояниеКонфигурацийИнформационныхБаз.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ИнформационнаяБаза.Установить(ИнформационнаяБаза);
		НаборЗаписей.Отбор.Конфигурация.Установить(КонфигурацияВерсия.Конфигурация);
		НаборЗаписей.Прочитать();
		Если НаборЗаписей.Количество() = 0 Тогда
			
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.Период = НачалоГода(ТекущаяДата());
			НоваяЗапись.Конфигурация = КонфигурацияВерсия.Конфигурация;
			НоваяЗапись.ИнформационнаяБаза = ИнформационнаяБаза;
			НоваяЗапись.Версия = КонфигурацияВерсия.Версия;
			//НоваяЗапись.ДатаОбновления = НачалоГода(ТекущаяДата());
			
			НаборЗаписей.Записать();
		Иначе
			ЗаписьСуществует = Ложь;
			Для каждого Запись Из НаборЗаписей Цикл
				Если КонфигурацияВерсия.Версия = Запись.Версия Тогда
					ЗаписьСуществует = Истина;
				КонецЕсли;
			КонецЦикла;
			Если НЕ ЗаписьСуществует Тогда
				НоваяЗапись = НаборЗаписей.Добавить();
				НоваяЗапись.Период = ТекущаяДата();
				НоваяЗапись.Конфигурация = КонфигурацияВерсия.Конфигурация;
				НоваяЗапись.ИнформационнаяБаза = ИнформационнаяБаза;
				НоваяЗапись.Версия = КонфигурацияВерсия.Версия;
				//НоваяЗапись.ДатаОбновления = ТекущаяДата();
				НаборЗаписей.Записать();
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = "Отредактирована: " + ИнформационнаяБаза;
	Сообщение.Сообщить();
КонецПроцедуры

Функция ПолучитьСтруктуруСоответствийКонфигураийНаименованиям() Экспорт 
	КонфигурацияНаименование = Новый Соответствие;
	НаименованиеКонфигурация = Новый Соответствие;
	КонфигурацииВыборка = Справочники.Конфигурации.Выбрать();
	Пока КонфигурацииВыборка.Следующий() Цикл
		СтруктураСоответствий = Новый Структура("КонфигурацияНаименование, НаименованиеКонфигурация", КонфигурацияНаименование, НаименованиеКонфигурация);
		КонфигурацияНаименование.Вставить(КонфигурацииВыборка.Ссылка, КонфигурацииВыборка.НаименованиеПолное);
		НаименованиеКонфигурация.Вставить(КонфигурацииВыборка.НаименованиеПолное, КонфигурацииВыборка.Ссылка);
	КонецЦикла;
	Возврат СтруктураСоответствий;
КонецФункции // ПолучитьСтруктуруСоответствийКонфигураийНаименованиям()

Функция ПолучитьЛогинПарольАдминистратора() Экспорт 

	Логин = Константы.АдминистраторИБЛогин.Получить();
	Пароль = Константы.АдминистраторИБПароль.Получить();

	Возврат Новый Структура("Логин, Пароль", Логин, Пароль);

КонецФункции // ПолучитьЛогинПарольАдминистратора()

Функция ЭтоГруппыИнформационнойБазы(ИнформационнаяБаза) Экспорт 

	Возврат ИнформационнаяБаза.ЭтоГруппа;

КонецФункции // ЭтоГруппыИнформационнойБазы(ИнформационнаяБаза)

// Функция - Получить параметры запуска информационной базы
//
// Параметры:
//  ИнформационнаяБаза	 - СправочникСсылка.ИнформационнаяБаза - 
// 
// Возвращаемое значение:
//   - 
//
Функция ПолучитьПараметрыЗапускаИнформационнойБазы(ИнформационнаяБаза) Экспорт 

	Структура = Новый Структура;
	Структура.Вставить("ВерсияПлатформы"	, ОбщегоНазначенияСервер.ПолучитьИспользуемуюВерсиюПлатформы());
	Структура.Вставить("Сервер"				, ИнформационнаяБаза.Сервер);
	Структура.Вставить("ИмяФайла"			, ИнформационнаяБаза.ИмяФайла);
	Структура.Вставить("Логин"				, Константы.АдминистраторИБЛогин.Получить());
	Структура.Вставить("Пароль"				, Константы.АдминистраторИБПароль.Получить());
	//Структура.Вставить("", );

	Возврат Структура;
КонецФункции // ПолучитьПараметрыЗапускаИнформационнойБазы()
