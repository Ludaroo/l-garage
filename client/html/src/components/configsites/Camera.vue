<script setup>
import { reactive, onMounted, watch } from 'vue';
import { useI18n } from 'vue-i18n';

const { t } = useI18n();

// Props
const props = defineProps({
  configData: {
    type: Object,
    required: true,
  },
});

// Local reactive state for camera settings
const localCameraConfig = reactive({
  spawnCamera: true,
  cameraType: 'default',
  cameraTransitionTimes: [1000, 1000, 1000],
  cameraHeight: 200,
  firstRegisterCamera: {
    camera: [-1004.2181, -2675.6194, 48.1519, -10.54, 0.0, 510.6371, 45.0],
  },
  waitTimeOnStart: 1000,
});

// Load config data into local state on mount
onMounted(() => {
  if (props.configData && props.configData.cameraConfig) {
    Object.assign(localCameraConfig, props.configData.cameraConfig);
  }
});

// Sync changes back to parent configData
watch(
  localCameraConfig,
  (newVal) => {
    if (props.configData) {
      props.configData.cameraConfig = JSON.parse(JSON.stringify(newVal));
    }
  },
  { deep: true }
);

// Tooltip state
const tooltip = reactive({
  visible: false,
  text: '',
  x: 0,
  y: 0,
});

const showTooltip = (text, event) => {
  tooltip.text = text;
  tooltip.visible = true;
  updateTooltipPosition(event);
  document.addEventListener('mousemove', updateTooltipPosition);
};

const hideTooltip = () => {
  tooltip.visible = false;
  document.removeEventListener('mousemove', updateTooltipPosition);
};

const updateTooltipPosition = (event) => {
  tooltip.x = event.clientX + 15;
  tooltip.y = event.clientY + 15;
};
</script>

<template>
  <div class="min-h-screen flex items-center justify-center">
    <!-- <div class="w-[100%] max-h-screen bg-gradient-to-br from-gray-800 via-gray-900 to-black rounded text-white rounded-lg shadow-xl overflow-hidden"> -->
    
      <div class="h-screen overflow-y-auto p-8">
        <h2 class="text-4xl font-extrabold text-center border-b border-gray-600 pb-4">{{ t('cameraSettings') }}</h2>

        <!-- Spawn Camera -->
        <div
          class="mt-8 flex items-center justify-between bg-gray-700 p-5 rounded-lg hover:shadow-lg hover:bg-gray-600 transition-all duration-300"
        >
          <label class="flex items-center space-x-2">
            <span class="text-lg font-medium">{{ t('enableSpawnCamera') }}</span>
            <button
              @mouseenter="showTooltip(t('enableSpawnCameraTooltip'), $event)"
              @mouseleave="hideTooltip"
              class="text-blue-400 hover:text-blue-200 transition"
            >
              ?
            </button>
          </label>
          <input
            type="checkbox"
            v-model="localCameraConfig.spawnCamera"
            class="form-checkbox h-6 w-6 text-blue-500 focus:ring-blue-500 transition-all"
          />
        </div>

        <!-- Camera Type -->
        <div
          class="mt-4 flex items-center justify-between bg-gray-700 p-5 rounded-lg hover:shadow-lg hover:bg-gray-600 transition-all duration-300"
        >
          <label class="flex items-center space-x-2">
            <span class="text-lg font-medium">{{ t('cameraType') }}</span>
            <button
              @mouseenter="showTooltip(t('cameraTypeTooltip'), $event)"
              @mouseleave="hideTooltip"
              class="text-blue-400 hover:text-blue-200 transition"
            >
              ?
            </button>
          </label>
          <select
            v-model="localCameraConfig.cameraType"
            class="bg-gray-800 text-white p-3 rounded-md border border-gray-600 focus:ring-2 focus:ring-blue-500 transition-all duration-300"
          >
            <option value="default">{{ t('default') }}</option>
            <option value="gtaonline">{{ t('gtaonline') }}</option>
            <option value="custom">{{ t('custom') }}</option>
          </select>
        </div>

        <!-- Camera Transition Times -->
        <div
          class="mt-4 bg-gray-700 p-5 rounded-lg hover:shadow-lg hover:bg-gray-600 transition-all duration-300"
        >
          <label class="flex items-center space-x-2 mb-4">
            <span class="text-lg font-medium">{{ t('cameraTransitionTimes') }}</span>
            <button
              @mouseenter="showTooltip(t('cameraTransitionTimesTooltip'), $event)"
              @mouseleave="hideTooltip"
              class="text-blue-400 hover:text-blue-200 transition"
            >
              ?
            </button>
          </label>
          <div class="grid grid-cols-3 gap-4">
            <div>
              <label class="block mb-2 font-semibold">{{ t('timeUp') }}</label>
              <input
                v-model="localCameraConfig.cameraTransitionTimes[0]"
                type="number"
                class="w-full p-3 rounded-lg bg-gray-800 text-white border border-gray-600 focus:ring-2 focus:ring-blue-500 transition-all duration-300"
                placeholder="Time Up (ms)"
              />
            </div>
            <div>
              <label class="block mb-2 font-semibold">{{ t('timeToDestination') }}</label>
              <input
                v-model="localCameraConfig.cameraTransitionTimes[1]"
                type="number"
                class="w-full p-3 rounded-lg bg-gray-800 text-white border border-gray-600 focus:ring-2 focus:ring-blue-500 transition-all duration-300"
                placeholder="To Destination (ms)"
              />
            </div>
            <div>
              <label class="block mb-2 font-semibold">{{ t('timeDown') }}</label>
              <input
                v-model="localCameraConfig.cameraTransitionTimes[2]"
                type="number"
                class="w-full p-3 rounded-lg bg-gray-800 text-white border border-gray-600 focus:ring-2 focus:ring-blue-500 transition-all duration-300"
                placeholder="Time Down (ms)"
              />
            </div>
          </div>
        </div>

        <!-- Wait Time on Start -->
        <div
          class="mt-4 flex items-center justify-between bg-gray-700 p-5 rounded-lg hover:shadow-lg hover:bg-gray-600 transition-all duration-300"
        >
          <label class="flex items-center space-x-2">
            <span class="text-lg font-medium">{{ t('waitTimeOnStart') }}</span>
            <button
              @mouseenter="showTooltip(t('waitTimeOnStartTooltip'), $event)"
              @mouseleave="hideTooltip"
              class="text-blue-400 hover:text-blue-200 transition"
            >
              ?
            </button>
          </label>
          <input
            v-model="localCameraConfig.waitTimeOnStart"
            type="number"
            class="w-1/2 p-3 rounded-lg bg-gray-800 text-white border border-gray-600 focus:ring-2 focus:ring-blue-500 transition-all duration-300"
            placeholder="Wait Time (ms)"
          />
        </div>

        <!-- Tooltip -->
        <div
          v-if="tooltip.visible"
          class="fixed z-50 bg-gray-900 text-white text-sm p-3 rounded shadow-lg transition-opacity duration-300"
          :style="{ top: tooltip.y + 'px', left: tooltip.x + 'px' }"
        >
          {{ tooltip.text }}
        </div>
      <!-- </div> -->
    </div>
  </div>
</template>

<style scoped>
/* Fade-in animation */
@keyframes fade-in {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
.animate-fade-in {
  animation: fade-in 0.5s ease-out;
}
</style>
