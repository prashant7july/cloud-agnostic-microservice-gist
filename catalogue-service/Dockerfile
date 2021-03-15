FROM node:14-alpine

# redis-cli
# RUN apk --update add redis

# Create app directory
WORKDIR /opt/server

# Install app dependencies
COPY package*.json ./

# Installing node_modules
# RUN npm install
RUN npm install --prod

# Bundle app source, don't use ADD
COPY . .
# COPY server.js /opt/server/

# Make port 8080 available to the world outside this container
EXPOSE 8080

CMD ["node", "server.js"]