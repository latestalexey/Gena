﻿
&НаКлиенте
Процедура КодПриИзменении(Элемент)
	
	СформироватьНаименованиеИзКода();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьНаименованиеИзКода()
	
	Если не ЗначениеЗаполнено(Объект.Код) Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Наименование) Тогда 
		Возврат;
	КонецЕсли;	
	
	Результат = Прав(Объект.Код, СтрДлина(Объект.Код) -1);
	
	МассивСимволовДляОбхода = СтроковыеФункцииКлиентСервер.ПолучитьМассивыСимволов("КирилицаЗаглавная,ЛатиницаЗаглавная");
	Для Каждого ПроверяемыйСимвол из МассивСимволовДляОбхода Цикл 
		
		Результат = СтрЗаменить(Результат, ПроверяемыйСимвол, " "+НРег(ПроверяемыйСимвол));
	
	КонецЦикла;
	
	Результат = Лев(Объект.Код,1) + Результат;
	
	Объект.Наименование = Результат;
	
КонецПроцедуры	
