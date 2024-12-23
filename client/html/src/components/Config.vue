<script setup>
import { ref, onMounted, watch, computed } from "vue";
import { useStore } from "vuex";
import { useI18n } from "vue-i18n";
import Camera from "./configsites/Camera.vue";
import Locations from "./configsites/Locations.vue";
import ConfigIndex from "./configsites/ConfigIndex.vue";
import Settings from "./configsites/Settings.vue";
// Locale setup
const { t, locale } = useI18n();

const activeTab = ref("home"); // Default active tab
const isSidebarCollapsed = ref(true); // Sidebar starts collapsed
const loading = ref(true);
const errorMessage = ref("");
const configData = ref({
  cameraConfig: {},
  locationsConfig: [],
  defaultSettings: {},
});

const store = useStore();

const config = computed(() => store.state.config);
const changelog = computed(() => store.state.changelog);

// Locale persistence
locale.value = localStorage.getItem("locale") || "en";
watch(locale, (newLocale) => {
  localStorage.setItem("locale", newLocale);
});


onMounted(() => {
  store.dispatch("loadConfig");
  loading.value = false
});;

const saveConfig = () => {
  store.dispatch("saveConfig");
};


</script>

<template>
  <div class="fixed inset-0 flex items-center justify-center bg-gray-900 bg-opacity-95">
    <!-- Tablet Container -->
    <div class="relative w-[85%] h-[85%] bg-gradient-to-br from-gray-800 via-gray-900 to-black text-white rounded-[30px] shadow-2xl flex overflow-hidden">
      <!-- MacOS Style Exit Button -->
      <button
        class="absolute top-4 right-4 w-4 h-4 bg-red-600 rounded-full shadow-lg hover:bg-red-500 transition"
        @click="activeTab = 'exit'"
      ></button>

      <!-- Navigation Bar (Left Sidebar) -->
      <div
        :class="[
          'bg-gray-800 text-white flex flex-col items-center py-6 transition-all duration-300 ease-in-out',
          isSidebarCollapsed ? 'w-16' : 'w-56',
        ]"
      >
        <!-- Logo -->
        <div class="relative flex items-center justify-center w-full h-16">
          <img
            src="../../img/logo.png"
            alt="Logo"
            class="w-14 h-14 object-contain cursor-pointer"
            @click="isSidebarCollapsed = !isSidebarCollapsed"
          />
        </div>

        <!-- Navigation Buttons -->
        <ul class="space-y-6 flex-grow px-2 mt-6">
          <li
            v-for="tab in [
              { name: 'home', icon: 'co-home' },
              { name: 'camera', icon: 'bi-camera-video' },
              { name: 'locations', icon: 'la-map-solid' }
            ]"
            :key="tab.name"
            :class="{
              'text-myscriptsblue2': activeTab === tab.name,
              'text-gray-300': activeTab !== tab.name
            }"
            class="flex items-center gap-4 py-2 px-2 rounded-lg cursor-pointer hover:text-myscriptsblue1 transition-all"
            @click="activeTab = tab.name"
          >
            <OhVueIcon :name="tab.icon" class="w-6 h-6 transform transition-transform duration-300 ease-in-out" />
            <transition name="fade-slide">
              <span v-if="!isSidebarCollapsed" class="transition-opacity">
                {{ t(tab.name) }}
              </span>
            </transition>
          </li>
        </ul>

        <!-- Settings Button -->
        <div
          class="w-full px-4 mt-4"
          @click="activeTab = 'settings'"
        >
          <div
            class="flex items-center py-2 px-2 rounded-lg cursor-pointer hover:text-myscriptsblue1 transition-all"
            :class="{
              'text-myscriptsblue2': activeTab === 'settings',
              'text-gray-300': activeTab !== 'settings'
            }"
          >
            <OhVueIcon name="bi-gear-fill" class="w-6 h-6 transform transition-transform duration-300 ease-in-out" />
            <transition name="fade-slide">
              <span v-if="!isSidebarCollapsed" class="transition-opacity">
                {{ t("settings") }}
              </span>
            </transition>
          </div>
        </div>
      </div>

      <!-- Main Content Area -->
      <div class="flex-grow p-6 rounded-[30px] my-3 mx-3">
        <div v-if="loading" class="text-center text-gray-400 animate-pulse">
          {{ t("loading") }}
        </div>
        <div v-else-if="errorMessage" class="text-center text-red-400">
          {{ errorMessage }}
        </div>
        <div v-else>
          <!-- Home Page -->
          <div v-if="activeTab === 'home'" class="text-center">
            <ConfigIndex :configData="configData.value" />
          </div>

          <!-- Camera Page -->
          <div v-else-if="activeTab === 'camera'">
            <Camera :configData="configData.value" />
          </div>

          <!-- Locations Page -->
          <div v-else-if="activeTab === 'locations'">
            <Locations :configData="configData.value" />
          </div>

          <!-- Settings Page -->
          <div v-else-if="activeTab === 'settings'" class="text-center space-y-6">
           <Settings :configData="configData.value"/>
          </div>

          <!-- Exit Page -->
          <div v-else-if="activeTab === 'exit'" class="text-center">
            <h1 class="text-2xl font-bold mb-4">{{ t("exiting") }}</h1>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<!-- Add the fade-slide transition -->
<style>
.fade-slide-enter-active,
.fade-slide-leave-active {
  transition: all 0.3s ease;
}
.fade-slide-enter-from,
.fade-slide-leave-to {
  opacity: 0;
  transform: translateX(-20px);
}
.group-hover\:opacity-100 {
  transition: opacity 0.3s;
}
</style>
