FROM node

WORKDIR /app/backend
RUN npm install && npm install -g nodemon

ENV AWS_ACCESS_KEY_ID ${AWS_ACCESS_KEY_ID}
ENV AWS_SECRET_ACCESS_KEY ${AWS_SECRET_ACCESS_KEY}

COPY backend /app/backend

EXPOSE 3000
CMD ["nodemon", "backend/index.js"]
