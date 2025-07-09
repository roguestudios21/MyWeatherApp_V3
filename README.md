# MyWeatherApp

A simple and elegant iOS weather app built with SwiftUI.  
It shows the current weather, forecast details, and supports multiple cities.

---

## Features
- View current weather, temperature, humidity, wind speed, and description
- Navigate between multiple days’ forecasts
- See detailed forecast information in an overlay card
- Select from a list of popular cities
- Clean and minimal UI with dynamic backgrounds (images)

## CitySelectView 
In this View the user must select the city of his choice, in this View the names of city that are available using the api are listed using list function, when a name of city is clicked it's stored in core data for future refrence and at the same time it triggers api call for the weather data for that city and displays MainWeatherView using Navigation Link.

<img width="311" alt="Screenshot 2025-07-09 at 9 52 06 PM" src="https://github.com/user-attachments/assets/d701dc08-6d34-4cf1-a99c-9630d3ba1ac3" />


## MainWeatherView 
In this View the VStack Consist of City Name, Day of the week, SF Symbol, Temperature, description of weather, Button labelled "details which trigger, DetailedWeatherView and finally a Hstack which consits of two to display next day weather and previous day weather,
to display next day and previous day weather the MainWeatherView is reused with weather data of that particular day.

<img width="310" alt="Screenshot 2025-07-09 at 9 54 02 PM" src="https://github.com/user-attachments/assets/74729714-6cd4-4941-839e-d491385f6974" />


## DetailedWeatherView
This View is Triggered when Details Button is clicked on MAinWeatherView, this View is like a card which uses scrollable view to list various other aspects of weather report like Temperature, Humidity, Wind Speed, Wind Direction, Description. With a dismiss button on the top to dismiss this view.

<img width="309" alt="Screenshot 2025-07-09 at 9 52 55 PM" src="https://github.com/user-attachments/assets/ce715c5d-8b35-49f9-aabf-c16a427008fa" />

## Background Image
This was done using cases bases in which particular SF symbol and background image were grouped to display based on icon code provided from the api.

## Cosmetic Elements 
Various cosmetic UI elemtents are used in various places like, opacity in button, SF symbols to signature apple look, blur effect on the MainWeatherView when DetailsWeatherView appear, opacity is even applied to DetailsWeatherView to give new signature iOS26 Glass like feel with drop shadows surrounding the card.

## API Calling
In this Case Network Manager fetch weather data from the OpenWeather API. It retrieves both the current weather and a multi-day forecast for a given city, handles loading and error states, and decodes JSON responses into Swift models. The class is cleanly structured to update the UI reactively and ensures only one network request runs at a time by managing its Combine cancellable.

## Demo Video



https://github.com/user-attachments/assets/80aa6cbe-1233-45fa-be0f-544def01134c






