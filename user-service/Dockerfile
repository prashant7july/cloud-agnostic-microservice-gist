#https://stackoverflow.com/questions/48199568/error-ng-app-node-modules-bcrypt-lib-binding-bcrypt-lib-node-invalid-elf-head
#https://derickbailey.com/2017/03/09/selecting-a-node-js-image-for-docker/
FROM node:alpine

# redis-cli
# RUN apk --update add redis

# Create app directory
WORKDIR /opt/server

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./
# COPY package.json ./
# COPY package-lock.json ./

#Installing node_modules
# RUN npm install
RUN npm install --prod
# If you are building your code for production
# RUN npm ci --only=production (https://blog.npmjs.org/post/171556855892/introducing-npm-ci-for-faster-more-reliable)
# RUN npm install --prod

# Bundle app source, don't use ADD
COPY . .
# COPY server.js /opt/server/

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Use node in CMD not npm like CMD ["npm", "start"] which is in package.json 
# CMD ["node", "./bin/www"] it is used in express
CMD ["node", "server.js"]