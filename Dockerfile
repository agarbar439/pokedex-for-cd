# Stage 1: Build
FROM node:22-alpine AS builder
WORKDIR /app

# Copy package.json to install dependencies
COPY package.json ./
RUN npm install

# Copy the rest of the application code and build the application
COPY . .
RUN npm run build

#Stage 2: Run
FROM node:22-alpine
WORKDIR /app

# Copy the built application from the builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
COPY --from=builder /app/app.js ./app.js

# NODE_ENV is set to production
ENV NODE_ENV=production

# Expose the port the app runs on
EXPOSE 5000

# Start the application
CMD ["npm", "start"]
