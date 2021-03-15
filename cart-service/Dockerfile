FROM node:14-alpine

# Create app directory
WORKDIR /opt/server

COPY package*.json ./

# Installing node_modules
# RUN npm install
RUN npm install --prod

# Bundle app source, don't use ADD
COPY . .

# Make port 8080 available to the world outside this container
EXPOSE 8080

CMD ["node", "server.js"]