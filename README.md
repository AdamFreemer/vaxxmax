# Vaccinator Availability App

![Heroku](https://heroku-badge.herokuapp.com/?app=heroku-badge)

This application pings locations based off their store ID and checks for vaccine availability. 

Application notes:

* Currently running on Heroku at: https://vaccinator-app.herokuapp.com/

* The application only pings Rite Aid stores currently. 

* On Heroku, all ~2500 Rite Aid store locations are loaded in the database.

* A background job pings all stores in regional batches roughly every 10 minutes.

