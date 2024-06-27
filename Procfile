release: bin/rails db:migrate
web: bin/rails server
worker: QUEUE=* rake resque:work
pdf: node puppeteer/app.js
