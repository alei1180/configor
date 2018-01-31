Перем ТекущийПрефиксКлючаДляЧтенияВложенногоФайлаНастроек;

Функция НовыйМенеджерПараметров(ИмяФайлаПараметров, КаталогПоиска = "", Провайдер = "json;yaml", КлассПараметров = Неопределено) Экспорт
	
	МенеджерПараметров = Новый МенеджерПараметров(Провайдер);

	МенеджерПараметров.УстановитьИмяФайла(ИмяФайлаПараметров);

	Если ЗначениеЗаполнено(КаталогПоиска) Тогда
		МенеджерПараметров.ДобавитьКаталогПоиска(КаталогПоиска);
	КонецЕсли;

	Если ЗначениеЗаполнено(КлассПараметров) Тогда
		МенеджерПараметров.УстановитьКлассПриемник(КлассПараметров);
	КонецЕсли;

	Возврат МенеджерПараметров;

КонецФункции

Процедура УстановитьПрефиксКлючаДляЧтенияВложенногоФайлаНастроек(Знач НовыйПрефикс)
	ТекущийПрефиксКлючаДляЧтенияВложенногоФайлаНастроек = НовыйПрефикс;
КонецПроцедуры

Функция ПрефиксКлючаДляЧтенияВложенногоФайлаНастроек()
	Возврат ТекущийПрефиксКлючаДляЧтенияВложенногоФайлаНастроек;
КонецФункции

ТекущийПрефиксКлючаДляЧтенияВложенногоФайлаНастроек = "ReadFile";