<script setup>
import { ref, computed, onMounted } from 'vue';
import { isDev } from '../scripts/utils.js';
import Dialog from 'primevue/dialog';
import Paginator from 'primevue/paginator';
import 'primeicons/primeicons.css';

// Computed for background color
const backgroundColor = computed(() => (isDev ? 'rgba(0, 0, 0, 0.8)' : `rgba(0, 0, 0, ${backgroundTransparency.value})`));

// Dynamic car data structure
const cars = ref([
  {
    name: 'Car 1',
    customname: 'Speedster',
    data: {
      speed: 80,
      weight: 1500,
      hasNeon: true,
      maxSpeed: 320,
      fuelEfficiency: 12,
    }
  },
  {
    name: 'Car 2',
    customname: 'The Beast',
    data: {
      speed: 70,
      weight: 2000,
      hasNeon: false,
      maxSpeed: 240,
      fuelEfficiency: 10,
      isTuned: true,  // New attribute added
    }
  },
  {
    name: 'Car 3',
    customname: 'Thunderbolt',
    data: {
      speed: 90,
      weight: 1300,
      hasNeon: true,
      maxSpeed: 300,
      fuelEfficiency: 14,
    }
  },
]);

// Pagination setup
const itemsPerPage = ref(1);
const first = ref(0);

// Computed for current cars based on pagination
const currentCars = computed(() => cars.value.slice(first.value, first.value + itemsPerPage.value));

// Animation states
const isPageVisible = ref(false);
const areComponentsVisible = ref(false);
onMounted(() => {
  setTimeout(() => {
    isPageVisible.value = true;
    setTimeout(() => {
      areComponentsVisible.value = true;
    }, 800);
  }, 100);
});

// Settings dialog state
const isDialogVisible = ref(false);
const backgroundTransparency = ref(0.0);

// Garage space data
const availableSpaces = ref(10);

// Exit button function
const exitGarage = () => {
  alert('Exiting garage...');
};

// Function to render stat based on its type
const renderStat = (key, value) => {
  if (typeof value === 'boolean') {
    return value ? 'Yes' : 'No';
  } else if (typeof value === 'number') {
    return `${value} ${key === 'weight' ? 'kg' : ''}`;
  } else if (typeof value === 'string') {
    return value;
  }
  return '';
};
</script>


<template>
  <div :style="{ backgroundColor: backgroundColor }" 
       class="public-garage flex flex-col h-screen w-screen justify-center relative overflow-hidden"
       :class="{ 'animate-page': isPageVisible }">
    
    <!-- Top section with title and buttons -->
    <div class="absolute top-4 w-full flex justify-between items-center px-8">
      <h1 class="text-4xl font-extrabold text-white animate-fade text-center w-full">
        {{ isDev ? "Dev's Garage" : "Public Garage" }}
      </h1>
    </div>

    <!-- Available spaces below the garage name -->
    <div class="absolute top-16 w-full text-center">
      <span class="text-sm text-gray-300">({{ availableSpaces }} spaces available)</span>
    </div>

    <!-- Buttons for settings and exit -->
    <div class="absolute right-8 top-4 flex gap-4">
      <button @click="isDialogVisible = true" class="p-button p-button-rounded p-button-secondary" title="Settings">
        <i class="pi pi-cog"></i>
      </button>
      <button @click="exitGarage" class="p-button p-button-rounded p-button-danger" title="Exit">
        <i class="pi pi-sign-out"></i>
      </button>
    </div>

    <!-- Car Info and Stats -->
    <div v-if="areComponentsVisible" class="absolute left-8 top-1/4 w-1/2 fade-in-delayed">
      <div v-for="car in currentCars" :key="car.name">
        <h1 class="text-6xl font-bold text-white mb-2">{{ car.name }}</h1>

        <div v-if="car.customname" class="text-xs text-gray-400 mt-2">
          <p class="text-white">{{ car.customname }}</p>
        </div>
        
        <p class="text-xl italic text-gray-300">{{ car.data.type || 'Unknown Type' }}</p>

        <!-- Compact Car Stats with better visibility -->
        <div class="car-stats mt-4 text-white">
          <div v-for="(value, key) in car.data" :key="key" class="stat-item">
            <p class="text-sm text-gray-300 capitalize">{{ key }}</p>
            <p>{{ renderStat(key, value) }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Paginator -->
    <div class="absolute bottom-4 w-full flex justify-center">
      <Paginator 
        v-model:first="first" 
        :rows="itemsPerPage" 
        :totalRecords="cars.length" 
        class="fade-in-delayed" 
      />
    </div>

    <!-- Settings Dialog -->
    <Dialog v-model:visible="isDialogVisible" header="Settings" :style="{ width: '50vw' }">
      <div>
        <label for="transparency">Background Transparency</label>
        <input type="range" id="transparency" v-model="backgroundTransparency" min="0" max="1" step="0.1" />
      </div>
    </Dialog>
  </div>
</template>


<style scoped>
@keyframes slideInUp {
  from {
    transform: translateY(100%);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.public-garage {
  background-size: cover;
  opacity: 0;
}

.public-garage.animate-page {
  animation: slideInUp 0.8s ease-out forwards;
}

.fade-in-delayed {
  opacity: 0;
  animation: fadeIn 0.6s ease-in forwards;
  animation-delay: 0.9s;
}

.car-stats {
  display: flex;
  flex-direction: column;
}

.stat-item {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.stars {
  display: flex;
  gap: 2px;
}

.stars .pi-star {
  font-size: 18px;
}

.p-button {
  background-color: transparent;
  border: none;
  color: white;
  transition: background-color 0.3s ease, transform 0.3s ease;
}

.p-button:hover {
  background-color: rgba(255, 255, 255, 0.0);
  transform: scale(1.1) rotate(5deg);
}
</style>
