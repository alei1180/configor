#Использовать logos

Перем Лог;
Перем Префикс;

Процедура ПриСозданииОбъекта(ПрефиксПеременныхСреды = "")
	Префикс = ПрефиксПеременныхСреды;
	Лог = Логирование.ПолучитьЛог("oscript.lib.configor.env");
КонецПроцедуры

#Область ПрограммныйИнтерфейс

// Возвращает приоритет провайдера
//
//  Возвращаемое значение:
//   Число - текущий приоритет провайдера
//
Функция Приоритет() Экспорт
	Возврат 2;
КонецФункции

// Возвращает идентификатор провайдера
//
//  Возвращаемое значение:
//   Строка - текущий идентификатор провайдера
//
Функция Идентификатор() Экспорт
	Возврат "env";
КонецФункции

// Возвращает тип провайдера
//
//  Возвращаемое значение:
//   Строка - текущий тип провайдера
//
Функция ТипПровайдера() Экспорт
	Возврат "env";
КонецФункции

// Выполняет чтение параметров для провайдера
//
// Параметры:
//   НастройкиПровайдера - Структура - структура настроек провайдера
//
//  Возвращаемое значение:
//   Соответствие - результат чтения провайдера
//
Функция ПрочитатьПараметры(НастройкиПровайдера) Экспорт

	Лог.Отладка("Выполняю чтение параметров переменных среды для префикса <%1>", Префикс);

	ПеременныеСреды = ПеременныеСреды();
	ПрочитанныеПараметры = Новый Соответствие;

	Для каждого ПеременнаяСреды Из ПеременныеСреды Цикл

		ПрочитанныеПараметры.Вставить(
			СтрЗаменить(СтрЗаменить(ПеременнаяСреды.Ключ, "_", "."), "..", "_"),
			ПеременнаяСреды.Значение
		);

	КонецЦикла;

	Результат = Новый Соответствие;

	Если ПустаяСтрока(Префикс) Тогда
		Результат = ПрочитанныеПараметры;
	Иначе

		Для каждого ПеременнаяСреды Из ПрочитанныеПараметры Цикл

			Если СтрНачинаетсяС(НРег(ПеременнаяСреды.Ключ), НРег(Префикс)) Тогда

				Результат.Вставить(
					Прав(ПеременнаяСреды.Ключ, СтрДлина(ПеременнаяСреды.Ключ) - (СтрДлина(Префикс) + 1)),
					ПеременнаяСреды.Значение
				);

			КонецЕсли;

		КонецЦикла;

	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти
