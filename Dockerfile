# Use official Node.js LTS image
FROM node:20-alpine

# Create app directory
WORKDIR /app

# Copy package.json and app files
COPY package.json .
COPY app/ ./app/

# Install dependencies
RUN npm install

# Expose port 80
EXPOSE 80

# Start the app
CMD ["npm", "start"]
