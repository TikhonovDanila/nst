# Сначала создаем образ для приложения
FROM node:19-alpine as app

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем файлы package.json и package-lock.json для установки зависимостей
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем все файлы приложения
COPY . .

# Команда для запуска приложения
CMD ["npm", "start"]

# Затем создаем образ для проведения тестов
FROM app as tests

# Устанавливаем artillery глобально
RUN npm install -g artillery

# Копируем файл конфигурации тестов
COPY nest.yml .

# Запускаем тесты и создаем отчет JSON
CMD ["artillery", "run", "nest.yml", "--output", "output.json"]

# Создаем HTML отчет
RUN artillery report output.json --output index.html

# Копируем HTML отчет в рабочую директорию
COPY index.html ./

