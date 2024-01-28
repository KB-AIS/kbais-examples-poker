# Сервис проведения сессий "Покера планирования" 

### Основной сервис

* .NET 8
* [MartenDB](https://martendb.io/documents/) -- документоориентированная СУБД поверх PostgreSQL.
* [Telegram.Bot](https://telegrambots.github.io/book/) -- .NET клиент Telegram Bot API

## Разработка

Запуск dev окружения

```shell
docker-compose -p pocker-dev -f .\manifests\docker-compose.yml --env-file .\manifests\.env.dev up -d
```

## Описание 

### Акторы

SCRUM-мастер – участник команды, который инициирует сессии, ставит задачи на голосование, оценивает задачи, принимает оценки, заканчивает сессию

Участник планирования – участник команды, который после голосования будет выполнять оцениваемую задачу.

Бот/система – бот в телегаме, который отправляет сообщения в общую группу и участникам планирования лично

Сессия – это процесс, во время которого обсуждают несколько задач, которые нужно выполнить за определенный отрезок времени

Задача – функция из проекта, которую нужно выполнить

Оценка показывает сложность задачи

### Сценарии использования

**_SCRUM-мастер_**

Получение сообщения о начале голосования и клавиатуры с оценками - SCRUM-мастер выбирает оценку и отправляет ее боту

Создает группу в телеграме, добавляет бота, пишет команду /new-session - новая сессия создана.

Создание задачи – система запрашивает название задачи и подтверждение запуска голосования, создает задачу, бот отправляет сообщение в группу тг о начале голосования

Принятие оценки (ее посчитали из оценок всех участников) после обсуждения, отправка оценки в группу/ Оценка принимается не по решению мастера, а по результату обсуждения между участниками. Еще здесь важно отметить, что берется медианная оценка, и что мастер вручную вносит оценку

Перезапуск голосования – сообщение о повторном голосовании, новый сбор оценок

Окончание сессии – система формирует JSON результатов голосования за все задачи и отправляет его в ЛС мастеру.

**_Участник планирования (личный чат)_**

Получение сообщения о начале голосования и клавиатуры с оценками - участник выбирает оценку и отправляет ее боту

Выбор и отправка оценки – бот получает оценку

Обсуждение задачи и возможное повторное голосование – изменение итогов голосования

**_Бот/система_**

Отправка сообщения о начале голосования – сообщение отправлено, участники получили сообщение

Отправка участникам названия задачи и клавиатуры для оценки – отправлено сообщение с названием задачи и клавиатура

Получение оценки участника и ее отправка в общую группу – бот проверяет, получены ли все оценки, если да, то бот выводит в общую группу голоса участников и медианную оценку. Бот также должен выводить промежуточные результаты, чтобы начать обсуждение.

Повторное получение оценок - отправка в группу оценок и пересчитанной медианной оценки

Представим сценарий создания сессии. Мастер должен создать группу (группа может переиспользоваться для последующих сессий). Затем добавить туда бота. Далее в группе вызывается команда /master:set , после чего бот пишет в ЛС отправителю команды "секретный код". Далее, человек в группе должен написать этот код. Если все верно, то вызывающий команду становится мастером. Больше команда /master:set в группе не обрабатывается 