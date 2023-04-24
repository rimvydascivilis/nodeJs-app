FROM node:20-alpine

WORKDIR /app
COPY dist /app/dist
COPY package.json /app
COPY package-lock.json /app

ENV PORT 8080
EXPOSE 8080

CMD ["npm", "run", "production"]
