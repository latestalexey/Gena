﻿
&НаКлиенте
Процедура Сформировать(Команда)
	
	ТекстИсходящий = "";
	
	МассивСтрок = СтрРазделить(ТекстВходящий,Символы.ПС);
	Счетчик = 0;
	
	Для Каждого СтрокаМассива из МассивСтрок Цикл 
		Счетчик = Счетчик + 1;
		ПараметрыСтроки = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Счетчик);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ПараметрыСтроки, СтрРазделить(СтрокаМассива,","));
		
		БлокСтроки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтрокуИзМассива(Шаблон, ПараметрыСтроки);
		     
		Если ЗначениеЗаполнено(ТекстИсходящий) Тогда 
			ТекстИсходящий = ТекстИсходящий + Символы.ПС;
		КонецЕсли;
		
		ТекстИсходящий = ТекстИсходящий + БлокСтроки;
		
	КонецЦикла;	
	
КонецПроцедуры
