FROM node

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./

RUN npm install

# Copy app source
COPY . .

# Expose port and start application
EXPOSE 3000
CMD [ "node", "index.js" ]
