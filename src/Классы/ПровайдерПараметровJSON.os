#Использовать json
#Использовать asserts
#Использовать logos

Перем Лог;

#Область ПрограммныйИнтерфейс

// Выполняет чтение параметров 
//
// Параметры:
//   ПараметрыПровайдера - Структура - структура настроек провайдера
// Возвращаемое значение:
//   Соответствие - итоговые параметры
//
Функция ПрочитатьПараметры(ПараметрыПровайдера) Экспорт
	
	ПрочитанныеПараметры = Новый Соответствие;

	Если ЗначениеЗаполнено(ПараметрыПровайдера.ФайлПараметров) Тогда
		
		ФайлПараметров = Новый Файл(ПараметрыПровайдера.ФайлПараметров);

		Если Не ФайлПараметров.Существует() Тогда
			Лог.Отладка("Не найден файл параметров <%1>", ФайлПараметров.ПолноеИмя);
			Возврат ПрочитанныеПараметры;
		КонецЕсли;

		Лог.Отладка("Выполняю чтение файла параметров <%1>", ФайлПараметров.ПолноеИмя);
		ПрочитанныеПараметры = Прочитать(ФайлПараметров.ПолноеИмя);

	Иначе

		Если НЕ ЗначениеЗаполнено(ПараметрыПровайдера.ИмяФайлаПараметров) Тогда
			ВызватьИсключение СтрШаблон("Не задано имя файла параметров");
		КонецЕсли;

		Если ПараметрыПровайдера.КаталогиПоиска.Количество() = 0  Тогда
			ВызватьИсключение СтрШаблон("Не заданы пути поиска файла параметров");
		КонецЕсли;

		ПутьКФайлуПараметров = НайтиФайлПараметров(ПараметрыПровайдера.КаталогиПоиска, 
												ПараметрыПровайдера.ИмяФайлаПараметров,
												ПараметрыПровайдера.РасширениеФайла);

		Если НЕ ЗначениеЗаполнено(ПутьКФайлуПараметров) Тогда
			Лог.Отладка("Не найден файл параметров <%1>", ПутьКФайлуПараметров);
			Возврат ПрочитанныеПараметры;
		КонецЕсли;

		ПрочитанныеПараметры = Прочитать(ПутьКФайлуПараметров);

	КонецЕсли;
	
	Возврат ПрочитанныеПараметры;

КонецФункции

Функция НайтиФайлПараметров(КаталогиПоиска, ИмяФайлаПараметров, РасширениеФайлаПараметров)

	РасширениеФайлов = ".json";

	Если ЗначениеЗаполнено(РасширениеФайлаПараметров) Тогда
		
		РасширениеФайлов = РасширениеФайлаПараметров;

	КонецЕсли;

	МассивИменФайлов = Новый Массив;
	МассивРасширений = СтрРазделить(РасширениеФайлов, ";", Ложь);

	Для каждого РасширениеФайла Из МассивРасширений Цикл
		
		Если Не СтрНачинаетсяС(РасширениеФайла, ".") Тогда
			РасширениеФайла = "." + РасширениеФайла;
		КонецЕсли;

		МассивИменФайлов.Добавить(ИмяФайлаПараметров + РасширениеФайла);

	КонецЦикла;

	НайденныйФайл = Неопределено;

	Для каждого ПутьПоиска Из КаталогиПоиска Цикл

		Лог.Отладка("  поиск в каталоге <%1>", ПутьПоиска);

		Для каждого ФайлПоиска Из МассивИменФайлов Цикл

			ФайлПараметровПоиска = Новый Файл(ОбъединитьПути(ПутьПоиска, ФайлПоиска));

			Лог.Отладка("    ищю файл <%1>", ОбъединитьПути(ПутьПоиска, ФайлПоиска));
	
			Если Не ФайлПараметровПоиска.Существует() Тогда
				Продолжить;
			КонецЕсли;

			НайденныйФайл = ФайлПараметровПоиска.ПолноеИмя;
			Прервать;

		КонецЦикла;

		Если Не НайденныйФайл = Неопределено Тогда
			
			Лог.Отладка("Использую файл параметров <%1>", НайденныйФайл);
			Прервать;
			
		КонецЕсли;

	КонецЦикла;

	Возврат НайденныйФайл;

КонецФункции

// Выполнить чтение настроек из файла
//
// Параметры:
//   ПутьКФайлуНастройки - Cтрока - путь к файлу настроек
// Возвращаемое значение:
//   Соответствие - итоговые параметры
//
Функция Прочитать(Знач ПутьКФайлуНастройки)

	НастройкиИзФайла = Новый Соответствие;

	Попытка

		Лог.Отладка("ПутьКФайлуНастройки <%1>", ПутьКФайлуНастройки);

		НастройкиИзФайла = ПрочитатьНастройкиИзПараметраФайл(ПутьКФайлуНастройки);

		ОбработатьШаблонныеПодстановки(НастройкиИзФайла);

		Лог.Отладка("Итоговые параметры:");
		ПоказатьПараметрыВРежимеОтладки(НастройкиИзФайла);
	Исключение
		Лог.Ошибка("Ошибка чтения настроек
		|%1", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	
		ВызватьИсключение;
	КонецПопытки;

	Возврат НастройкиИзФайла;

КонецФункции // Прочитать

Функция ПрочитатьНастройкиИзПараметраФайл(ПутьКФайлуНастройки)

	ФайлНастроек = Новый Файл(ПутьКФайлуНастройки);

	НастройкиИзФайла = ПрочитатьФайлJSON(ФайлНастроек.ПолноеИмя);

	ОбработатьПараметрыРекурсивно(НастройкиИзФайла, ФайлНастроек.Путь);

	Возврат НастройкиИзФайла;

КонецФункции // ПрочитатьНастройкиИзПараметраФайл()

Функция ПрочитатьФайлJSON(Знач ИмяФайла)
	Перем Параметры;

	Лог.Отладка("Путь файла настроек <%1>", ИмяФайла);

	СообщениеОшибки = СтрШаблон("Файл настроек не существует. Путь <%1>", ИмяФайла);
	JsonСтрока  = ПрочитатьФайл(ИмяФайла, СообщениеОшибки);

	Лог.Отладка("Текст файла настроек:
	|%1", JsonСтрока);

	JsonСтрока = ВырезатьКомментарииИзТекстаJSON(JsonСтрока);

	ПарсерJSON  = Новый ПарсерJSON();
	Параметры   = ПарсерJSON.ПрочитатьJSON(JsonСтрока);

	Файл = Новый Файл(ИмяФайла);
	ПутьКаталогаФайла = Файл.Путь;

	ОбработатьПараметрыРекурсивно(Параметры, ПутьКаталогаФайла);

	Возврат Параметры;
КонецФункции

Функция ПрочитатьФайл(Знач ИмяФайла, Знач СообщениеОшибки)
	ФайлСуществующий = Новый Файл(ИмяФайла);
	Если Не ФайлСуществующий.Существует() Тогда
		ВызватьИсключение СообщениеОшибки;
	КонецЕсли;

	Чтение = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.UTF8);
	Рез  = Чтение.Прочитать();
	Чтение.Закрыть();
	Возврат Рез;
КонецФункции // ПрочитатьФайл()

Функция ВырезатьКомментарииИзТекстаJSON(Знач JsonСтрока)

	// вырезаем обычные комменты типа "// комментарий"
	Регулярка = Новый РегулярноеВыражение("(^\/\/.*$)");
	Рез = Регулярка.Заменить(JsonСтрока, "$0" );

	// вырезаем комменты после строки, например, "строка //комментарий"
	Регулярка = Новый РегулярноеВыражение("(^.*)(\/\/.*$)");
	Рез = Регулярка.Заменить(Рез, "$1" );

	Возврат Рез;
КонецФункции // ВырезатьКомментарииИзТекстаJSON()

Процедура ОбработатьПараметрыРекурсивно(Источник, ПутьКаталогаФайла)
	
	ПрефиксПараметрФайл = РаботаСПараметрами.ПрефиксКлючаДляЧтенияВложенногоФайлаНастроек();
	
	КлючиКДополнительномуЧтению = Новый Массив;

	Для каждого КлючЗначение Из Источник Цикл
		
		Ключ = КлючЗначение.Ключ;
		Значение = КлючЗначение.Значение;

		Если ТипЗнч(Значение) = Тип("Соответствие") Тогда

			ОбработатьПараметрыРекурсивно(Значение, ПутьКаталогаФайла);

		Иначе

			Если СтрНачинаетсяС( ВРег(Ключ), ВРег(ПрефиксПараметрФайл)) Тогда
				КлючиКДополнительномуЧтению.Добавить(Ключ);
			КонецЕсли;

		КонецЕсли;

	КонецЦикла;

	Для каждого Ключ Из КлючиКДополнительномуЧтению Цикл
		
		Значение = Источник[Ключ];
		
		ПрочитатьФайлИзЗначенияПараметра(Ключ, Значение, ПутьКаталогаФайла, Источник);
		
		Источник.Удалить(Ключ);

	КонецЦикла;

КонецПроцедуры

Функция ПрочитатьФайлИзЗначенияПараметра( Ключ, Значение, ПутьКаталогаФайла, Приемник)
	ПрефиксПараметрФайл = РаботаСПараметрами.ПрефиксКлючаДляЧтенияВложенногоФайлаНастроек();
	ЕстьПараметрФайл = СтрНачинаетсяС( ВРег(Ключ), ВРег(ПрефиксПараметрФайл) );

	Если НЕ ЕстьПараметрФайл Тогда
		Возврат Ложь;
	КонецЕсли;

	Лог.Отладка("Нашли ключ файла <%1>, значение <%2>, путь каталога-родителя <%3>", Ключ, Значение, ПутьКаталогаФайла);

	ПутьФайла = ОбъединитьПути(ПутьКаталогаФайла, Значение);
	Параметры = ПрочитатьФайлJSON(ПутьФайла);

	ОбработатьПараметрыРекурсивно(Параметры, ПутьКаталогаФайла);
		
	Для каждого КлючЗначение Из Параметры Цикл
		
		Ключ = КлючЗначение.Ключ;
		Значение = КлючЗначение.Значение;
	
		Приемник.Вставить(Ключ, Значение);

	КонецЦикла;
	
	Возврат Истина;
КонецФункции // ПрочитатьФайлИзЗначенияПараметра( Ключ, Значение, ПутьКаталогаФайла, Приемник)

Процедура ОбработатьШаблонныеПодстановки(Параметры)

	РегулярноеВыражение = Новый РегулярноеВыражение( "%([^%]*)%" );

	КоличествоПопыток = 5;

	Для Счетчик = 1 По КоличествоПопыток Цикл

		МассивПодстановок = Новый Массив;

		НайтиШаблонныеПодстановки(Параметры, МассивПодстановок, РегулярноеВыражение);

		Если НЕ ЗначениеЗаполнено(МассивПодстановок) Тогда
			Прервать;
		КонецЕсли;

		ЗначенияКлючей = Новый Соответствие;
		НайтиВсеКлючи(Параметры, ЗначенияКлючей);

		ВыполнитьПодстановки(МассивПодстановок, ЗначенияКлючей);

	КонецЦикла;

КонецПроцедуры

Процедура НайтиШаблонныеПодстановки(Параметры, Знач МассивПодстановок, Знач РегулярноеВыражение)

	Для каждого КлючЗначение Из Параметры Цикл
		Значение = КлючЗначение.Значение;
		Тип = ТипЗнч(Значение);
		Если Тип = Тип("Строка") Тогда
			КоллекцияСовпадений = РегулярноеВыражение.НайтиСовпадения( Значение );
			Если КоллекцияСовпадений.Количество() > 0 Тогда
				Описание = Новый Структура("Ключ, Параметры", КлючЗначение.Ключ, Параметры);
				Описание.Вставить("КоллекцияСовпадений", КоллекцияСовпадений);
				МассивПодстановок.Добавить(Описание);

				Лог.Отладка("Нашли значение для подстановки <%1>", Значение);
			КонецЕсли;

		ИначеЕсли Тип = Тип("Соответствие") Тогда
			НайтиШаблонныеПодстановки(Значение, МассивПодстановок, РегулярноеВыражение);
		КонецЕсли;

	КонецЦикла;
КонецПроцедуры

Процедура ВыполнитьПодстановки(МассивПодстановок, ЗначенияКлючей)
	Для каждого ОписаниеПодстановки Из МассивПодстановок Цикл
		КлючПодстановки = ОписаниеПодстановки.Ключ;

		КоллекцияСовпадений = ОписаниеПодстановки.КоллекцияСовпадений;
		Для каждого Совпадение Из КоллекцияСовпадений Цикл
			Значение = Совпадение.Значение;
			ИмяКлюча = Совпадение.Группы[1].Значение;
			Лог.Отладка("Нашли имя ключа <%1> для возможной подстановки в <%2>", ИмяКлюча, Значение);

			ЗначениеПоКлючу = ЗначенияКлючей[ИмяКлюча];
			Если ЗначениеПоКлючу <> Неопределено Тогда
				ОписаниеПодстановки.Параметры.Вставить(КлючПодстановки, ЗначениеПоКлючу);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

Процедура НайтиВсеКлючи(Параметры, ЗначенияКлючей)
	Для каждого КлючЗначение Из Параметры Цикл
		Ключ = КлючЗначение.Ключ;
		Значение = КлючЗначение.Значение;

		Если ТипЗнч(Значение) = Тип("Соответствие") Тогда
			НайтиВсеКлючи(Значение, ЗначенияКлючей);
		Иначе
			ЗначенияКлючей.Вставить(Ключ, Значение);
		КонецЕсли;

	КонецЦикла;
КонецПроцедуры

Процедура ПоказатьПараметрыВРежимеОтладки(ЗначенияПараметров, Знач Родитель = "")
	
	Если Родитель = "" Тогда
		Лог.Отладка("	Тип параметров %1", ТипЗнч(ЗначенияПараметров));
	КонецЕсли;
	
	Если ЗначенияПараметров.Количество() = 0 Тогда
		Лог.Отладка("	Коллекция параметров пуста!");
	КонецЕсли;

	Для каждого Элемент Из ЗначенияПараметров Цикл
		
		ПредставлениеКлюча = Элемент.Ключ;
		
		Если Не ПустаяСтрока(Родитель) Тогда
			ПредставлениеКлюча  = СтрШаблон("%1.%2", Родитель, ПредставлениеКлюча);
		КонецЕсли;
		
		Лог.Отладка("	Получен параметр <%1> = <%2>", ПредставлениеКлюча, Элемент.Значение);
		
		Если ТипЗнч(Элемент.Значение) = Тип("Соответствие") Тогда
			ПоказатьПараметрыВРежимеОтладки(Элемент.Значение, ПредставлениеКлюча);
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

Лог = Логирование.ПолучитьЛог("oscript.lib.configor.provider-json");
