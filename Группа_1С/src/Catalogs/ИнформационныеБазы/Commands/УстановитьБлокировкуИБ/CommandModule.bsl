
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("МассивБаз, УстановкаСнятиеБлокировки", ПараметрКоманды, Истина);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПослеУстановкиСнятияБлокировки", ОбщегоНазначенияКлиент, ПараметрыФормы);
	ОткрытьФорму("ОбщаяФорма.ФормаУстановкиБлокировкиСеансов", ПараметрыФормы,,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры
