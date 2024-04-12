# Этап сборки приложения
FROM node:20 as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Этап тестирования
FROM node:20 as test
WORKDIR /app
COPY --from=build /app /app
RUN npm install -g artillery
COPY nest.yaml .
CMD ["artillery", "run", "nest.yaml", "--output", "nest.json"]
CMD ["artillery", "report", "nest.json"]

# Финальный этап для запуска приложения
FROM node:20 as production
WORKDIR /app
COPY --from=build /app /app
CMD ["npm", "start"]
