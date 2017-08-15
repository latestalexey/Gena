﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Записать настройку подтверждения завершения работы программы
// для текущего пользователя.
// 
// Параметры:
//   Значение - Булево   - значение настройки.
// 
Процедура СохранитьНастройкуПодтвержденияПриЗавершенииПрограммы(Значение) Экспорт
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ОбщиеНастройкиПользователя", "ЗапрашиватьПодтверждениеПриЗавершенииПрограммы", Значение);
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру параметров, необходимых для работы клиентского кода
// при запуске конфигурации, т.е. в обработчиках событий.
// - ПередНачаломРаботыСистемы,
// - ПриНачалеРаботыСистемы
//
Функция ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	ЗапомнитьВременныеПараметры(Параметры);
	
	Если Параметры.ПолученныеПараметрыКлиента <> Неопределено Тогда
		Если НЕ Параметры.Свойство("ПропуститьОчисткуСкрытияРабочегоСтола") Тогда
			СкрытьРабочийСтолПриНачалеРаботыСистемы(Ложь);
		КонецЕсли;
	КонецЕсли;
	
	ПривилегированныйРежимУстановленПриЗапуске = ПривилегированныйРежим();
	
	УстановитьПривилегированныйРежим(Истина);
	Если ПараметрыСеанса.ПараметрыКлиентаНаСервере.Количество() = 0 Тогда
		// Первый серверный вызов с клиента при запуске.
		ПараметрыКлиента = Новый Соответствие;
		ПараметрыКлиента.Вставить("ПараметрЗапуска", Параметры.ПараметрЗапуска);
		ПараметрыКлиента.Вставить("СтрокаСоединенияИнформационнойБазы", Параметры.СтрокаСоединенияИнформационнойБазы);
		ПараметрыКлиента.Вставить("ПривилегированныйРежимУстановленПриЗапуске", ПривилегированныйРежимУстановленПриЗапуске);
		ПараметрыКлиента.Вставить("ЭтоВебКлиент", Параметры.ЭтоВебКлиент);
		ПараметрыКлиента.Вставить("ЭтоВебКлиентПодMacOS", Параметры.ЭтоВебКлиентПодMacOS);
		ПараметрыКлиента.Вставить("ЭтоLinuxКлиент", Параметры.ЭтоLinuxКлиент);
		ПараметрыКлиента.Вставить("ИспользуемыйКлиент", Параметры.ИспользуемыйКлиент);
		ПараметрыКлиента.Вставить("ОперативнаяПамять", Параметры.ОперативнаяПамять);
		ПараметрыКлиента.Вставить("КаталогПрограммы", Параметры.КаталогПрограммы);
		ПараметрыСеанса.ПараметрыКлиентаНаСервере = Новый ФиксированноеСоответствие(ПараметрыКлиента);
		
		Если СтрНайти(НРег(Параметры.ПараметрЗапуска), НРег("ЗапуститьОбновлениеИнформационнойБазы")) > 0 Тогда
			ОбновлениеИнформационнойБазыСлужебный.УстановитьЗапускОбновленияИнформационнойБазы(Истина);
		КонецЕсли;
		Справочники.ВерсииРасширений.ПеререгистрироватьВерсиюРасширенийВРежимеОтладки();
		
		Если Не ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
			Если ПланыОбмена.ГлавныйУзел() <> Неопределено
			 Или ЗначениеЗаполнено(Константы.ГлавныйУзел.Получить()) Тогда
				// Предотвращение случайного обновления предопределенных данных в подчиненном узле РИБ:
				// - при запуске с временно отмененным главным узлом;
				// - при реструктуризации данных в процессе восстановления узла.
				Если ПолучитьОбновлениеПредопределенныхДанныхИнформационнойБазы()
				     <> ОбновлениеПредопределенныхДанных.НеОбновлятьАвтоматически Тогда
					УстановитьОбновлениеПредопределенныхДанныхИнформационнойБазы(
						ОбновлениеПредопределенныхДанных.НеОбновлятьАвтоматически);
				КонецЕсли;
				Если ПланыОбмена.ГлавныйУзел() <> Неопределено
				   И Не ЗначениеЗаполнено(Константы.ГлавныйУзел.Получить()) Тогда
				   // Сохранение главного узла для возможности восстановления.
					СтандартныеПодсистемыСервер.СохранитьГлавныйУзел();
					
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	
	Если НЕ СтандартныеПодсистемыСервер.ДобавитьПараметрыРаботыКлиентаПриЗапуске(Параметры) Тогда
		ФиксированныеПараметры = ФиксированныеПараметрыКлиентаБезВременныхПараметров(Параметры);
		Возврат ФиксированныеПараметры;
	КонецЕсли;
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентаПриЗапуске");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры);
	КонецЦикла;
	
	ПрикладныеПараметры = Новый Структура;
	ОбщегоНазначенияПереопределяемый.ПараметрыРаботыКлиентаПриЗапуске(ПрикладныеПараметры);
	
	Для Каждого Параметр Из ПрикладныеПараметры Цикл
		Параметры.Вставить(Параметр.Ключ, Параметр.Значение);
	КонецЦикла;
	
	ФиксированныеПараметры = ФиксированныеПараметрыКлиентаБезВременныхПараметров(Параметры);
	Возврат ФиксированныеПараметры;
	
КонецФункции

// Возвращает структуру параметров, необходимых для работы клиентского кода
// конфигурации. 
//
Функция ПараметрыРаботыКлиента() Экспорт
	
	Параметры = Новый Структура;
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиента");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриДобавленииПараметровРаботыКлиента(Параметры);
	КонецЦикла;
	
	ПрикладныеПараметры = Новый Структура;
	ОбщегоНазначенияПереопределяемый.ПараметрыРаботыКлиента(ПрикладныеПараметры);
	
	Для Каждого Параметр Из ПрикладныеПараметры Цикл
		Параметры.Вставить(Параметр.Ключ, Параметр.Значение);
	КонецЦикла;
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(Параметры);
	
КонецФункции

// Устанавливает состояние отмены при создании форм рабочего стола.
// Требуется, если при запуске программы возникает необходимость
// взаимодействия с пользователем (интерактивная обработка).
//
// Используется из одноименной процедуры в модуле СтандартныеПодсистемыКлиент.
// Прямой вызов на сервере имеет смысл для сокращения серверных вызовов,
// если при подготовке параметров клиента через модуль ПовтИсп уже
// известно, что интерактивная обработка требуется.
//
// Если прямой вызов сделан из процедуры получения параметров клиент,
// то состояние на клиенте будет обновлено автоматически, в другом случае
// это нужно сделать самостоятельно на клиенте с помощью одноименной процедуры
// в модуле СтандартныеПодсистемыКлиент.
//
// Параметры:
//  Скрыть - Булево. Если установить Истина, состояние будет установлено,
//           если установить Ложь, состояние будет снято (после этого
//           можно выполнить метод ОбновитьИнтерфейс и формы рабочего
//           стола будут пересозданы).
//
Процедура СкрытьРабочийСтолПриНачалеРаботыСистемы(Скрыть = Истина) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекущиеПараметры = Новый Соответствие(ПараметрыСеанса.ПараметрыКлиентаНаСервере);
	
	Если Скрыть = Истина Тогда
		ТекущиеПараметры.Вставить("СкрытьРабочийСтолПриНачалеРаботыСистемы", Истина);
		
	ИначеЕсли ТекущиеПараметры.Получить("СкрытьРабочийСтолПриНачалеРаботыСистемы") <> Неопределено Тогда
		ТекущиеПараметры.Удалить("СкрытьРабочийСтолПриНачалеРаботыСистемы");
	КонецЕсли;
	
	ПараметрыСеанса.ПараметрыКлиентаНаСервере = Новый ФиксированноеСоответствие(ТекущиеПараметры);
	
КонецПроцедуры

// Возвращает тип платформы строкой.
Функция ТипПлатформыСервераСтрокой() Экспорт
	
	СистемнаяИнфо = Новый СистемнаяИнформация;
	
	Если СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Linux_x86 Тогда
		Возврат "Linux_x86";
		
	ИначеЕсли СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
		Возврат "Linux_x86_64";
		
	ИначеЕсли СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Windows_x86 Тогда
		Возврат "Windows_x86";
		
	ИначеЕсли СистемнаяИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
		Возврат "Windows_x86_64";
		
	ИначеЕсли СистемнаяИнфо.ТипПлатформы = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Неизвестный тип платформы ""%1""'"), Строка(СистемнаяИнфо.ТипПлатформы));
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает структуру параметров, необходимых для работы клиентского кода
// конфигурации при завершении работы.
//
Функция ПараметрыРаботыКлиентаПриЗавершении() Экспорт
	
	Параметры = Новый Структура();
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииПараметровРаботыКлиентаПриЗавершении");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриДобавленииПараметровРаботыКлиентаПриЗавершении(Параметры);
	КонецЦикла;
	
	ПрикладныеПараметры = Новый Структура;
	ОбщегоНазначенияПереопределяемый.ПараметрыРаботыКлиентаПриЗавершении(ПрикладныеПараметры);
	
	Для Каждого Параметр Из ПрикладныеПараметры Цикл
		Параметры.Вставить(Параметр.Ключ, Параметр.Значение);
	КонецЦикла;
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(Параметры);
	
КонецФункции

// Только для внутреннего использования.
Процедура ПриОшибкеПолученияОбработчиковСобытия() Экспорт
	
	Если НЕ МонопольныйРежим() И ТранзакцияАктивна() Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено()
	 ИЛИ НЕ ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		// Автообновление кэша. Обновление повторно используемых значений требуется.
		
		Если НЕ МонопольныйРежим() Тогда
			Попытка
				УстановитьМонопольныйРежим(Истина);
			Исключение
				Возврат;
			КонецПопытки;
		КонецЕсли;
		
		Попытка
			Константы.ПараметрыСлужебныхСобытий.СоздатьМенеджерЗначения().Обновить();
		Исключение
			УстановитьМонопольныйРежим(Ложь);
			ОбновитьПовторноИспользуемыеЗначения();
			ВызватьИсключение;
		КонецПопытки;
		
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
КонецПроцедуры

// Только для внутреннего использования.
Функция ЗаписатьОшибкуВЖурналРегистрацииПриЗапускеИлиЗавершении(ПрекратитьРаботу, Знач Событие, Знач ТекстОшибки) Экспорт
	
	Если Событие = "Запуск" Тогда
		ИмяСобытия = НСтр("ru = 'Запуск программы'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		Если ПрекратитьРаботу Тогда
			НачалоОписанияОшибки = НСтр("ru = 'Возникла исключительная ситуация при запуске программы. Запуск программы аварийно завершен.'");
		Иначе
			НачалоОписанияОшибки = НСтр("ru = 'Возникла исключительная ситуация при запуске программы.'");
		КонецЕсли;
	Иначе
		ИмяСобытия = НСтр("ru = 'Завершение программы'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		НачалоОписанияОшибки = НСтр("ru = 'Возникла исключительная ситуация при завершении программы.'");
	КонецЕсли;
	
	ОписаниеОшибки = НачалоОписанияОшибки
		+ Символы.ПС + Символы.ПС
		+ ТекстОшибки;
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
	Возврат НачалоОписанияОшибки;

КонецФункции

// Вызывается из обработчика ожидания каждые 20 минут, например, для контроля
// динамического обновления и окончания срока действия учетной записи пользователя.
//
// Параметры:
//  Параметры - Структура - в структуру следует вставить свойства для дальнейшего анализа на клиенте.
//
Процедура ПриВыполненииСтандартныхПериодическихПроверокНаСервере(Параметры) Экспорт
	
	// СтандартныеПодсистемы.БазоваяФункциональность
	КонтрольДинамическогоОбновленияКонфигурацииСлужебный.ПриВыполненииСтандартныхПериодическихПроверокНаСервере(Параметры);
	// Конец СтандартныеПодсистемы.БазоваяФункциональность
	
	// СтандартныеПодсистемы.Пользователи
	ПользователиСлужебный.ПриВыполненииСтандартныхПериодическихПроверокНаСервере(Параметры);
	// Конец СтандартныеПодсистемы.Пользователи
	
КонецПроцедуры

// Возвращает полное имя объекта метаданных по его типу.
Функция ПолноеИмяОбъектаМетаданных(Тип) Экспорт
	ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
	Если ОбъектМетаданных = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	Возврат ОбъектМетаданных.ПолноеИмя();
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с предопределенными данными.

// Получает ссылку предопределенного элемента по его полному имени.
//  Подробнее - см. ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент();
//
Функция ПредопределенныйЭлемент(Знач ПолноеИмяПредопределенного) Экспорт
	
	Возврат СтандартныеПодсистемыПовтИсп.ПредопределенныйЭлемент(ПолноеИмяПредопределенного);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ЗапомнитьВременныеПараметры(Параметры)
	
	Параметры.Вставить("ИменаВременныхПараметров", Новый Массив);
	
	Для каждого КлючИЗначение Из Параметры Цикл
		Параметры.ИменаВременныхПараметров.Добавить(КлючИЗначение.Ключ);
	КонецЦикла;
	
КонецПроцедуры

Функция ФиксированныеПараметрыКлиентаБезВременныхПараметров(Параметры)
	
	ПараметрыКлиента = Параметры;
	Параметры = Новый Структура;
	
	Для каждого ИмяВременногоПараметра Из ПараметрыКлиента.ИменаВременныхПараметров Цикл
		Параметры.Вставить(ИмяВременногоПараметра, ПараметрыКлиента[ИмяВременногоПараметра]);
		ПараметрыКлиента.Удалить(ИмяВременногоПараметра);
	КонецЦикла;
	Параметры.Удалить("ИменаВременныхПараметров");
	
	УстановитьПривилегированныйРежим(Истина);
	
	Параметры.СкрытьРабочийСтолПриНачалеРаботыСистемы =
		ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить(
			"СкрытьРабочийСтолПриНачалеРаботыСистемы") <> Неопределено;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(ПараметрыКлиента);
	
КонецФункции

#КонецОбласти
