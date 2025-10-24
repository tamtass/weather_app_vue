<script setup>
import { ref, onMounted, watch } from 'vue';
import axios from 'axios';

const API_KEY = '6bf1b019a26893adad5deb5b97a24c69'; // Replace with your OpenWeatherMap API key
const RAPID_API_KEY = '4cc23413cdmsh6e4dccd74d62d51p18cc52jsn08223dd33c4f'; // Sign up at RapidAPI for GeoDB Cities API
const weather = ref(null);
const city = ref('');
const error = ref('');
const loading = ref(false);
const suggestions = ref([]);
const showDropdown = ref(false);
const searchTimeout = ref(null);

const searchCities = async () => {
  if (city.value.length < 2) {
    suggestions.value = [];
    showDropdown.value = false;
    return;
  }

  try {
    const response = await axios.get('https://wft-geo-db.p.rapidapi.com/v1/geo/cities', {
      params: {
        namePrefix: city.value,
        limit: 5,
        sort: '-population'
      },
      headers: {
        'X-RapidAPI-Key': RAPID_API_KEY,
        'X-RapidAPI-Host': 'wft-geo-db.p.rapidapi.com'
      }
    });
    suggestions.value = response.data.data;
    showDropdown.value = true;
  } catch (e) {
    console.error('Error fetching city suggestions:', e);
    suggestions.value = [];
  }
};

const debouncedSearch = () => {
  if (searchTimeout.value) {
    clearTimeout(searchTimeout.value);
  }
  searchTimeout.value = setTimeout(() => {
    searchCities();
  }, 300);
};

const selectCity = (suggestion) => {
  city.value = `${suggestion.city}, ${suggestion.countryCode}`;
  showDropdown.value = false;
  getWeather();
};

watch(city, () => {
  debouncedSearch();
});

const getWeather = async () => {
  if (!city.value) {
    error.value = 'Please enter a city name';
    return;
  }

  try {
    loading.value = true;
    error.value = '';
    const response = await axios.get(
      `https://api.openweathermap.org/data/2.5/weather?q=${encodeURIComponent(city.value.split(',')[0])}&appid=${API_KEY}&units=metric`
    );
    weather.value = response.data;
    showDropdown.value = false;
  } catch (e) {
    error.value = 'City not found or error fetching weather data';
    weather.value = null;
  } finally {
    loading.value = false;
  }
};

const getWeatherIcon = (iconCode) => {
  return `https://openweathermap.org/img/wn/${iconCode}@2x.png`;
};
</script>

<template>
  <div class="weather-app">
    <h1>Weather App</h1>
    
    <div class="search-box">
      <div class="input-wrapper">
        <input 
          v-model="city" 
          @keyup.enter="getWeather"
          type="text" 
          placeholder="Enter city name"
        >
        <div v-if="showDropdown && suggestions.length" class="suggestions-dropdown">
          <div 
            v-for="suggestion in suggestions" 
            :key="suggestion.id"
            class="suggestion-item"
            @click="selectCity(suggestion)"
          >
            {{ suggestion.city }}, {{ suggestion.countryCode }}
          </div>
        </div>
      </div>
      <button @click="getWeather" :disabled="loading">
        {{ loading ? 'Loading...' : 'Search' }}
      </button>
    </div>

    <p v-if="error" class="error">{{ error }}</p>

    <div v-if="weather" class="weather-info">
      <h2>{{ weather.name }}, {{ weather.sys.country }}</h2>
      <div class="weather-main">
        <img 
          :src="getWeatherIcon(weather.weather[0].icon)" 
          :alt="weather.weather[0].description"
        >
        <div class="temperature">
          {{ Math.round(weather.main.temp) }}°C
        </div>
      </div>
      <div class="weather-details">
        <p class="description">{{ weather.weather[0].description }}</p>
        <p>Feels like: {{ Math.round(weather.main.feels_like) }}°C</p>
        <p>Humidity: {{ weather.main.humidity }}%</p>
        <p>Wind: {{ Math.round(weather.wind.speed * 3.6) }} km/h</p>
      </div>
    </div>
  </div>
</template>

<style>
/* Global styles (removed scoped) */
:root {
  color-scheme: dark;
}

body {
  margin: 0;
  padding: 0;
  background-color: #2A2A2A;
  min-height: 100vh;
}
</style>

<style scoped>

.weather-app {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
  text-align: center;
  background-color: #2A2A2A;
  min-height: 100vh;
  color: #E0E0E0;
}

.search-box {
  margin: 20px 0;
  display: flex;
  justify-content: center;
  gap: 10px;
}

.input-wrapper {
  position: relative;
}

input {
  padding: 10px;
  font-size: 16px;
  border: 1px solid #98D8AA;
  border-radius: 4px;
  width: 300px;
  background-color: #333333;
  color: #E0E0E0;
}

input::placeholder {
  color: #888888;
}

.suggestions-dropdown {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  background: #333333;
  border: 1px solid #98D8AA;
  border-top: none;
  border-radius: 0 0 4px 4px;
  max-height: 200px;
  overflow-y: auto;
  z-index: 1000;
  color: #E0E0E0;
}

.suggestion-item {
  padding: 10px;
  cursor: pointer;
  text-align: left;
}

.suggestion-item:hover {
  background-color: #444444;
}

button {
  padding: 10px 20px;
  font-size: 16px;
  background-color: #98D8AA;
  color: #2A2A2A;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-weight: bold;
  transition: background-color 0.2s;
}

button:hover {
  background-color: #7BC68C;
}

button:disabled {
  background-color: #666666;
  cursor: not-allowed;
  color: #888888;
}

.error {
  color: #FF6B6B;
  margin: 10px 0;
}

.weather-info {
  margin-top: 30px;
  padding: 20px;
  background-color: #333333;
  border-radius: 8px;
  border: 1px solid #98D8AA;
  box-shadow: 0 2px 8px rgba(152, 216, 170, 0.1);
}

.weather-main {
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 20px 0;
}

.weather-main img {
  filter: drop-shadow(0 0 8px rgba(152, 216, 170, 0.3));
}

.temperature {
  font-size: 48px;
  margin-left: 20px;
  color: #98D8AA;
}

.weather-details {
  text-align: left;
  max-width: 300px;
  margin: 0 auto;
}

.description {
  text-transform: capitalize;
  font-size: 1.2em;
  margin-bottom: 10px;
  color: #98D8AA;
}

h1 {
  color: #98D8AA;
  font-size: 2.5em;
  margin-bottom: 30px;
}

h2 {
  color: #7BC68C;
}
</style>
