<script setup>
import { ref, onMounted, onUnmounted } from 'vue';

// Reactive state for visibility
const display = ref(false);

// Event handler to toggle visibility
const toggleDisplay = (value) => {
  display.value = value;
};

// Add event listener when the component is mounted and remove it when unmounted
onMounted(() => {
  window.addEventListener('message', (event) => {
    console.log("what")
    if (event.data.type === 'toggle-triangle') {
      console.log(event.data.display)
      toggleDisplay(event.data.display);
    }
  });
});


</script>

<template>
  <div>
    <!-- Triangle visibility toggles based on 'display' -->
    <div 
      v-if="display" 
      style="
        width: 0;
        height: 0;
        border-left: 50px solid transparent;
        border-right: 50px solid transparent;
        border-bottom: 100px solid red;
        background: transparent;
      ">
    </div>
  </div>
</template>
