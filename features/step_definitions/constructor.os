﻿// Реализация шагов BDD-фич/сценариев c помощью фреймворка https://github.com/artbear/1bdd
#Использовать asserts
#Использовать json

Перем БДД; //контекст фреймворка 1bdd

// Метод выдает список шагов, реализованных в данном файле-шагов
Функция ПолучитьСписокШагов(КонтекстФреймворкаBDD) Экспорт
	БДД = КонтекстФреймворкаBDD;

	ВсеШаги = Новый Массив;

	ВсеШаги.Добавить("ЯПодключаюТестовыйКлассОписанияПараметров");
	ВсеШаги.Добавить("ЗначениеПараметраКлассаРавно");
	ВсеШаги.Добавить("ЯДобавляюПолеСТипомИЗначениемДляПараметров");
	ВсеШаги.Добавить("ЯСоздаюНовыеПараметрыСИменемИСохраняюВ");
	ВсеШаги.Добавить("ЯДобавляюПолеИзОбъектаДляПараметров");
	ВсеШаги.Добавить("ЯДобавляюПолеМассивСТипомДляПараметров");
	ВсеШаги.Добавить("ЯДобавляюПолеМассивИзОбъектовДляПараметров");

	Возврат ВсеШаги;
КонецФункции

// Реализация шагов

// Процедура выполняется перед запуском каждого сценария
Процедура ПередЗапускомСценария(Знач Узел) Экспорт
	
КонецПроцедуры

// Процедура выполняется после завершения каждого сценария
Процедура ПослеЗапускаСценария(Знач Узел) Экспорт
	
КонецПроцедуры

//Я подключаю тестовый класс описания параметров
Процедура ЯПодключаюТестовыйКлассОписанияПараметров() Экспорт

	КлассПараметров = ПодготовитьТестовыйКласс();
	МенеджерПараметров = БДД.ПолучитьИзКонтекста("МенеджерПараметров");
	МенеджерПараметров.КонструкторПараметров(КлассПараметров);

	БДД.СохранитьВКонтекст("КлассПараметров", КлассПараметров);

КонецПроцедуры

//Прочитанные параметры равны файлу ".config.yaml" в каталоге проекта
Процедура ПрочитанныеПараметрыРавныФайлуВКаталогеПроекта(Знач ИмяФайлаПараметров) Экспорт

	КаталогПроекта = БДД.ПолучитьИзКонтекста("КаталогПроекта");

	Чтение = Новый ЧтениеТекста(ОбъединитьПути(КаталогПроекта, ИмяФайлаПараметров), КодировкаТекста.UTF8);
	ТекстФайлаПараметров = Чтение.Прочитать();
	Чтение.Закрыть();

	КлассПараметров = БДД.ПолучитьИзКонтекста("КлассПараметров");
	ПараметрыКласса = КлассПараметров.Параметры();

	ПарсерJSON = Новый ПарсерJSON;
	
	ПараметрыКласса = КлассПараметров.Параметры();
	ТекстПроверки = ПарсерJSON.ЗаписатьJSON(ПараметрыКласса);

	Утверждения.ПроверитьРавенство(ТекстФайлаПараметров, ТекстПроверки, "Результат должен совпадать с ожиданиями.");

КонецПроцедуры

//Значение параметра класса "releases.repo.owner" равно "owner"
Процедура ЗначениеПараметраКлассаРавно(Знач ИмяПараметра, Знач ТребуемоеЗначениеПараметра) Экспорт

	КлассПараметров = БДД.ПолучитьИзКонтекста("КлассПараметров");
	ПараметрыКласса = КлассПараметров.Параметры();

	ЗначениеПараметра = ПолучитьЗначениеКлюча(ИмяПараметра, ПараметрыКласса);
	Утверждения.ПроверитьРавенство(ЗначениеПараметра, ТребуемоеЗначениеПараметра, "Результат должен совпадать с ожиданиями");

КонецПроцедуры

//Я добавляю поле "" с типом "Строка" и значением "" для параметров "МенеджерПараметров"
Процедура ЯДобавляюПолеСТипомИЗначениемДляПараметров(Знач ИмяПоля, Знач ТипПоля, Знач ЗначениеПоУмолчанию, Знач ИмяКонструктораПараметров) Экспорт

	ТекущийКонструкторПараметров = БДД.ПолучитьИзКонтекста(ИмяКонструктораПараметров);
	
	Если ТипЗнч(ТекущийКонструкторПараметров) = Тип("МенеджерПараметров") Тогда
		ТекущийКонструкторПараметров = ТекущийКонструкторПараметров.КонструкторПараметров();
	КонецЕсли;

	Если ТипПоля = "Строка" Тогда
	
		ТекущийКонструкторПараметров.ПолеСтрока(ИмяПоля, ЗначениеПоУмолчанию);
	
	ИначеЕсли ТипПоля = "Число" Тогда

		Если ЗначениеЗаполнено(ЗначениеПоУмолчанию) Тогда
			ЗначениеПоУмолчанию = Число(ЗначениеПоУмолчанию);
		Иначе
			ЗначениеПоУмолчанию = Неопределено;
		КонецЕсли;

		ТекущийКонструкторПараметров.ПолеЧисло(ИмяПоля, ЗначениеПоУмолчанию);

	ИначеЕсли ТипПоля = "Дата" Тогда

		Если ЗначениеЗаполнено(ЗначениеПоУмолчанию) Тогда
			ЗначениеПоУмолчанию = Дата(ЗначениеПоУмолчанию);
		Иначе
			ЗначениеПоУмолчанию = Неопределено;
		КонецЕсли;

		ТекущийКонструкторПараметров.ПолеДата(ИмяПоля, ЗначениеПоУмолчанию);

	ИначеЕсли ТипПоля = "Булево" Тогда

		Если ЗначениеЗаполнено(ЗначениеПоУмолчанию) Тогда
			ЗначениеПоУмолчанию = Булево(ЗначениеПоУмолчанию);
		Иначе
			ЗначениеПоУмолчанию = Ложь;
		КонецЕсли;

		ТекущийКонструкторПараметров.ПолеБулево(ИмяПоля, ЗначениеПоУмолчанию);

	Иначе
		ВызватьИсключение Новый ИнформацияОбОшибке("Шаг <ЯСоздаюНовыеПараметрыСИменемИСохраняюВ> передан не правильный тип", "Передан не правильный тип поля.");
	КонецЕсли;

	
КонецПроцедуры

//Я создаю новые параметры с именем "Глобальные globals" и сохраняю в "Глобальные"
Процедура ЯСоздаюНовыеПараметрыСИменемИСохраняюВ(Знач ИмяКонструктораПараметров, Знач ИмяПеременной) Экспорт

	МенеджерПараметров = БДД.ПолучитьИзКонтекста("МенеджерПараметров");
	ПараметрОбъект = МенеджерПараметров.НовыйКонструкторПараметров(ИмяКонструктораПараметров);

	БДД.СохранитьВКонтекст(ИмяПеременной, ПараметрОбъект);

КонецПроцедуры

//Я добавляю поле "Объект" из объекта "" для параметров "Глобальные"
Процедура ЯДобавляюПолеИзОбъектаДляПараметров(Знач ИмяПоля, Знач ИмяПеременнойОбъекта, Знач ИмяКонструктораПараметров) Экспорт

	ТекущийКонструкторПараметров = БДД.ПолучитьИзКонтекста(ИмяКонструктораПараметров);
	ОбъектПоля = БДД.ПолучитьИзКонтекста(ИмяПеременнойОбъекта);

	ТекущийКонструкторПараметров = БДД.ПолучитьИзКонтекста(ИмяКонструктораПараметров);
	
	Если ТипЗнч(ТекущийКонструкторПараметров) = Тип("МенеджерПараметров") Тогда
		ТекущийКонструкторПараметров = ТекущийКонструкторПараметров.КонструкторПараметров();
	КонецЕсли;

	ТекущийКонструкторПараметров.ПолеОбъект(ИмяПоля, ОбъектПоля);
	
КонецПроцедуры

//Я добавляю поле "Массив" массив с типом "Строка" для параметров "Глобальные"
Процедура ЯДобавляюПолеМассивСТипомДляПараметров(Знач ИмяПоля, Знач ТипПоля, Знач ИмяКонструктораПараметров) Экспорт
	Конструктор = БДД.ПолучитьИзКонтекста(ИмяКонструктораПараметров);
	Если ТипЗнч(Конструктор) = Тип("МенеджерПараметров") Тогда
		Конструктор = Конструктор.КонструкторПараметров();
	КонецЕсли;
	Конструктор.ПолеМассив(ИмяПоля, Тип(ТипПоля));
КонецПроцедуры

//Я добавляю поле "МассивОбъектов" массив из объектов "Строка" для параметров "Глобальные"
Процедура ЯДобавляюПолеМассивИзОбъектовДляПараметров(Знач ИмяПоля, Знач ИмяПеременнойОбъекта, Знач ИмяКонструктораПараметров) Экспорт

	Конструктор = БДД.ПолучитьИзКонтекста(ИмяКонструктораПараметров);
	Если ТипЗнч(Конструктор) = Тип("МенеджерПараметров") Тогда
		Конструктор = Конструктор.КонструкторПараметров();
	КонецЕсли;
	ОбъектПоля = БДД.ПолучитьИзКонтекста(ИмяПеременнойОбъекта);
	Конструктор.ПолеМассив(ИмяПоля, ОбъектПоля);

КонецПроцедуры

Функция ПолучитьЗначениеКлюча(ИмяКлюча, Параметры)

	МассивКлючей = СтрРазделить(ИмяКлюча, ".", Ложь);

	ЗначениеКлюча = Неопределено;

	ПервыйПроход = Истина;

	Для каждого Ключ Из МассивКлючей Цикл

		Если ПервыйПроход Тогда
			ЗначениеКлюча = Параметры[Ключ];
			ПервыйПроход = Ложь;
		Иначе
			ЗначениеКлюча = ЗначениеКлюча[Ключ];
		КонецЕсли;
		
	КонецЦикла;

	Возврат ЗначениеКлюча;

КонецФункции

Функция КаталогFixtures()
	Возврат ОбъединитьПути(КаталогБиблиотеки(), "tests", "fixtures");
КонецФункции

Функция КаталогБиблиотеки()
	Возврат ОбъединитьПути(ТекущийСценарий().Каталог, "..", "..");
КонецФункции

Функция ПодготовитьТестовыйКласс()

	Возврат ЗагрузитьСценарий(ОбъединитьПути(КаталогFixtures(), "ТестовыйКласс.os"));

КонецФункции
