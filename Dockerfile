FROM node:latest

#Ruta de docker para subir app al contenedor
RUN mkdir -p /home/app

#Ruta donde esta al app (local)
COPY . .


EXPOSE 3000
#RUN npm install

CMD ["node", "server.js"]
