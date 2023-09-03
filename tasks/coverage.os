#Использовать coverage
#Использовать 1commands
#Использовать fs

СистемнаяИнформация = Новый СистемнаяИнформация;
ЭтоWindows = Найти(НРег(СистемнаяИнформация.ВерсияОС), "windows") > 0;

ФС.ОбеспечитьПустойКаталог("coverage");
ПутьКСтат = "coverage/stat.json";

Команда = Новый Команда;
Команда.УстановитьКоманду("oscript");
Если НЕ ЭтоWindows Тогда
	Команда.ДобавитьПараметр("-encoding=utf-8");
КонецЕсли;
Команда.ДобавитьПараметр(СтрШаблон("-codestat=%1", ПутьКСтат));
Команда.ДобавитьПараметр("tasks/test.os");
Команда.ПоказыватьВыводНемедленно(Истина);

КодВозврата = Команда.Исполнить();

ПроцессорГенерации = Новый ГенераторОтчетаПокрытия();

ПроцессорГенерации.ОтносительныеПути()
	.РабочийКаталог("coverage")
	.КаталогИсходников(ТекущийКаталог())
	.ИмяФайлаСтатистики()
	.GenericCoverage()
	.Cobertura()
	.Сформировать();

ЗавершитьРаботу(КодВозврата);
